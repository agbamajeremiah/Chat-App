import 'package:MSG/utils/api_request.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationSerivice {
  String _token, _userNumber, _profileName;
  String get token => _token;
  String get userNumber => _userNumber;
  String get profileName => _profileName;
  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("token");
    if (data != null) {
      _token = data;
      _userNumber = prefs.getString("number");
      _profileName = prefs.getString("name");
      print(_userNumber);
      print(_profileName);
    }
    return data != null;
  }

  Future setNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userNumber = prefs.getString("number");
    print(_userNumber);
  }

  Future setNewName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _profileName = prefs.getString("name");
    print(_profileName);
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
      if (response.statusCode == 200) {}
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
        print(response.data);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // var res = jsonDecode(response);
        _token = response.data["token"];
        print(_token);
        prefs.setString("token", response.data["token"]);
        prefs.setString("number", response.data["phoneNumber"]);
      }
      // return jsonDecode(response);
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
      print(e.runtimeType);
      print(e.toString());
      throw e;
    }
  }

  Future<Response> updateProfile({
    @required String name,
  }) async {
    try {
      Map<String, String> body = {
        "name": name,
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
        print("New name set");
      }
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
