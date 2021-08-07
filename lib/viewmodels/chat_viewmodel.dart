import 'dart:async';
import 'package:MSG/core/network/network_info.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/download_service.dart';
import 'package:MSG/services/state_service.dart';
import 'package:MSG/core/network/api_request.dart';
import 'package:MSG/utils/util_functions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:stacked/stacked.dart';

class ChatViewModel extends ReactiveViewModel {
  String threadId;
  String phoneNumber;
  String displayName;
  bool fromContact;
  bool favourite;
  String contactChatID;
  String pictureUrl;
  String picturePath;
  int profilePictureDownloaded;

  ChatViewModel({
    @required this.threadId,
    @required this.phoneNumber,
    @required this.fromContact,
    @required this.displayName,
    @required this.favourite,
    @required this.contactChatID,
    @required this.pictureUrl,
    @required this.picturePath,
    @required this.profilePictureDownloaded,
  });

  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();
  final StateService _stateService = locator<StateService>();
  final DownloadService _downloadService = locator<DownloadService>();
  final NetworkInfo _networkInfo = locator<NetworkInfo>();


  //get userNumber
  String get accountNumber => _authService.userNumber;
  final int chatFetchLimit = 30;

  //List a single chat message
  List get chatMessages => _stateService.singleChatMessage;
  //For Rebuilding screens
  bool get rebuild => _stateService.rebuildPage;
  void rebuildScreens() {
    _stateService.updatePages();
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_stateService];

  void initialise() async {
    await thread;
    if (threadId != null) {
      _stateService.setOpenChat(threadId);
    }
    await fetchFirstChatMessages();
    _updateReadMessages();
    _downloadContactImage();
    // DatabaseService.db.getAllUserThreads();
  }

  //set chat threadId
  Future get thread async {
    debugPrint("Thread getter called");
    if (threadId == null ||
        favourite == null ||
        profilePictureDownloaded == null) {
      Map result = await DatabaseService.db.getContactThread(phoneNumber);
      if (result != null) {
        threadId = result['id'];
        favourite = result['favourite'] == 0 ? false : true;
      } else {
        if (await _networkInfo.isConnected) {
          var res = await _initiateThread(phoneNumber);
          if (res.statusCode == 200) {
            List threadMembers = res.data['thread']['members'];
            String otherMember = threadMembers[0] == _authService.userNumber &&
                    threadMembers[1] != null
                ? threadMembers[1]
                : threadMembers[0];
            Thread newThread = Thread(
                id: res.data['thread']['_id'],
                members: otherMember,
                favourite: 0);
            await DatabaseService.db.insertThread(newThread);
            threadId = res.data['thread']['_id'];
          }
        }
      }
    } else if (phoneNumber == null || displayName == null) {
      Map contactDetails = await DatabaseService.db.getContactDetails(threadId);
      if (contactDetails != null) {
        phoneNumber = contactDetails['phoneNumber'];
        displayName = contactDetails['displayName'];
        contactChatID = contactDetails['contactChatID'];
        pictureUrl = contactDetails['pictureUrl'];
        picturePath = contactDetails['picturePath'];
        profilePictureDownloaded = contactDetails['pictureDownloaded'];
      }
    }
  }

