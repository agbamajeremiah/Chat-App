import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/models/messages.dart';

class SocketServices {
  SocketIO socketIO;
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();

  void connectSockets() {
    socketIO =
        SocketIOManager().createSocketIO('<ENTER_YOUR_SERVER_URL_HERE>', '/');
    socketIO.init();

    socketIO.subscribe('receive_message', (jsonData) {
      // Map<String, dynamic> data = json.decode(jsonData);
      // messages.add(Message(
      //     data['content'], data['senderChatID'], data['receiverChatID']));
    });
    socketIO.connect();
  }
}
