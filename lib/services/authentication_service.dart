import 'package:MSG/utils/api.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationSerivice {
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
        // debugPrint(
        //   e.response.data,
        // );
      }
      print(e.runtimeType);
      print(e.toString());
      throw e;
    }
  }

  // login

  // Future<Response> login({
  //   @required String username,
  //   @required String password,
  // }) async {
  //   try {
  //     Map<String, String> body = {
  //       "username": username,
  //       "password": password,
  //     };
  //     Map<String, String> headers = {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json",
  //     };
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var response = await postResquest(
  //       url: "/auth/login",
  //       body: body,
  //       headers: headers,
  //     );

  //     if (response.statusCode == 200) {
  //       var res = jsonDecode(response);
  //       prefs.setString("token", res["data"]["access_token"]);
  //     }
  //     // return jsonDecode(response);
  //     return response;
  //   } catch (e) {
  //     if (e is DioError) {
  //       debugPrint(
  //         e.response.data,
  //       );
  //     }
  //     print(e.runtimeType);
  //     print(e.toString());
  //     throw e;
  //   }
  // }
}
