import 'package:MSG/locator.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/services/contact_services.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/utils/connectivity.dart';
import 'package:stacked/stacked.dart';

class ContactViewModel extends BaseViewModel {
  final ContactServices _contactService = locator<ContactServices>();
  bool refreshingContacts = false;
  //Fetch all registered contacts from database
  Future<Map<String, List<MyContact>>> getContactsFromDb() async {
    List<MyContact> regContacts =
        await DatabaseService.db.getRegContactsFromDb();
    print("registered Contact:");
    List<MyContact> unRegContacts =
        await DatabaseService.db.getUnRegContactsFromDb();
    Map<String, List<MyContact>> contacts = {
      "registeredContacts": regContacts,
      "unregisteredContacs": unRegContacts
    };
    return contacts;
  }

  Future syncContacts() async {
    refreshingContacts = true;
    setBusy(true);
    final internetStatus = await checkInternetConnection();
    if (internetStatus == true) {
      try {
        await _contactService.syncContacts();
      } catch (e) {
        print(e.toString());
      }
    }
    refreshingContacts = false;
    setBusy(false);
  }
}
