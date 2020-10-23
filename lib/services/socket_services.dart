import 'dart:convert';
import 'package:MSG/constant/base_url.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/services/database_service.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/locator.dart';

class SocketServices {
  SocketIO socketIO;
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();

  void connectSockets() {
    socketIO = SocketIOManager()
        .createSocketIO(BasedUrl, '/', socketStatusCallback: _socketStatus);
    socketIO.init();
    socketIO.connect();
  }

  void registerSocketId() {
    socketIO.sendMessage(
        'identity',
        json.encode({
          'chatId': _authService.userNumber,
        }));
  }

  void subscribeToThread(
      String threadId, String phoneNumber, Function rebuild) {
    socketIO.sendMessage('subscribe',
        json.encode({'threadId': threadId, 'otherUserId': phoneNumber}));
    print(phoneNumber);
    print("subscribed to :" + threadId);
    socketIO.subscribe('new message', (dynamic socketMessage) {
      print("Socket Message:");
      var newMessage = json.decode(socketMessage);
      Map message = newMessage['message'][0];
      print("Socket message inserted");
      print(message);
      DatabaseService.db.insertNewMessage(Message.fromMap(message));
      rebuild();
    });
    socketIO.subscribe('mark as read', (dynamic socketMessage) {
      print("Socket Read Message:");
      var update = json.decode(socketMessage);
      // print(update);RE
      List updatedMesssages = update['message'];
      if (updatedMesssages.length > 0) {
        updatedMesssages.forEach((mes) async {
          await DatabaseService.db
              .updateReadMessages(mes['_id'], mes['status']);
        });
      }
    });
  }

  void _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }
}
