import 'dart:convert';
import 'package:MSG/constant/base_url.dart';
import 'package:MSG/models/messages.dart';
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
    socketIO.subscribe('receive_message', (jsonData) {
      // Map<String, dynamic> data = json.decode(jsonData);
      // messages.add(Message(
      //     data['content'], data['senderChatID'], data['receiverChatID']));
    });
    socketIO.connect();
  }

  void registerSocketId() {
    socketIO.sendMessage(
        'identity',
        json.encode({
          'chatId': _authService.userNumber,
        }));
  }

  void sendChatMessage(Message msg) async {
    if (socketIO != null) {
      var msgJsonData = {"message": "test"};
      socketIO.sendMessage("new message", msgJsonData, _onReceiveChatMessage);
    }
  }

  void _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  void _onReceiveChatMessage(dynamic message) {
    print("Message from server: " + message);
  }
}
