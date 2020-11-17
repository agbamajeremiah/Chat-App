import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/contact_services.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'base_model.dart';

class StartUpViewModel extends BaseModel {
  //4978328
  SocketIO socketIO;
  final AuthenticationSerivice _authenticationService =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ContactServices _contactService = locator<ContactServices>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
    if (hasLoggedInUser) {
      await Future.delayed(Duration(milliseconds: 500)).whenComplete(
          () => _navigationService.clearLastAndNavigateTo(MessageViewRoute));
    } else {
      _contactService.fetchContactFromDevice();
      _navigationService.clearLastAndNavigateTo(LoginViewRoute);
    }
  }
}
