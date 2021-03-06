import 'dart:convert';
import 'package:MSG/constant/base_url.dart';
// import 'package:MSG/models/messages.dart';
// import 'package:MSG/services/database_service.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/locator.dart';

class SocketServices {
  SocketIO socketIO;
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();
  List<String> _subscribedNumbers = [];
  List get subscribedNumbers => _subscribedNumbers;

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
    socketIO.subscribe('new message', (dynamic socketMessage) {
      // print("Socket Message:");
      // var newMessage = json.decode(socketMessage);
      // Map message = newMessage['message'][0];
      // print("Socket message inserted");
      // print(message);
      // if (message['sender'] != _authService.userNumber) {
      //   print("new message received");
      //   DatabaseService.db.insertNewMessage(Message.fromMap(message));
      //   rebuild();
      // }
    });
    _subscribedNumbers.add(phoneNumber);
    socketIO.subscribe('mark as read', (dynamic socketMessage) {
      print("Socket Read Message:");
      var update = json.decode(socketMessage);
      print(update);
      // List updatedMesssages = update['message'];
      // if (updatedMesssages.length > 0) {
      //   updatedMesssages.forEach((mes) async {
      //     if (mes['sender'] == _authService.userNumber &&
      //         mes['status'] == 'READ') {
      //       await DatabaseService.db
      //           .updateMessageStatus(mes['messageId'], mes['status']);
      //     }
      //   });
      //   rebuild();
      // }
    });
  }

  void _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }
}
