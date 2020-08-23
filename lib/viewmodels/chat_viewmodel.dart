import 'package:MSG/locator.dart';
import 'package:MSG/models/contacts.dart';
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
      }
    }
  }

  Future<List<Message>> getChatMessages() async {
    await thread;
    print(threadId);
    List<Message> messages =
        await DatabaseService.db.getSingleChatMessageFromDb(threadId);
    print("chats called:");
    print(messages);
    return messages;
  }

  //send new new nessage
  Future sendMessage(
      {@required String message,
      @required String receiver,
      @required bool isQuote}) async {
    await thread;

    var response = await sendMsg(receiver, message, isQuote, "");
    print(response.statusCode);
    print(response.data);
    if (response.statusCode == 200) {
      if (threadId == null) {
        Map thread = {"id": response.data['thread'], "members": phoneNumber};
        var res = await DatabaseService.db.insertThread(Thread.fromMap(thread));
      } else {
        //Map newMessage = {"id": response.data['thread'], "members": phoneNumber};
        //await DatabaseService.db.insertNewMessage(Message.fromMap(message));

      }
    }
  }

  Future sendMsg(
      String receiver, String message, bool isQuote, String replyTo) async {
    final _userToken = _authService.token;
    print(_userToken);
    try {
      Map<String, dynamic> body;
      if (threadId == null) {
        body = {
          "receiver": receiver,
          "content": message,
          "isQuote": isQuote,
          "msgRepliedTo": replyTo,
        };
      } else {
        body = {
          "content": message,
          "threadID": threadId,
          "isQuote": isQuote,
          "msgRepliedTo": replyTo,
        };
      }

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
