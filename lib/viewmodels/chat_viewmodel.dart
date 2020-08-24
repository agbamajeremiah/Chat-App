import 'package:MSG/locator.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/utils/api.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ChatViewModel extends BaseModel {
  String threadId;
  String phoneNumber;
  ChatViewModel({@required this.threadId, @required this.phoneNumber});
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();

  //Fetch contact's from database
  Future get thread async {
    print("Thread getter called");
    if (threadId == null) {
      print(phoneNumber);
      String result = await DatabaseService.db.getContactThread(phoneNumber);
      if (result != null) {
        threadId = result;
      } else {
        print(phoneNumber);
        await initiateThread(phoneNumber);
      }
    }
  }

  Future<List<Message>> getChatMessages() async {
    await thread;
    print(threadId);
    if (threadId != null) {
      List<Message> messages =
          await DatabaseService.db.getSingleChatMessageFromDb(threadId);
      print("chats called:");
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
    print(threadId);
    var response = await sendMsg(receiver, message, isQuote, "");
    final now = DateTime.now();
    Message newMessage;

    print(response.statusCode);
    print(response.data);
    if (response.statusCode == 200) {
      newMessage = Message(
          id: response.data['messageID'],
          content: message,
          sender: "+23408132368804",
          threadId: threadId,
          createdAt: now.toIso8601String(),
          status: "sent",
          isQuote: isQuote.toString());
    } else {
      newMessage = Message(
        id: now.toString(),
        content: message,
        sender: "+2348132368804",
        threadId: threadId,
        createdAt: now.toIso8601String(),
        status: "PENDING",
        isQuote: isQuote.toString(),
      );
    }
    await DatabaseService.db.insertNewMessage(newMessage);
  }

  Future sendMsg(
      String receiver, String message, bool isQuote, String replyTo) async {
    final _userToken = _authService.token;
    print(_userToken);
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
