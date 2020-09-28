import 'package:MSG/locator.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/utils/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactServices {
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();
  //Start of contact synchronization
  Future syncContacts() async {
    //DatabaseService.db.deleteDb();
    List<String> uploadContacts = List<String>();
    List<MyContact> allContacts = await getAllContactsFromDevice();
    // print("All Contacts: " + allContacts.toString());
    allContacts.forEach((con) async {
      //uploadContacts.add(con.phoneNumber);
      await DatabaseService.db.insertContact(con);
    });
    List<MyContact> unSyncContacts =
        await DatabaseService.db.getUnRegContactsFromDb();

    unSyncContacts.forEach((contact) {
      uploadContacts.add(contact.phoneNumber);
    });
    print(uploadContacts);
    List<MyContact> regContacts = await getRegisteredContact(uploadContacts);
    print("reg Contacts:");
    print(regContacts);
    regContacts.forEach((cont) async {
      print(cont.toMap());
      String phoneNumber =
          cont.phoneNumber.substring(5, cont.phoneNumber.length);
      await DatabaseService.db.updateRegContact(phoneNumber);
    });
  }

  //get contacts from device);
  Future<List<MyContact>> getAllContactsFromDevice() async {
    List<MyContact> contactsAll = List<MyContact>();
    final PermissionStatus permissionStatus = await _getPermission();
    print(permissionStatus);
    if (permissionStatus == PermissionStatus.granted) {
      //We can now access our contacts here
      Iterable<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      print(contacts);
      if (contacts.length > 0) {
        contacts.forEach((con) {
          print(con.phones.toList());
          contactsAll.add(MyContact(
              contactId: con.identifier,
              fullName: con.displayName ?? "",
              phoneNumber: con.phones.length == 0
                  ? ""
                  : con.phones.toList()[0].value.replaceAll(
                      " ", ""), //con.phones.toList()[0].value ?? "",
              regStatus: 0));
        });
      }
    }
    return contactsAll;
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    var permission = await Permission.contacts.status;
    if (permission.isUndetermined || permission.isDenied) {
      //await Permission.contacts.request();
      final permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  //Sync User contacts from server
  Future<List<MyContact>> getRegisteredContact(List uploadContacts) async {
    List<MyContact> regContacts = [];
    dynamic response = await sendContacts(uploadContacts);
    //print(response);
    List<dynamic> contactsData = response.data['contacts'];
    contactsData.forEach((contact) {
      regContacts.add(MyContact.fromSyncMap(contact));
    });
    return regContacts;
  }

  //send contact list to server
  Future sendContacts(contacts) async {
    final _userToken = _authService.token;
    print(_userToken);
    print(contacts);
    try {
      Map<String, List> body = {
        "contacts": contacts,
      };
      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer $_userToken",
      };
      var response = await postResquest(
        url: "/registercontact",
        headers: headers,
        body: body,
      );
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
}
