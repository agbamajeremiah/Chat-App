import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/contact_services.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'base_model.dart';

class StartUpViewModel extends BaseModel {
  final AuthenticationSerivice _authenticationService =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ContactServices _contactService = locator<ContactServices>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    if (hasLoggedInUser) {
      getAllContactsFromDevice().then((value) =>
          _navigationService.clearLastAndNavigateTo(MessageViewRoute));
    } else {
      _navigationService.clearLastAndNavigateTo(LoginViewRoute);
    }
  }

  Future getAllContactsFromDevice() async {
    List<String> uploadContacts = List<String>();
    List<MyContact> allContacts = await _contactService.getAllContacts();
    //print(allContacts);
    allContacts.forEach((con) {
      uploadContacts.add(con.phoneNumber);
      DatabaseService.db.insertContact(con);
    });
    //print(uploadContacts);
    /*List<MyContact> regContacts =
        await _contactService.getRegisteredContact(uploadContacts);
    regContacts.forEach((cont) {

    });*/
  }
}
