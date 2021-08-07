import 'dart:async';
import 'package:MSG/constant/route_names.dart';
import 'package:MSG/core/network/network_info.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/models/chat.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/download_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/services/socket_services.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/services/state_service.dart';
import 'package:MSG/core/network/api_request.dart';
import 'package:MSG/utils/util_functions.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:stacked/stacked.dart';

class MessageViewModel extends ReactiveViewModel {
  final bool isFirstTime;
  bool synchronize = false;
  MessageViewModel({
    @required this.isFirstTime,
  });
  final SocketServices _socketService = locator<SocketServices>();
  final AuthenticationSerivice _authSerivice =
      locator<AuthenticationSerivice>();
  final StateService _stateService = locator<StateService>();
  final DownloadService _downloadService = locator<DownloadService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final NetworkInfo _networkInfo = locator<NetworkInfo>();


  //For Rebuilding screens
  bool get rebuild => _stateService.rebuildPage;
  void rebuildScreens() {
    _stateService.updatePages();
    notifyListeners();
  }

  // add new socket message to active chat list
  void updateOpenChatList(ChatMessage message) {
    _stateService.addNewSocketMessage(message);
    // notifyListeners();
  }

  // update delivered socket message to active chat list
  void updateDeliveredChat(ChatMessage message) {
    _stateService.updateDeliveredMessage(message);
    // notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_stateService];

  void initialise() async {
    //For notification click
    AwesomeNotifications().actionStream.listen((receivedNotification) async {
      final int notificationId = int.parse(receivedNotification.payload['id']);
      if (receivedNotification.buttonKeyPressed == 'CANCEL') {
        AwesomeNotifications().dismiss(notificationId);
      } else if (receivedNotification.buttonKeyPressed == 'REPLY' &&
          receivedNotification.buttonKeyInput.trim().isNotEmpty) {
        _saveNotificationReply(
          message: receivedNotification.buttonKeyInput.trim(),
          threadId: receivedNotification.payload['threadID'],
          receiver: receivedNotification.payload['sender'],
          isQuote: false,
        );
        AwesomeNotifications().dismiss(notificationId);
      } else {
        _navigationService.clearAllExceptHomeAndNavigateTo(
          ChatViewRoute,
          arguments: {
            'chat': Chat(
              id: receivedNotification.payload['threadID'],
              displayName: receivedNotification.payload['displayName'],
              memberPhone: receivedNotification.payload['sender'],
              favourite: null,
            ),
            'fromContact': false
          },
        );
      }
    });
    synchronize = true;
    try {
      if (_socketService.socketIO == null) {
        _socketService.connectSockets(
            rebuildScreens, updateOpenChatList, updateDeliveredChat);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    //Register stream to listen to network changes
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        await _syncRecentMessages();
        await _resendPendingMessages();
        await _downloadContactsFirstPicture();
      }
    });
  }

//send new new nessage
  void _saveNotificationReply({
    @required String message,
    @required String threadId,
    @required String receiver,
    @required bool isQuote,
  }) async {
    final msgTime = DateTime.now().toIso8601String();
    final String messageId = generateMessageId();
    ChatMessage newMessage = ChatMessage(
        id: messageId,
        content: message,
        sender: _authSerivice.userNumber,
        threadId: threadId,
        createdAt: msgTime,
        status: "PENDING",
        isQuote: isQuote.toString(),
        messageServerId: '');
    await DatabaseService.db.insertNewMessage(newMessage);
    _stateService.addNewSentMessage(newMessage);
    rebuildScreens();
    await _sendMsg(
      messageId: messageId,
      threadId: threadId,
      receiver: receiver,
      message: message,
      isQuote: false,
      replyTo: '',
    );
  }

//Downlaod contact pictures
  Future<void> _downloadContactsFirstPicture() async {
    List<MyContact> _contacts =
        await DatabaseService.db.getContactsWithoutImagesFromDb();
    for (int i = 0; i < _contacts.length; i++) {
      final MyContact cont = _contacts[i];
      if (cont.profilePictureUrl != null && cont.profilePictureUrl != '') {
        await _downloadService.downloadContactPicture(
          pictureUrl: cont.profilePictureUrl,
          contactName: cont.fullName,
          contactNumber: cont.phoneNumber,
        );
      }
    }
    rebuildScreens();
  }

//Get recent messages using API
  Future<void> _syncRecentMessages() async {
    try {
      if (_authSerivice.userNumber == null) {
        _authSerivice.setNumber();
      }
      var response = await _getRecentMessages();
      List<dynamic> _chats = response.data['messages'];
      _chats.forEach((ch) async {
        var isThreadSaved =
            await DatabaseService.db.checkIfThreadExist(ch['_id']);
        if (isThreadSaved != true) {
          DatabaseService.db.insertThread(Thread.fromMap(ch));
        }
        List _messages = ch['messages'];
        _messages.forEach((mes) async {
          var messagedSaved =
              await DatabaseService.db.checkIfMessageExist(mes['messageId']);
          if (messagedSaved == false) {
            var isContactSaved =
                await DatabaseService.db.checkIfContactExist(mes['sender']);
            if (isContactSaved != true &&
                mes['sender'] != _authSerivice.userNumber) {
              final newContact = MyContact(
                phoneNumber: mes['sender'],
                regStatus: 1,
                pictureDownloaded: 0,
                savedPhone: 0,
              );
              await DatabaseService.db.insertContact(newContact);
            }
            await DatabaseService.db.insertNewMessage(ChatMessage.fromMap(mes));
            await _updateReceivedMessges(messageID: mes['_id']);
          } else {
            if (mes['sender'] != _authSerivice.userNumber &&
                mes['status'] == 'SENT') {
              await _updateReceivedMessges(messageID: mes['_id']);
            }
            if (mes['sender'] == _authSerivice.userNumber &&
                mes['status'] != messagedSaved['status']) {
              await DatabaseService.db
                  .updateDeliveredMsgStatus(mes['messageId']);
            }
          }
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    rebuildScreens();
  }

//Function to make rest request to mark received message as delivered
  Future _updateReceivedMessges({@required String messageID}) async {
    final _userToken = _authSerivice.token;
    try {
      Map<String, dynamic> body = {"messageID": messageID};
      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer $_userToken",
      };
      var response = await postResquest(
        url: "/markasdelivered",
        headers: headers,
        body: body,
      );
      return response;
    } catch (e) {
      if (e is DioError) {
        debugPrint(e.response?.statusCode.toString());
      }
      debugPrint(e.toString());
      throw e;
    }
  }

  //Fetch all user saved messages
  Future _getRecentMessages() async {
    final _userToken = _authSerivice.token;
    try {
      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer $_userToken",
      };
      var response = await getRequest(
        url: "/getRecentMessages",
        headers: headers,
      );
      return response;
    } catch (e) {
      if (e is DioError) {
        debugPrint(e.toString());
      }
      throw e;
    }
  }

  //Get Saved Chat messages API
  Future<void> _restoreAllSavedMessages() async {
    try {
      if (_authSerivice.userNumber == null) {
        _authSerivice.setNumber();
      }
      var response = await getUserThreads();
      List<dynamic> chats = response.data['messages'];
      chats.forEach((ch) async {
        final isThreadSaved =
            await DatabaseService.db.checkIfThreadExist(ch['_id']);
        if (isThreadSaved != true) {
          DatabaseService.db.insertThread(Thread.fromMap(ch));
        }
        List messages = ch['messages'];
        messages.forEach((message) async {
          if (message['sender'] != _authSerivice.userNumber) {
            message['status'] = 'READ';
          }
          await DatabaseService.db
              .insertNewMessage(ChatMessage.fromMap(message));
        });
      });
      synchronize = false;
      rebuildScreens();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //Fetch all user saved messages
  Future getUserThreads() async {
    final _userToken = _authSerivice.token;
    try {
      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "authorization": "Bearer $_userToken",
      };
      var response = await getRequest(
        url: "/getThreads",
        headers: headers,
      );
      return response;
    } catch (e) {
      if (e is DioError) {
        debugPrint(e.response.data);
      }
      debugPrint(e.toString());
      throw e;
    }
  }

  //Resend unsent messages
  Future<void> _resendPendingMessages() async {
    if (await _networkInfo.isConnected) {
      List<ChatMessage> unsentMessages = await DatabaseService.db
          .getUnsentChatMessageFromDb(_authSerivice.userNumber);
      unsentMessages.forEach((mes) async {
        var response = await _sendMsg(
          messageId: mes.id,
          threadId: mes.threadId,
          receiver: mes.receiver,
          message: mes.content,
          isQuote: mes.isQuote != "false",
          replyTo: "",
        );
        if (response.statusCode == 200) {
          await DatabaseService.db.updateSentMsgStatus(mes.id).then((_) =>
              FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_SIGNAL_OFF));
          rebuildScreens();
        }
      });
    }
  }

// For sending each pending message
  Future _sendMsg({
    @required String messageId,
    @required String threadId,
    @required String receiver,
    @required String message,
    @required bool isQuote,
    @required String replyTo,
  }) async {
    final _userToken = _authSerivice.token;
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
        debugPrint(e.response.statusCode.toString());
      }
      debugPrint(e.toString());
      throw e;
    }
  }

  //Get saved chat/tread from db
  Future<List<Chat>> getAllChats() async {
    //Restoring old messages
    if (isFirstTime == true && synchronize == true) {
      await _restoreAllSavedMessages();
      await _downloadContactsFirstPicture();
    }
    List<Chat> activeChat =
        await DatabaseService.db.getAllChatsFromDb(_authSerivice.userNumber);
    return activeChat;
  }
}
