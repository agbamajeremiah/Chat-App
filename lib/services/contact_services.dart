import 'package:MSG/locator.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/core/network/api_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactServices {
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();
  // Fetch all contacts from device
  Future fetchContactFromDevice() async {
    List<MyContact> allContacts = await getAllContactsFromDevice();
    allContacts.forEach((con) async {
      var isContactSaved =
          await DatabaseService.db.checkIfContactExist(con.phoneNumber);
      if (isContactSaved != true) {
        await DatabaseService.db.insertContact(con);
      } else {
        Map<String, dynamic> contactData = {
          DatabaseService.COLUMN_NAME: con.fullName,
          DatabaseService.COLUMN_SAVED_PHONE: 1
        };
        await DatabaseService.db.updateRegContact(contactData, con.phoneNumber);
      }
    });
    return allContacts;
  }

  //Start of contact synchronization
  Future firstSyncContacts() async {
    List<String> uploadContacts = [];
    List<MyContact> unSyncContacts =
        await DatabaseService.db.geContactsForSyncFromDb();
    unSyncContacts.forEach((contact) {
      uploadContacts.add(contact.phoneNumber);
    });
    List<MyContact> regContacts = await getServerRegContacts(uploadContacts);
    regContacts.forEach((cont) async {
      Map<String, dynamic> contactData = {
        DatabaseService.COLUMN_CHAT_ID: cont.chatId,
        DatabaseService.COLUMN_PROFILE_PICTURE_URL: cont.profilePictureUrl,
        DatabaseService.COLUMN_REG_STATUS: 1,
      };
      await DatabaseService.db.updateRegContact(contactData, cont.phoneNumber);
    });
  }

  //Normal Contact synchronization
  Future syncContacts() async {
    List<String> uploadContacts = [];
    List<MyContact> allContacts = await fetchContactFromDevice();
    allContacts.forEach((con) async {
      uploadContacts.add(con.phoneNumber);
    });
    List<MyContact> unSyncContacts =
        await DatabaseService.db.geContactsForSyncFromDb();
    unSyncContacts.forEach((contact) {
      uploadContacts.add(contact.phoneNumber);
    });
    // print("Upload contacts: $uploadContacts");
    List<MyContact> regContacts = await getServerRegContacts(uploadContacts);
    regContacts.forEach((cont) async {
      // print(cont);
      Map<String, dynamic> contactData = {
        DatabaseService.COLUMN_CHAT_ID: cont.chatId,
        DatabaseService.COLUMN_REG_STATUS: 1,
        DatabaseService.COLUMN_PROFILE_PICTURE_URL: cont.profilePictureUrl,
      };
      await DatabaseService.db.updateRegContact(contactData, cont.phoneNumber);
    });
  }

  //get contacts from device);
  Future<List<MyContact>> getAllContactsFromDevice() async {
    List<MyContact> contactsAll = [];
    final PermissionStatus permissionStatus = await _getPhonePermission();
    if (permissionStatus == PermissionStatus.granted) {
      //We can now access our contacts here
      Iterable<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      // print(contacts);
      if (contacts.length > 0) {
        contacts.forEach((con) {
          // print(con.phones.toList());
          contactsAll.add(MyContact(
            fullName: con.displayName,
            phoneNumber: con.phones.length == 0
                ? ""
                : con.phones.toList()[0].value.replaceAll(" ", ""),
            regStatus: 0,
            pictureDownloaded: 0,
            savedPhone: 1,
          ));
        });
      }
    }
    return contactsAll;
  }

  //Check contacts, storage permission
  Future<PermissionStatus> _getPhonePermission() async {
    var notificationPermission = await Permission.notification.status;
    if (!notificationPermission.isGranted || notificationPermission.isDenied) {
      await Permission.notification.request();
    }
    var storagePermission = await Permission.storage.status;
    if (!storagePermission.isGranted || storagePermission.isDenied) {
      await Permission.storage.request();
    }
    var contactPermission = await Permission.contacts.status;
    if (!contactPermission.isGranted || contactPermission.isDenied) {
      final contactPermissionStatus = await Permission.contacts.request();
      return contactPermissionStatus;
    } else {
      return contactPermission;
    }
  }

  //Sync User contacts from server
  Future<List<MyContact>> getServerRegContacts(List uploadContacts) async {
    List<MyContact> regContacts = [];
    dynamic response = await sendContacts(uploadContacts);
    List<dynamic> contactsData = response.data['contacts'];
    contactsData.forEach((contact) {
      regContacts.add(MyContact.fromSyncMap(contact));
    });
    return regContacts;
  }

  //send contact list to server
  Future sendContacts(contacts) async {
    final _userToken = _authService.token;
    try {
      Map<String, List> body = {
        "contacts": contacts,
      };
      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer $_userToken",
      };
      var response = await postFormResquest(
        url: "/registercontact",
        headers: headers,
        body: body,
      );
      // print(response);
      return response;
    } catch (e) {
      if (e is DioError) {
        debugPrint(
          e.response.data,
        );
      }
      debugPrint(e.toString());
      throw e;
    }
  }
}