  Future fetchFirstChatMessages() async {
    if (threadId == null) {
      await thread;
    }
    if (threadId != null) {
      List<ChatMessage> messages = await DatabaseService.db
          .fetchSingleChatMessageFromDbWithLimit(threadId, 0, chatFetchLimit);
      _stateService.addNewDBMessage(messages);
      if (messages.length > 0) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future fetchLoadChatMessages() async {
    if (threadId == null) {
      await thread;
    }
    if (threadId != null) {
      List<ChatMessage> messages = await DatabaseService.db
          .fetchSingleChatMessageFromDbWithLimit(threadId, 0, chatFetchLimit);
      if (messages.length > 0) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<void> fetchMoreChatMessages() async {
    if (threadId == null) {
      await thread;
    }
    if (threadId != null) {
      List<ChatMessage> messages = await DatabaseService.db
          .fetchSingleChatMessageFromDbWithLimit(
              threadId, chatMessages.length, chatFetchLimit);
      _stateService.addNewDBMessage(messages);
      // debugPrint("fetch success");
      notifyListeners();
    }
  }
  
  Future<void> _updateReadMessages() async {
    await DatabaseService.db
        .updateReadMessages(threadId, _authService.userNumber);
    rebuildScreens();
  }

  Future<void> updateReadMessageWithoutRebuild() async {
    await DatabaseService.db
        .updateReadMessages(threadId, _authService.userNumber);
  }

  //send new new nessage
  void saveNewMessage({
    @required String message,
    @required String receiver,
    @required bool isQuote,
  }) async {
    final msgTime = DateTime.now().toIso8601String();
    final String messageId = generateMessageId();
    ChatMessage newMessage = ChatMessage(
        id: messageId,
        content: message,
        sender: _authService.userNumber,
        threadId: threadId,
        createdAt: msgTime,
        status: "PENDING",
        isQuote: isQuote.toString(),
        messageServerId: '');
    await DatabaseService.db.insertNewMessage(newMessage);
    _stateService.addNewSentMessage(newMessage);
    rebuildScreens();
    await _sendNewMessage(newMessage);
  }

  void toggleChatFavavourite(int fav) async {
    // debugPrint(fav);
    if (threadId != null) {
      if (fav == 0) {
        await DatabaseService.db.removeChatFromFav(threadId);
      } else if (fav == 1) {
        await DatabaseService.db.addChatAsFav(threadId);
      }
      favourite = !favourite;
      rebuildScreens();
    }
  }

  Future _sendNewMessage(ChatMessage newMessage) async {
    var response = await _sendMsg(newMessage.id, newMessage.content, false, "");
    if (response.statusCode == 200) {
      _stateService.updateSentMessage(newMessage);
      await DatabaseService.db.updateSentMsgStatus(newMessage.id).then((_) =>
          FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_SIGNAL_OFF));
      notifyListeners();
    }
  }

  Future _sendMsg(
    String messageId,
    String message,
    bool isQuote,
    String replyTo,
  ) async {
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
          e.response.statusCode.toString(),
        );
      }
      debugPrint(e.toString());
      throw e;
    }
  }

  //initiate thread
  Future _initiateThread(String contact) async {
    final _userToken = _authService.token;
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
      debugPrint(e.toString());
      throw e;
    }
  }

  Future<void> _downloadContactImage() async {
    final _userToken = _authService.token;
    if (contactChatID != null) {
      try {
        if (pictureUrl != null && profilePictureDownloaded != 1) {
          final res = await _downloadService.downloadContactPicture(
              pictureUrl: pictureUrl,
              contactName: displayName,
              contactNumber: phoneNumber);
          if (res != null) {
            picturePath = res;
            profilePictureDownloaded = 1;
            rebuildScreens();
          }
        } else {
          Map<String, String> headers = {
            "Content-Type": "application/x-www-form-urlencoded",
            "authorization": "Bearer $_userToken",
          };

          Map<String, String> params = {
            'userID': contactChatID,
          };
          var response = await getRequest(
              url: "/getuserdetails", headers: headers, queryParam: params);
          if (response?.statusCode == 200) {
            String profileImageUrl = response.data['user']['displayPicture'];
            if (profileImageUrl != null &&
                profileImageUrl != '' &&
                profileImageUrl != pictureUrl) {
              final res = await _downloadService.downloadContactPicture(
                  pictureUrl: profileImageUrl,
                  contactName: displayName,
                  contactNumber: phoneNumber);
              if (res != null) {
                picturePath = res;
                profilePictureDownloaded = 1;
                rebuildScreens();
              }
            }
          }
        }
      } catch (e) {
        throw e;
      }
    }
  }
  // Future _makeAsRead() async {
  //   final _userToken = _authService.token;
  //   try {
  //     Map<String, String> body = {
  //       "threadID": threadId,
  //     };
  //     Map<String, String> headers = {
  //       "Content-Type": "application/x-www-form-urlencoded",
  //       "authorization": "Bearer $_userToken",
  //     };

  //     var response = await patchResquest(
  //       url: "/markasread",
  //       body: body,
  //       headers: headers,
  //     );
  //     // debugPrint(response);
  //     return response;
  //   } catch (e) {
  //     if (e is DioError) {
  //       debugPrint(
  //         e.response.data,
  //       );
  //     }
  //     debugPrint(e.runtimeType);
  //     debugPrint(e.toString());
  //     throw e;
  //   }
  // }
}
