import 'package:MSG/services/database_service.dart';
import 'package:MSG/utils/util_functions.dart';
import 'package:flutter/foundation.dart';

class ChatMessage {
  String isQuote;
  String createdAt;
  String id;
  String sender;
  String content;
  String status;
  String threadId;
  String receiver;
  String messageServerId;

  ChatMessage({
    @required this.isQuote,
    @required this.createdAt,
    @required this.id,
    @required this.sender,
    @required this.content,
    @required this.status,
    @required this.threadId,
    @required this.messageServerId
  });

  factory ChatMessage.fromMap(Map<String, dynamic> json) => ChatMessage(
        isQuote: json["isQuote"].toString(),
        createdAt: convertToLocalTime(json["createdAt"]),
        id: json["messageId"],
        sender: json["sender"],
        content: json["content"],
        status: json["status"],
        threadId: json["threadID"],
        messageServerId: json["_id"]
      );

  Map<String, dynamic> toMap() => {
        DatabaseService.COLUMN_MESSAGE_ID: id,
        DatabaseService.COLUMN_CONTENT: content,
        DatabaseService.COLUMN_MSG_THREAD_ID: threadId,
        DatabaseService.COLUMN_SENDER: sender,
        DatabaseService.COLUMN_STATUS: status,
        DatabaseService.COLUMN_CREATED_AT: createdAt,
        DatabaseService.COLUMN_QUOTE: isQuote,
        DatabaseService.COLUMN_MESSAGE_SERVER_ID : messageServerId
      };
  ChatMessage.fromDBMap(Map<String, dynamic> map) {
    id = map[DatabaseService.COLUMN_MESSAGE_ID];
    content = map[DatabaseService.COLUMN_CONTENT];
    sender = map[DatabaseService.COLUMN_SENDER];
    status = map[DatabaseService.COLUMN_STATUS];
    threadId = map[DatabaseService.COLUMN_MSG_THREAD_ID];
    createdAt = map[DatabaseService.COLUMN_CREATED_AT];
    isQuote = map[DatabaseService.COLUMN_QUOTE];
    receiver = map[DatabaseService.COLUMN_MEMBER];
    messageServerId = map[DatabaseService.COLUMN_MESSAGE_SERVER_ID];
  }
}
