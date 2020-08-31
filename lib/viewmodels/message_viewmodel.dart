import 'dart:async';

import 'package:MSG/locator.dart';
import 'package:MSG/models/chat.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/utils/api.dart';
import 'package:MSG/utils/connectivity.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MessageViewModel extends BaseModel {
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();
  void initialise() {
    const tenSec = const Duration(seconds: 15);
    Timer.periodic(tenSec, (Timer t) {
      getAllChats();
      notifyListeners();
    });
  }

  //Get saved chat/tread from db
  Future<List<Chat>> getAllChats() async {
    //test
    //await DatabaseService.db.deleteDb();
    //first run

    List<Chat> activeChat = [];
    final internetStatus = await checkInternetConnection();
    if (internetStatus == true) {
      await getSyncChats();
    }
    List chats = await DatabaseService.db.getAllChatsFromDb();
    chats.forEach((element) {
      if (element.lastMessage != null) {
        activeChat.add(element);
      }
    });
    print(activeChat);
    return activeChat;
  }

  //Sync chats all threads between
  Future<void> getSyncChats() async {
    try {
      var response = await getThreads();
      print(response);
      List<dynamic> chats = response.data['messages'];
      //save threads
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
    final _userToken = _authService.token;
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
