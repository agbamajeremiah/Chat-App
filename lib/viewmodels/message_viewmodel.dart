import 'package:MSG/locator.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/utils/api.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MessageViewModel extends BaseModel {
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();
  //Get saved chat/tread from db
  Future<List<Thread>> getAllChats() async {
    await getSyncChats();
    List<Thread> chats = await DatabaseService.db.getAllChatsFromDb();
    return chats;
  }

  //Sync chats all threads between
  Future<void> getSyncChats() async {
    var response = await getThreads();
    print(response);
    List<dynamic> chats = response.data['messages'];
    print(chats);
    //save threads/ chat
    chats.forEach((thread) async {
      await DatabaseService.db.insertThread(Thread.fromMap(thread));
      //messages.add(Message.fromMap(message));
    });
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
