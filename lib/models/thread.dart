import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:flutter/foundation.dart';

class Thread {
  String members;
  String id;

  Thread({
    @required this.members,
    @required this.id,
  });

  static AuthenticationSerivice _authSerivice =
      locator<AuthenticationSerivice>();
  static String userNumber = _authSerivice.userNumber;

  factory Thread.fromMap(Map<String, dynamic> json) => Thread(
        members: json["members"][0].endsWith(userNumber.substring(5))
            ? json["members"][1]
            : json["members"][0],
        id: json["_id"],
      );

  Map<String, dynamic> toMap() => {
        DatabaseService.COLUMN_MEMBER: members,
        DatabaseService.COLUMN_THREAD_ID: id,
      };
  Thread.fromDBMap(Map<String, dynamic> map) {
    id = map[DatabaseService.COLUMN_THREAD_ID];
    members = map[DatabaseService.COLUMN_MEMBER];
  }
}
