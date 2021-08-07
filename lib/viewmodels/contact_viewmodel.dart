import 'package:MSG/core/network/network_info.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/services/contact_services.dart';
import 'package:MSG/services/database_service.dart';
import 'package:stacked/stacked.dart';

class ContactViewModel extends BaseViewModel {
  final ContactServices _contactService = locator<ContactServices>();
  final NetworkInfo _networkInfo = locator<NetworkInfo>();

  bool refreshingContacts = false;
  //Fetch all registered contacts from database
  Future<Map<String, List<MyContact>>> getContactsFromDb() async {
    List<MyContact> regContacts =
        await DatabaseService.db.getRegContactsFromDb();
    List<MyContact> unRegContacts =
        await DatabaseService.db.getUnRegContactsFromDb();
    Map<String, List<MyContact>> contacts = {
      "registeredContacts": regContacts,
      "unregisteredContacs": unRegContacts
    };
    return contacts;
  }

  Future synContacts() async {
    refreshingContacts = true;
    setBusy(true);
    if (await _networkInfo.isConnected) {
      try {
        await _contactService.syncContacts();
      } catch (e) {
        print(e.toString());
      }
    }
    refreshingContacts = false;
    setBusy(false);
  }
  
  // Future backgroundSyncContacts() async {
  //   final internetStatus = await checkInternetConnection();
  //   if (internetStatus == true) {
  //     try {
  //       await _contactService.syncContacts();
  //     } catch (e) {
  //       print(e.toString());
  //     }
  //   }
  // }
}
