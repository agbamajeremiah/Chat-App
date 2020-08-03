import 'package:MSG/models/contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactServices {
  Future<List<MyContact>> getAllContacts() async {
    List<MyContact> contactsAll;
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      //We can now access our contacts here
      Iterable<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      if (contacts.length > 0) {
        List<MyContact> _allContacts(Iterable<Contact> contacts) {
          return contacts.map((con) {
            return MyContact(
              contactId: con.identifier,
              fullName: con.displayName ?? "",
              number: con.phones.toList()[0].value ?? "",
            );
          }).toList();
        }

        contactsAll = _allContacts(contacts);
      } else {
        contactsAll = null;
      }
    }
    return contactsAll;
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }
}
