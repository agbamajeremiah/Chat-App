import 'dart:convert';
import 'package:MSG/constant/base_url.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/services/database_service.dart';
// import 'package:MSG/models/messages.dart';
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

  void subscribeToThread(String threadId) {
    socketIO.sendMessage('subscribe', json.encode({'threadId': threadId}));
    socketIO.subscribe('new message', (dynamic socketMessage) {
      print("Socket Message:");

      var newMessage = json.decode(socketMessage);
      print(newMessage['message']);
      List messages = newMessage['message'];
      messages.forEach((message) async {
        print("Socket message inserted");
        print(message);
        await DatabaseService.db.insertNewMessage(Message.fromMap(message));
      });
    });
  }

  void _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }
}