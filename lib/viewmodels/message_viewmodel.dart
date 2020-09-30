import 'dart:async';
import 'package:MSG/locator.dart';
import 'package:MSG/models/chat.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/socket_services.dart';
import 'package:MSG/utils/connectivity.dart';
import 'package:MSG/viewmodels/base_model.dart';

class MessageViewModel extends BaseModel {
  @override
  bool get busy => super.busy;
  final SocketServices _socketService = locator<SocketServices>();

  void rebuildScreen() {
    notifyListeners();
  }

  void initialise() async {
    final internetStatus = await checkInternetConnection();
    if (internetStatus == true) {
      if (_socketService.socketIO != null) {
        _socketService.registerSocketId();
      } else {
        _socketService.connectSockets();
        await Future.delayed(Duration(seconds: 2))
            .whenComplete(() => _socketService.registerSocketId());
      }
      List<Chat> chat = await getAllChats();
      chat.forEach((element) async {
        _socketService.subscribeToThread(
            element.id, element.memberPhone, rebuildScreen);
      });
    }
    // Timer.periodic(Duration(seconds: 5), (Timer t) {
    //   print("Get new mesage");
    //   getAllChats();
    //   notifyListeners();
    // });
  }

  //Get saved chat/tread from db
  Future<List<Chat>> getAllChats() async {
    //test
    //await DatabaseService.db.deleteDb();
    //first run
    List<Chat> activeChat = [];
    List chats = await DatabaseService.db.getAllChatsFromDb();
    chats.forEach((element) {
      if (element.lastMessage != null) {
        activeChat.add(element);
      }
    });
    return activeChat;
  }

  // Future syncChat() async {
  //   final internetStatus = await checkInternetConnection();
  //   if (internetStatus == true) {
  //     await _messageService.getSyncChats();
  //   }
  // }
}
