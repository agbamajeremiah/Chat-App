import 'dart:async';
import 'package:MSG/locator.dart';
import 'package:MSG/models/chat.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/socket_services.dart';
import 'package:MSG/viewmodels/base_model.dart';

class MessageViewModel extends BaseModel {
  @override
  bool get busy => super.busy;
  final SocketServices _socketService = locator<SocketServices>();
  void rebuildScreen() {
    setBusy(true);
  }

  final AuthenticationSerivice _authenticationSerivice =
      locator<AuthenticationSerivice>();
  // String get profileName;
  String get userNumber => _authenticationSerivice.userNumber;

  void initialise() async {
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
            element.id, element.memberPhone, rebuildScreen);
      });
    } catch (e) {
      print(e.toString);
    }
  }

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
