import 'dart:async';
import 'package:MSG/locator.dart';
import 'package:MSG/models/chat.dart';
import 'package:MSG/services/contact_services.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/messaging_sync_service.dart';
import 'package:MSG/utils/connectivity.dart';
import 'package:MSG/viewmodels/base_model.dart';

class MessageViewModel extends BaseModel {
  final MessagingServices _messageService = locator<MessagingServices>();
  final ContactServices _contactService = locator<ContactServices>();

  void initialise() {
    const tenSec = const Duration(seconds: 15);
    Timer.periodic(tenSec, (Timer t) {
      getAllChats();
      notifyListeners();
    });
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

  Future syncChatAndContacs() async {
    final internetStatus = await checkInternetConnection();
    if (internetStatus == true) {
      await _messageService.getSyncChats();
      try {
        await _contactService.syncContacts();
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
