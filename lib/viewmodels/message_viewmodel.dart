import 'package:MSG/locator.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/utils/api.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MessageViewModel extends BaseModel {
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();

  //Fetch all registered contacts from database
  Future getAllChats() async {
    List<Thread> chatThreads = [];
    var response = await getThreads();
    List<dynamic> chats = response.data['messages'];
    //print(chats);
    chats.forEach((thread) {
      chatThreads.add(Thread.fromMap(thread));
    });
    print(chatThreads);
  }

  Future getThreads() async {
    final _userToken = _authService.token;
    print(_userToken);
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
