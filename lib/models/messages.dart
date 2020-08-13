import 'package:flutter/foundation.dart';

class MessageMessage {
  final bool isQuote;
  final DateTime createdAt;
  final String id;
  final String sender;
  final String content;
  final String status;
  final String threadId;

  MessageMessage({
    @required this.isQuote,
    @required this.createdAt,
    @required this.id,
    @required this.sender,
    @required this.content,
    @required this.status,
    @required this.threadId,
  });

  factory MessageMessage.fromMap(Map<String, dynamic> json) => MessageMessage(
        isQuote: json["isQuote"],
        createdAt: DateTime.parse(json["createdAt"]),
        id: json["_id"],
        sender: json["sender"],
        content: json["content"],
        status: json["status"],
        threadId: json["threadID"],
      );

  Map<String, dynamic> toMap() => {
        "isQuote": isQuote,
        "createdAt": createdAt.toIso8601String(),
        "_id": id,
        "sender": sender,
        "content": content,
        "status": status,
        "threadID": threadId,
      };
}
