import 'dart:async';
import 'package:MSG/locator.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/utils/api.dart';
import 'package:MSG/utils/connectivity.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ChatViewModel extends BaseModel {
  String threadId;
  String phoneNumber;
  String userNumber;
  ChatViewModel({@required this.threadId, @required this.phoneNumber});
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();

  //first run
  Timer timer;
  void initialise() async {
    await thread;
  }

  //set chat threadId
  Future get thread async {
    print("Thread getter called");
    if (threadId == null) {
      String result = await DatabaseService.db.getContactThread(phoneNumber);
      //print("thread id: " + result);
      print(result);
      if (result != null) {
        threadId = result;
      } else {
        // print(phoneNumber);
        var res = await initiateThread(phoneNumber);
        if (res.statusCode == 200) {
          List threadMembers = res.data['thread']['members'];
          String otherMember =
              threadMembers[0] == userNumber && threadMembers[1] != null
                  ? threadMembers[1]
                  : '';
          Thread newThread =
              Thread(id: res.data['thread']['_id'], members: otherMember);
          // print(newThread.toMap());
          await DatabaseService.db.insertThread(newThread);
          threadId = res.data['thread']['_id'];
        }
      }
    }
  }

  Future<List<Message>> getChatMessages() async {
    userNumber = _authService.userNumber;
    await thread;
    if (threadId != null) {
      List<Message> messages =
          await DatabaseService.db.getSingleChatMessageFromDb(threadId);
      // messages.forEach((element) {
      //   print(element.toMap());
      // });
      return messages;
    } else
      return [];
  }

  Future resendPendingMessages() async {
    final internetStatus = await checkInternetConnection();
    if (internetStatus == true) {
      List<Message> unsentMessages =
          await DatabaseService.db.getUnsentChatMessageFromDb(threadId);
      print("unsent Messages");
      print(unsentMessages);
      unsentMessages.forEach((mes) async {
        print(mes.content + mes.status + mes.createdAt + mes.isQuote + mes.id);
        var response =
            await sendMsg(threadId, mes.content, mes.isQuote != "false", "");
        if (response.statusCode == 200) {
          // print(response);
          // print(response.data['messageID']);
          Message updatedMessage = Message(
              isQuote: mes.isQuote,
              createdAt: mes.createdAt,
              id: response.data['messageID'],
              sender: mes.sender,
              content: mes.content,
              status: "SENT",
              threadId: mes.threadId);
          //update mesage record
          DatabaseService.db.updateResentMessages(updatedMessage, mes.id);
          notifyListeners();
        }
      });
    }
  }

  Future synChat() async {
    await makeAsRead();
    await resendPendingMessages();
  }

  //send new new nessage
  Future sendMessage(
      {@required String message,
      @required String receiver,
      @required bool isQuote}) async {
    Message newMessage;
    final now = DateTime.now();
    final internetStatus = await checkInternetConnection();
    if (internetStatus == true) {
      var response = await sendMsg(threadId, message, isQuote, "");
      if (response.statusCode == 200) {
        newMessage = Message(
            id: response.data['messageID'],
            content: message,
            sender: userNumber,
            threadId: threadId,
            createdAt: now.toIso8601String(),
            status: "SENT",
            isQuote: isQuote.toString());
      }
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
      print(response);
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

  Future updateMarkedMessages() async {
    final internetStatus = await checkInternetConnection();
    if (internetStatus == true) {
      var res = await makeAsRead();
      print(res);
    }
  }

  Future makeAsRead() async {
    final _userToken = _authService.token;
    try {
      Map<String, String> body = {
        "threadID": threadId,
      };
      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer $_userToken",
      };

      var response = await patchResquest(
        url: "/markasread",
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
