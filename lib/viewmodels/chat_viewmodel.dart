import 'package:MSG/locator.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/utils/api.dart';
import 'package:MSG/viewmodels/base_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ChatViewModel extends BaseModel {
  final AuthenticationSerivice _authService = locator<AuthenticationSerivice>();
  //Fetch all registered contacts from database
  Future<MyContact> getContactInfo(String number) async {
    var contactsData = await DatabaseService.db.getSingleContactFromDb(number);
    String contactName = contactsData[0].fullName != null
        ? contactsData[0].fullName
        : contactsData[0].phoneNumber;
    return MyContact(
        fullName: contactName, phoneNumber: contactsData[0].phoneNumber);
  }

  //send new new nessage
  Future sendMessage(
      {@required String message,
      @required String receiver,
      @required bool isQuote}) async {
    List contacts = ["080000000", "090000000"];
    var response = await sendMsg(receiver, message, isQuote, "");
    print(response);
  }

  Future sendMsg(
      String receiver, String message, bool isQuote, String replyTo) async {
    final _userToken = _authService.token;
    print(_userToken);
    try {
      Map<String, dynamic> body = {
        "receiver": receiver,
        "content": message,
        "isQuote": isQuote,
        "msgRepliedTo": replyTo,
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
          e.response.data,
        );
      }
      print(e.runtimeType);
      print(e.toString());
      throw e;
    }
  }
}
