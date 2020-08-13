import 'package:flutter/foundation.dart';

class Thread {
  final List<String> members;
  final String id;

  Thread({
    @required this.members,
    @required this.id,
  });

  factory Thread.fromMap(Map<String, dynamic> json) => Thread(
        members: List<String>.from(json["members"].map((x) => x)),
        id: json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "members": List<dynamic>.from(members.map((x) => x)),
        "_id": id,
      };
}
