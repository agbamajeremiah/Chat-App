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
    setBusy(true);
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
  }

  //Get saved chat/tread from db
  Future<List<Chat>> getAllChats() async {
    List<Chat> activeChat = await DatabaseService.db.getAllChatsFromDb();
    return activeChat;
  }

  // Future syncChat() async {
  //   final internetStatus = await checkInternetConnection();
  //   if (internetStatus == true) {
  //     await _messageService.getSyncChats();
  //   }
  // }
}
