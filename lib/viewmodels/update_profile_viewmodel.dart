import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/contact_services.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/download_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/core/network/api_request.dart';
import 'package:stacked/stacked.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class UpdateProvfileViewModel extends BaseViewModel {
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ContactServices _contactService = locator<ContactServices>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final DownloadService _downloadService = locator<DownloadService>();

  String oldProfileName;
  String newProfileName;
  String profilePicturePath;

  Future _getDeviceToken() async {
    String token = await _firebaseMessaging.getToken();
    return token;
  }

  void initialise() async {
    await getSavedUserDetails();
  }

  Future updateProfile({
    @required String name,
  }) async {
    String token = await _getDeviceToken();
    setBusy(true);
    try {
      await _authenticationSerivice.updateProfile(name: name, deviceId: token);
      await synFirstTime().then((value) => _navigationService
          .removeAllAndNavigateTo(Routes.messageViewRoute, arguments: true));
    } catch (e) {
      debugPrint(e.toString());
    }
    setBusy(false);
  }

  Future synFirstTime() async {
    try {
      await _authenticationSerivice.setNumber();
      await _authenticationSerivice.setNewName();
      await _contactService.firstSyncContacts();
      // await _getSavedChats();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get saved chat from server
  Future<void> _getSavedChats() async {
    try {
      var response = await getUserThreads();
      // debugPrint(response);
      List<dynamic> chats = response.data['messages'];
      if (_authenticationSerivice.userNumber == null) {
        _authenticationSerivice.setNumber();
      }
      chats.forEach((chat) async {
        await DatabaseService.db.insertThread(Thread.fromMap(chat));
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future getUserThreads() async {
    final _userToken = _authenticationSerivice.token;
    try {
      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer $_userToken",
      };
      var response = await getRequest(
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
      debugPrint(e.toString());
      throw e;
    }
  }

  Future getSavedUserDetails() async {
    String _chatID = _authenticationSerivice.userID;
    final _userToken = _authenticationSerivice.token;

    try {
      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer $_userToken",
      };

      Map<String, String> params = {
        'userID': _chatID,
      };
      var response = await getRequest(
          url: "/getuserdetails", headers: headers, queryParam: params);
      debugPrint(response);
      if (response?.statusCode == 200) {
        String profileImageUrl = response.data['user']['displayPicture'];
        oldProfileName = response.data['user']['name'];
        notifyListeners();
        var downloadRes = await _downloadService.downloadUserPicture(
            pictureUrl: profileImageUrl);
        if (downloadRes != null) {
          profileImageUrl = downloadRes;
          notifyListeners();
        }
      }
      return response;
    } catch (e) {
      throw e;
    }
  }
}
