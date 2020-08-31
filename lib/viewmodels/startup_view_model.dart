import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/contact_services.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/utils/connectivity.dart';
import 'base_model.dart';

class StartUpViewModel extends BaseModel {
  final AuthenticationSerivice _authenticationService =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ContactServices _contactService = locator<ContactServices>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
    if (hasLoggedInUser) {
      _navigationService.clearLastAndNavigateTo(MessageViewRoute);
      final internetStatus = await checkInternetConnection();
      if (internetStatus == true) {
        await syncContacts();
      }
    } else {
      _navigationService.clearLastAndNavigateTo(LoginViewRoute);
    }
  }

  Future syncContacts() async {
    try {
      await _contactService.syncContacts();
    } catch (e) {
      print(e.toString());
    }
  }
}
