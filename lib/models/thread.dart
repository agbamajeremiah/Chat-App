import 'package:MSG/locator.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:flutter/foundation.dart';

class Thread {
  String members;
  String id;
  int favourite;

  Thread({
    @required this.members,
    @required this.id,
    @required this.favourite
  });

  static AuthenticationSerivice _authService =
      locator<AuthenticationSerivice>();

  factory Thread.fromMap(Map<String, dynamic> json) => Thread(
        members:
            json["members"][0].endsWith(_authService.userNumber.substring(5))
                ? json["members"][1]
                : json["members"][0],
        id: json["_id"],
        favourite: 0
      );

  Map<String, dynamic> toMap() => {
        DatabaseService.COLUMN_MEMBER: members,
        DatabaseService.COLUMN_THREAD_ID: id,
        DatabaseService.COLUMN_FAVOURITE: favourite
      };
  Thread.fromDBMap(Map<String, dynamic> map) {
    id = map[DatabaseService.COLUMN_THREAD_ID];
    members = map[DatabaseService.COLUMN_MEMBER];
    favourite = map[DatabaseService.COLUMN_FAVOURITE];
  }
}
