import 'dart:convert';
import 'package:MSG/constant/base_url.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/core/network/api_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/locator.dart';

class SocketServices {
  SocketIO socketIO;
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();

  //Socket Connection
  void connectSockets(
      Function rebuild, Function updateOpenChat, Function updateDeliveredChat) {
    socketIO = SocketIOManager().createSocketIO(BasedUrl, '/',
        query: 'chatID=${_authService.userID}',
        socketStatusCallback: _socketStatus);
    socketIO.init();
    //Suscribe to new socket messsage
    socketIO.subscribe('new message', (dynamic socketMessage) async {
      var newMessage = json.decode(socketMessage);
      Map message = newMessage['message'][0];
      if (message['sender'] != _authService.userNumber) {
        var isThreadSaved =
            await DatabaseService.db.checkIfThreadExist(message['threadID']);
        if (isThreadSaved != true) {
          Thread newThread = Thread(
              id: message['threadID'],
              members: message['sender'],
              favourite: 0);
          DatabaseService.db.insertThread(newThread);
        }
        var isContactSaved =
            await DatabaseService.db.checkIfContactExist(message['sender']);
        if (isContactSaved != true) {
          final newContact = MyContact(
            phoneNumber: message['sender'],
            regStatus: 1,
            pictureDownloaded: 0,
            savedPhone: 0,
          );
          await DatabaseService.db.insertContact(newContact);
        }
        DatabaseService.db.insertNewMessage(ChatMessage.fromMap(message));
        updateOpenChat(ChatMessage.fromMap(message));
        await _updateReceivedMessges(messageID: message['_id']);
        rebuild();
      }
    });
    //suscribe to mark received
    socketIO.subscribe('updated message', (dynamic socketMessage) async {
      var update = json.decode(socketMessage);
      Map updatedMsg = update['message'][0];
      if (updatedMsg['sender'] == _authService.userNumber &&
          updatedMsg['status'] == 'DELIVERED') {
        updateDeliveredChat(ChatMessage.fromMap(updatedMsg));
        await DatabaseService.db
            .updateDeliveredMsgStatus(updatedMsg['messageId']);
        rebuild();
      }
    });
    //suscribe to mark as read
    // socketIO.subscribe('mark as read', (dynamic socketMessage) {
    //   print("Socket Read Message:");
    //   var update = json.decode(socketMessage);
    //   print(update);
    //   List updatedMesssages = update['message'];
    //   if (updatedMesssages.length > 0) {
    //     updatedMesssages.forEach((mes) async {
    //       if (mes['sender'] == _authService.userNumber &&
    //           mes['status'] == 'READ') {
    //         await DatabaseService.db
    //             .updateMessageStatus(mes['messageId'], mes['status']);
    //       }
    //     });
    //     rebuild();
    //   }
    // });
    socketIO.connect();
  }

  //Function to make rest request to mark received message as delivered
  Future _updateReceivedMessges({@required String messageID}) async {
    final _userToken = _authService.token;
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
        debugPrint(
          e.response.statusCode.toString(),
        );
      }
      print(e.runtimeType);
      print(e.toString());
      throw e;
    }
  }

  void _socketStatus(dynamic data) {
    // print("Socket status: " + data);
  }
}
