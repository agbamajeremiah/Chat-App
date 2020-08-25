import 'package:MSG/utils/api.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationSerivice {
  String _token;
  String get token => _token;
  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("token");

    if (data != null) {
      _token = data;
    }
    return data != null;
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
      if (response.statusCode == 200) {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
      }
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

  // login

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
