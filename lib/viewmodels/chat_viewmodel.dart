import 'dart:async';
import 'package:MSG/locator.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/socket_services.dart';
import 'package:MSG/utils/api_request.dart';
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
  // List<Message> chatMessages = [];
  final int _chatFetchMax = 15;
  ChatViewModel(
      {@required this.threadId,
      @required this.phoneNumber,
      @required this.fromContact});
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();
  final SocketServices _socketService = locator<SocketServices>();

  void rebuildScreen() {
    notifyListeners();
  }

  void initialise() async {
    await thread;
    updateReadMessages();
    //Subscribe to new threed two
    if (true) {
      //fromContact == true
      final internetStatus = await checkInternetConnection();
      if (internetStatus == true) {
        if (_socketService.socketIO != null) {
          //_socketService.registerSocketId();
          _socketService.subscribeToThread(
              threadId, phoneNumber, rebuildScreen);
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
    List<Message> chatMessages = [];
    if (threadId == null) {
      await thread;
    }
    userNumber = _authService.userNumber;
    if (threadId != null) {
      int _fetchedChat = chatMessages.length;
      List<Message> messages =
          await DatabaseService.db.getSingleChatMessageFromDb(threadId);
      chatMessages.addAll(messages);
      return chatMessages;
    } else {
      return [];
    }
  }

  Future<void> updateReadMessages() async {
    await DatabaseService.db
        .updateReadMessages(threadId, _authService.userNumber);
  }

  Future resendPendingMessages() async {
    final internetStatus = await checkInternetConnection();
    if (internetStatus == true && threadId != null) {
      List<Message> unsentMessages =
          await DatabaseService.db.getUnsentChatMessageFromDb(threadId);
      print("unsent Messages");
      print(unsentMessages);
      unsentMessages.forEach((mes) async {
        print(mes.content +
            mes.status +
            mes.createdAt +
            mes.isQuote +
            mes.id +
            phoneNumber);
        var response =
            await sendMsg(mes.id, mes.content, mes.isQuote != "false", "");
        if (response.statusCode == 200) {
          await DatabaseService.db.updateMessageStatus(mes.id, "SENT");
        }
        notifyListeners();
      });
    }
  }

  Future synChat() async {
    final internetStatus = await checkInternetConnection();
    if (internetStatus == true) {
      try {
        await makeAsRead();
      } catch (e) {
        print(e.toString());
      }
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
    // chatMessages.insert(0, newMessage);
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
        "receiver": phoneNumber
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
