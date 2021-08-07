import 'dart:io';
import 'package:MSG/constant/base_url.dart';
import 'package:MSG/core/network/api_request.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationSerivice {
  String _token, _userNumber, _userID, _profileName, _profileImagePath;
  String get token => _token;
  String get userNumber => _userNumber;
  String get userID => _userID;
  String get profileName => _profileName;
  String get profileImagePath => _profileImagePath;

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("token");
    if (data != null) {
      _token = data;
      _userNumber = prefs.getString("number");
      _profileName = prefs.getString("name");
      _userID = prefs.getString("userID");
      _profileImagePath = prefs.getString('profileImagePath');
    }
    return data != null;
  }

  Future setToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("token");
    if (data != null) {
      _token = data;
    }
  }

  Future setNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userNumber = prefs.getString("number");
    _userID = prefs.getString("userID");
  }

  Future setNewName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _profileName = prefs.getString("name");
  }

  Future register({
    @required String phoneNumber,
  }) async {
    try {
      Map<String, String> body = {
        "phoneNumber": phoneNumber,
      };

      var response = await postResquest(
        url: "/register",
        body: body,
      );
      return response;
    } catch (e) {
      if (e is DioError) {
        debugPrint(e.response.data.toString());
        return null;
      }
      debugPrint(e.toString());
      throw e;
    }
  }

//verify otp
  Future verifyOTP({
    @required String otp,
  }) async {
    try {
      Map<String, String> body = {
        "otp": otp,
      };

      var response = await postResquest(
        url: "/verifyotp",
        body: body,
      );
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", response.data["token"]);
        prefs.setString("number", response.data["phoneNumber"]);
        prefs.setString("userID", response.data["userID"]);
        _token = response.data["token"];
        _userID = response.data["userID"];
        _userNumber = response.data["phoneNumber"];
        debugPrint(_userID);
      }
      return response.statusCode;
    } catch (e) {
      if (e is DioError) {
        debugPrint(
          e.response.data[0],
        );
        return e.response.statusCode;
      }
      throw e;
    }
  }

  // Resend OTP
  Future resentOTP({
    @required String phoneNumber,
  }) async {
    try {
      Map<String, String> body = {
        "phoneNumber": phoneNumber,
      };

      var response = await postResquest(
        url: "/resendotp",
        body: body,
      );
      // return jsonDecode(response);
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

  Future<Response> updateProfile(
      {@required String name, String deviceId}) async {
    try {
      Map<String, String> body = {
        "name": name,
        "deviceID": deviceId,
      };
      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer $_token",
      };

      var response = await patchResquest(
        url: "/updateUser",
        body: body,
        headers: headers,
      );
      if (response.statusCode == 200) {
        //Set new in sharedPreference
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("name", name);
      }
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

//upload profile picture
  Future sendPictureToServer({@required File picture}) async {
    try {
      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer $_token",
      };
      Dio dio = Dio();
      String route = BasedUrl + '/updatepicture';
      if (picture == null || picture.path == null) {
        return;
      }
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(picture.path),
      });
      Response response = await dio.patch(
        route,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
      if (response?.statusCode == 200) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("profileImagePath", picture.path);
        _profileImagePath = picture.path;
        return true;
      }
    } catch (e) {
      if (e is DioError) {
        debugPrint(
          e.response.toString(),
        );
      }
      debugPrint(e.toString());
      throw e;
    }
  }
}
