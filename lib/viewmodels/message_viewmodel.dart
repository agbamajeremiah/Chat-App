import 'dart:async';
import 'package:MSG/locator.dart';
import 'package:MSG/models/chat.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/state_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/socket_services.dart';
import 'package:stacked/stacked.dart';

class MessageViewModel extends ReactiveViewModel {
  final SocketServices _socketService = locator<SocketServices>();
  final StateService _stateService = locator<StateService>();

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
            element.id, element.memberPhone, rebuildScreens);
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

  bool get rebuild => _stateService.rebuildPage;
  void rebuildScreens() {
    _stateService.updatePages();
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_stateService];
}
