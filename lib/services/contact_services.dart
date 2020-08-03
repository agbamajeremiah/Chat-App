import 'package:MSG/models/contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactServices {
  final ContactServices _contactService = locator<ContactServices>();

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

//Sync User contacts from server
Future syncAllContact(List uploadContacts) async {
  print(uploadContacts);
  sendContacts(uploadContacts);
}

Future sendContacts(List allContacts) async {
  final _userToken = _authService.token;
  print("userToken: ");
  print(_userToken);
  try {
    Map<String, dynamic> body = {
      "contacts": allContacts,
    };
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "authorization": "Bearer $_userToken",
    };
    var response = await postResquest(
      url: "/register",
      body: body,
      headers: headers,
    );
    print(response);
    return response;
  } catch (e) {
    if (e is DioError) {
      debugPrint(
        e.response.data,
      );
    }
    print(e.runtimeType);
    print(e.toString());
    throw e;
  }
}
