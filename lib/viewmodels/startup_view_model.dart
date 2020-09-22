import 'dart:convert';
import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:MSG/constant/base_url.dart';
import 'base_model.dart';

class StartUpViewModel extends BaseModel {
  SocketIO socketIO;
  final AuthenticationSerivice _authenticationService =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
    if (hasLoggedInUser) {
      _connectSockets();
      _registerSocketId();
      _navigationService.clearLastAndNavigateTo(MessageViewRoute);
    } else {
      _navigationService.clearLastAndNavigateTo(LoginViewRoute);
    }
  }

  void _connectSockets() {
    socketIO = SocketIOManager().createSocketIO(BasedUrl, '/');
    socketIO.init();
    socketIO.subscribe('receive_message', (jsonData) {
      // Map<String, dynamic> data = json.decode(jsonData);
      // messages.add(Message(
      //     data['content'], data['senderChatID'], data['receiverChatID']));
    });
    socketIO.connect();
  }

  void _registerSocketId() {
    socketIO.sendMessage(
      'identity',
      json.encode({
        'chatId': _authenticationService.userNumber,
      }),
    );
  }
}
