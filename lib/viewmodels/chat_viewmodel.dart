import 'dart:async';

import 'package:MSG/locator.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/utils/api.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatViewModel extends BaseModel {
  String threadId;
  String phoneNumber;
  String userNumber;
  ChatViewModel({@required this.threadId, @required this.phoneNumber});
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();

  //first run
  Timer timer;
  void initialise() {
    const sevenSec = const Duration(seconds: 7);
    timer = Timer.periodic(sevenSec, (Timer t) {
      getChatMessages();
      notifyListeners();
    });
  }

  void cancelTimer() {
    timer?.cancel();
  }

  //Fetch contact's from database
  Future get thread async {
    print("Thread getter called");
    if (threadId == null) {
      String result = await DatabaseService.db.getContactThread(phoneNumber);
      print("thread id: " + result);
      print(result);
      if (result != null) {
        threadId = result;
      } else {
        print(phoneNumber);
        await initiateThread(phoneNumber);
      }
    }
  }

  Future get myNumber async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userNumber = prefs.getString("number");
    print("my number :");
    print(userNumber);
  }

  Future resendPendingMessages() async {
    List<Message> unsentMessages =
        await DatabaseService.db.getUnsentChatMessageFromDb(threadId);
    print("unsent Messages");
    print(unsentMessages);
  }

  Future<List<Message>> getChatMessages() async {
    await thread;
    await myNumber;
    //List<Message> messages = [];
    if (threadId != null) {
      List<Message> messages =
          await DatabaseService.db.getSingleChatMessageFromDb(threadId);
      await resendPendingMessages();
      return messages;
    } else
      return null;
  }

  //send new new nessage
  Future sendMessage(
      {@required String message,
      @required String receiver,
      @required bool isQuote}) async {
    await thread;
    var response = await sendMsg(receiver, message, isQuote, "");
    final now = DateTime.now();
    Message newMessage;
    if (response.statusCode == 200) {
      newMessage = Message(
          id: response.data['messageID'],
          content: message,
          sender: userNumber,
          threadId: threadId,
          createdAt: now.toIso8601String(),
          status: "SENT",
          isQuote: isQuote.toString());
    } else {
      newMessage = Message(
        id: now.toString(),
        content: message,
        sender: userNumber,
        threadId: threadId,
        createdAt: now.toIso8601String(),
        status: "PENDING",
        isQuote: isQuote.toString(),
      );
    }
    await DatabaseService.db.insertNewMessage(newMessage);
    notifyListeners();
  }

  Future sendMsg(
      String receiver, String message, bool isQuote, String replyTo) async {
    final _userToken = _authService.token;
    try {
      Map<String, dynamic> body = {
        "content": message,
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

  //initiate thread
  Future initiateThread(String contact) async {
    final _userToken = _authService.token;
    print(_userToken);
    try {
      Map<String, dynamic> body = {"receiver": contact};

      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer $_userToken",
      };
      var response = await postResquest(
        url: "/initiateThread",
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
