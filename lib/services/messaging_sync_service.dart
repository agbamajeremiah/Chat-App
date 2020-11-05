import 'package:MSG/locator.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/utils/api_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MessagingServices {
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();

  //Sync chats all threads between
  Future<void> getSyncChats() async {
    try {
      var response = await getThreads();
      // print(response);
      List<dynamic> chats = response.data['messages'];

      _authService.userNumber;
      if (_authService.userNumber == null) {
        _authService.setNumber();
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

  Future resendPendindMessages() async {
    List<Message> unsentMessages =
        await DatabaseService.db.getAllUnsentFromDb();
    unsentMessages.forEach((mes) async {
      print(mes.content + mes.status + mes.createdAt + mes.isQuote + mes.id);
      var response = await sendMsg(
          mes.threadId, mes.id, mes.content, mes.isQuote != "false", "");
      if (response.statusCode == 200) {
        print("Sent message successfully");
        await DatabaseService.db.updateMessageStatus(mes.id, "SENT");
      }
    });
  }

  Future sendMsg(String threadId, String messageId, String message,
      bool isQuote, String replyTo) async {
    final _userToken = _authService.token;
    try {
      Map<String, dynamic> body = {
        "content": message,
        "messageId": messageId,
        "threadID": threadId,
        "isQuote": isQuote,
        "msgRepliedTo": replyTo,
      };

      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer $_userToken",
      };
      var response = await postResquest(
        url: "/sendmessage",
        headers: headers,
        body: body,
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
