import 'package:MSG/models/messages.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

class MessageService with ReactiveServiceMixin {
  MessageService() {
    listenToReactiveValues([_rebuildPage, _singleChatMessage, _openChat]);
  }
  //Single chat list
  RxValue<String> _openChat = RxValue(initial: "");
  String get openChat => _openChat.value;

  //Single chat list
  RxValue<List<ChatMessage>> _singleChatMessage = RxValue(initial: []);
  List get singleChatMessage => _singleChatMessage.value;

  //Reactive Value
  RxValue<bool> _rebuildPage = RxValue(initial: false);
  bool get rebuildPage => _rebuildPage.value;
// create a new chat list for each opened chat
  void setOpenChat(String threadID) {
    _singleChatMessage.value.clear();
    _openChat.value = threadID;
  }

// add single sent message to chat list
  void addNewSentMessage(ChatMessage message) {
    _singleChatMessage.value.insert(0, message);
  }

// update sent message when successful
  void updateSentMessage(ChatMessage sentMessage) {
    int indexOf = _singleChatMessage.value.indexOf(sentMessage);
    sentMessage.status = 'SENT';
    _singleChatMessage.value[indexOf] = sentMessage;
  }

//update socket delivered message in chat view
  void updateDeliveredMessage(ChatMessage updatedMessage) {
    if (updatedMessage.threadId == _openChat.value) {
      for (int i = 0; i < _singleChatMessage.value.length; i++) {
        var mes = _singleChatMessage.value[i];
        if (mes.id == updatedMessage.id) {
          mes.status = 'DELIVERED';
          _singleChatMessage.value[i] = mes;
          break;
        }
      }
    }
  }

// add list of message to chat list
  void addNewDBMessage(List<ChatMessage> messages) {
    _singleChatMessage.value.addAll(messages);
  }
  //Add new socket message received
  void addNewSocketMessage(ChatMessage newMessage) {
    if (newMessage.threadId == _openChat.value) {
      _singleChatMessage.value.insert(0, newMessage);
      // print(_singleChatMessage.value);
    }
  }

  //FXN to update all reactive pages
  void updatePages() {
    _rebuildPage.value = !_rebuildPage.value;
  }

}
