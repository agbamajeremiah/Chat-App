import 'dart:async';
import 'package:MSG/locator.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/socket_services.dart';
import 'package:MSG/utils/api.dart';
import 'package:MSG/utils/connectivity.dart';
import 'package:MSG/utils/util_functions.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ChatViewModel extends BaseModel {
  String threadId;
  String phoneNumber;
  String userNumber;
  bool fromContact;
  ChatViewModel(
      {@required this.threadId,
      @required this.phoneNumber,
      @required this.fromContact});
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();
  final SocketServices _socketService = locator<SocketServices>();
  bool threadListened = false;

  void rebuildScreen() {
    notifyListeners();
  }

  //first run
  Timer timer;
  void initialise() async {
    await thread;
    //Subscribe to new threed two
    if (true) {
      //fromContact == true
      final internetStatus = await checkInternetConnection();
      if (internetStatus == true) {
        if (_socketService.socketIO != null) {
          //_socketService.registerSocketId();
          _socketService.subscribeToThread(
              threadId, phoneNumber, rebuildScreen);
          threadListened = true;
        }
      }
    }
  }

  //set chat threadId
  Future get thread async {
    print("Thread getter called");
    if (threadId == null) {
      String result = await DatabaseService.db.getContactThread(phoneNumber);
      // print("thread id: " + result);
      if (result != null) {
        threadId = result;
      } else {
        // print(phoneNumber);
        final internetStatus = await checkInternetConnection();
        if (internetStatus == true) {
          var res = await initiateThread(phoneNumber);
          if (res.statusCode == 200) {
            print(res.data);
            List threadMembers = res.data['thread']['members'];
            String otherMember = threadMembers[0] == _authService.userNumber &&
                    threadMembers[1] != null
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
  }

  Future<List<Message>> getChatMessages() async {
    if (threadId == null) {
      await thread;
    }
    userNumber = _authService.userNumber;
    if (threadId != null) {
      List<Message> messages =
          await DatabaseService.db.getSingleChatMessageFromDb(threadId);
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
          print("Sent message successfully");
        }
      });
    }
  }

  Future synChat() async {
    final internetStatus = await checkInternetConnection();
    if (internetStatus == true) {
      await updateMarkedMessages();
      await makeAsRead();
      await resendPendingMessages();
    }
  }

  //send new new nessage
  Future saveNewMessage(
      {@required String message,
      @required String receiver,
      @required bool isQuote}) async {
    setBusy(true);
    final now = DateTime.now();
    final String messageId = generateMessageId();
    Message newMessage = Message(
      id: messageId,
      content: message,
      sender: userNumber,
      threadId: threadId,
      createdAt: now.toIso8601String(),
      status: "PENDING",
      isQuote: isQuote.toString(),
    );
    await DatabaseService.db.insertNewMessage(newMessage);
    setBusy(false);
    return messageId;
  }

  Future sendNewMessage(
      {@required messageId,
      @required String message,
      @required String receiver,
      @required bool isQuote}) async {
    setBusy(true);
    final internetStatus = await checkInternetConnection();
    if (internetStatus == true && _socketService.socketIO != null) {
      var response = await sendMsg(messageId, message, isQuote, "");
      if (response.statusCode == 200) {
        //  update sent messag
        print(response.data['messageID']);
      }
    }
    setBusy(false);
  }

  Future sendMsg(
      String messageId, String message, bool isQuote, String replyTo) async {
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
    await makeAsRead();
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
      // print(response);
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
