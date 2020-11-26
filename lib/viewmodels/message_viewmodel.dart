import 'dart:async';
import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/models/chat.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/state_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/socket_services.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/utils/api_request.dart';
import 'package:MSG/utils/connectivity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'dart:convert';

class MessageViewModel extends ReactiveViewModel {
  final SocketServices _socketService = locator<SocketServices>();
  final StateService _stateService = locator<StateService>();
  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_stateService];
  //Function to rebuild all screens
  bool get rebuild => _stateService.rebuildPage;
  void rebuildScreens() {
    _stateService.updatePages();
    notifyListeners();
  }

  void _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("Active message: $message");
        List messages = jsonDecode(message['data']['data']);
        if (messages.length > 0) {
          messages.forEach((singleMessage) {
            print(singleMessage);
            DatabaseService.db.insertNewMessage(Message.fromMap(singleMessage));
          });
        }
        rebuildScreens();
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("Launch Message: $message");
        List messages = jsonDecode(message['data']['data']);
        if (messages.length > 0) {
          messages.forEach((singleMessage) {
            print(singleMessage);
            DatabaseService.db.insertNewMessage(Message.fromMap(singleMessage));
          });
        }
        notifyListeners();
      },
      onResume: (Map<String, dynamic> message) async {
        print("Resume Message: $message");
        List messages = jsonDecode(message['data']['data']);
        if (messages.length > 0) {
          messages.forEach((singleMessage) {
            print(singleMessage);
            DatabaseService.db.insertNewMessage(Message.fromMap(singleMessage));
          });
        }
        Map<String, dynamic> singleMessage = messages[0];
        _navigationService.clearLastAndNavigateTo(
          ChatViewRoute,
          arguments: {
            'chat': Chat(
              id: singleMessage['threadID'],
              displayName: null,
              memberPhone: null,
            ),
            'fromContact': false
          },
        );
      },
    );
  }

  void initialise() async {
    //Subscribe threads to message sockets
    _configureFirebaseListeners();

    try {
      if (_socketService.socketIO != null) {
        _socketService.registerSocketId();
      } else {
        _socketService.connectSockets();
        await Future.delayed(Duration(seconds: 2))
            .whenComplete(() => _socketService.registerSocketId());
      }
      List<Chat> chat = await getAllThreads();
      chat.forEach((element) async {
        _socketService.subscribeToThread(
            element.id, element.memberPhone, rebuildScreens);
      });
    } catch (e) {
      print(e.toString);
    }
    //Register stream to listen to network changes
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        await _resendPendingMessages();
      }
    });
  }

  //Resend unsent messages
  Future _resendPendingMessages() async {
    final internetStatus = await checkInternetConnection();
    if (internetStatus == true) {
      List<Message> unsentMessages = await DatabaseService.db
          .getUnsentChatMessageFromDb(_authenticationSerivice.userNumber);
      print("unsent Messages");
      print(unsentMessages);
      unsentMessages.forEach((mes) async {
        print(mes.content +
            mes.status +
            mes.createdAt +
            mes.isQuote +
            mes.id +
            mes.receiver);
        var response = await _sendMsg(mes.id, mes.threadId, mes.receiver,
            mes.content, mes.isQuote != "false", "");
        if (response.statusCode == 200) {
          await DatabaseService.db.updateMessageStatus(mes.id, "SENT");
        }
      });
      notifyListeners();
    }
  }

  Future _sendMsg(String messageId, String threadId, String receiver,
      String message, bool isQuote, String replyTo) async {
    final _userToken = _authenticationSerivice.token;
    try {
      Map<String, dynamic> body = {
        "content": message,
        "messageId": messageId,
        "threadID": threadId,
        "isQuote": isQuote,
        "msgRepliedTo": replyTo,
        "receiver": receiver
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
          e.response.statusCode.toString(),
        );
      }
      print(e.runtimeType);
      print(e.toString());
      throw e;
    }
  }

  //Get all threads for socket subscribtion
  Future<List<Chat>> getAllThreads() async {
    List<Chat> allThreads = await DatabaseService.db.getAllUserThreads();
    return allThreads;
  }

  //Get saved chat/tread from db
  Future<List<Chat>> getAllChats() async {
    List<Chat> activeChat = await DatabaseService.db
        .getAllChatsFromDb(_authenticationSerivice.userNumber);
    return activeChat;
  }
}
