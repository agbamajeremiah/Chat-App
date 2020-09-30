import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'base_model.dart';

class StartUpViewModel extends BaseModel {
  SocketIO socketIO;
  final AuthenticationSerivice _authenticationService =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
    if (hasLoggedInUser) {
      await Future.delayed(Duration(seconds: 1)).whenComplete(
          () => _navigationService.clearLastAndNavigateTo(MessageViewRoute));
    } else {
      _navigationService.clearLastAndNavigateTo(LoginViewRoute);
    }
  }
}
