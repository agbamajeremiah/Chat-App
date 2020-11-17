import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/contact_services.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/utils/api_request.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class UpdateProvfileViewModel extends BaseModel {
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ContactServices _contactService = locator<ContactServices>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future _getDeviceToken() async {
    String token = await _firebaseMessaging.getToken();
    return token;
  }

  Future updateProfile({
    @required String name,
  }) async {
    String token = await _getDeviceToken();
    setBusy(true);
    try {
      var resposnse = await _authenticationSerivice.updateProfile(
          name: name, deviceId: token);
      print(resposnse);
      await synFirstTime().then((value) =>
          _navigationService.removeAllAndNavigateTo(MessageViewRoute));
    } catch (e) {
      print(e.message);
    }
    setBusy(false);
  }

  Future synFirstTime() async {
    try {
      await _authenticationSerivice.setNumber();
      await _authenticationSerivice.setNewName();
      await _contactService.firstSyncContacts();
      await _getSyncChats();
    } catch (e) {
      print(e.toString());
    }
  }

  //Sync chats all threads between
  Future<void> _getSyncChats() async {
    try {
      var response = await getThreads();
      // print(response);
      List<dynamic> chats = response.data['messages'];

      _authenticationSerivice.userNumber;
      if (_authenticationSerivice.userNumber == null) {
        _authenticationSerivice.setNumber();
      }
      chats.forEach((chat) async {
        List messages = chat['messages'];
        await DatabaseService.db.insertThread(Thread.fromMap(chat));
        messages.forEach((message) async {
          await DatabaseService.db.insertNewMessage(Message.fromMap(message));
        });
        messages.add(Message.fromMap(chat));
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getThreads() async {
    final _userToken = _authenticationSerivice.token;
    try {
      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer $_userToken",
      };
      var response = await getResquest(
        url: "/getThreads",
        headers: headers,
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
