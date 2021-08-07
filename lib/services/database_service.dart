import 'package:MSG/models/chat.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/models/thread.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  //Contact  table fields
  static const String TABLE_CONTACT = "contacts";
  static const String COLUMN_NUMBER = "phoneNumber";
  static const String COLUMN_NAME = "displayName";
  static const String COLUMN_REG_STATUS = "reg_status";
  static const String COLUMN_CHAT_ID = "chat_id";
  static const String COLUMN_PROFILE_PICTURE_URL = "picture_url";
  static const String COLUMN_PROFILE_DOWNLOAD_PATH = "picture_path";
  static const String COLUMN_PROFILE_PICTURE_DOWNLOADED = "picture_downloaded";
  static const String COLUMN_SAVED_PHONE = "saved_phone";

  //Thread  table fields
  static const String TABLE_THREAD = "threads";
  static const String COLUMN_THREAD_ID = "id";
  static const String COLUMN_MEMBER = "members";
  static const String COLUMN_FAVOURITE = "is_favourite";

  //Message  table fields
  static const String TABLE_MESSAGE = "messages";
  static const String COLUMN_MESSAGE_ID = "id";
  static const String COLUMN_MESSAGE_SERVER_ID = "message_Server_id";
  static const String COLUMN_CONTENT = "content";
  static const String COLUMN_MSG_THREAD_ID = "thread_id";
  static const String COLUMN_STATUS = "status";
  static const String COLUMN_SENDER = "sender";
  static const String COLUMN_CREATED_AT = "created_at";
  static const String COLUMN_QUOTE = "quote";

  DatabaseService._();
  static final DatabaseService db = DatabaseService._();
  static final dbVersion = 2;
  static final dbName = "msg_db.db";

  Database _database;
  Future<Database> get database async {
    debugPrint("Database getter called");
    if (_database != null) {
      return _database;
    }
    _database = await createDatabase();
    return _database;
  }

  Future deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);
    await deleteDatabase(path);
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, dbName),
      version: dbVersion,
      onCreate: (Database database, int version) async {
        await database.execute(
          "CREATE TABLE $TABLE_CONTACT ("
          "$COLUMN_NUMBER TEXT UNIQUE PRIMARY KEY, "
          "$COLUMN_NAME TEXT, "
          "$COLUMN_REG_STATUS INTEGER NOT NULL ,"
          "$COLUMN_CHAT_ID TEXT ,"
          "$COLUMN_PROFILE_PICTURE_URL TEXT ,"
          "$COLUMN_PROFILE_DOWNLOAD_PATH  TEXT ,"
          "$COLUMN_PROFILE_PICTURE_DOWNLOADED INTEGER NOT NULL ,"
          "$COLUMN_SAVED_PHONE INTEGER NOT NULL "
          ")",
        );
        await database.execute(
          "CREATE TABLE $TABLE_THREAD ("
          "$COLUMN_THREAD_ID TEXT UNIQUE PRIMARY KEY, "
          "$COLUMN_MEMBER TEXT, "
          "$COLUMN_FAVOURITE INTEGER NOT NULL "
          ")",
        );
        await database.execute(
          "CREATE TABLE $TABLE_MESSAGE ("
          "$COLUMN_MESSAGE_ID TEXT UNIQUE PRIMARY KEY, "
          "$COLUMN_MESSAGE_SERVER_ID TEXT, "
          "$COLUMN_CONTENT TEXT, "
          "$COLUMN_MSG_THREAD_ID TEXT, "
          "$COLUMN_SENDER TEXT, "
          "$COLUMN_STATUS TEXT, "
          "$COLUMN_CREATED_AT TEXT, "
          "$COLUMN_QUOTE TEXT "
          ")",
        );
      },
    );
  }

  Future<List<MyContact>> getRegContactsFromDb() async {
    final db = await database;
    List<MyContact> allContacts = [];
    var contacts = await db.query(
      TABLE_CONTACT,
      where: "$COLUMN_REG_STATUS = ? AND $COLUMN_SAVED_PHONE = ? ",
      orderBy: "$COLUMN_NAME ASC",
      whereArgs: [1, 1],
    );
    contacts.forEach((cont) {
      MyContact contact = MyContact.fromMap(cont);
      allContacts.add(contact);
    });
    return allContacts;
  }

  Future<List<MyContact>> getUnRegContactsFromDb() async {
    final db = await database;
    List<MyContact> allContacts = [];
    var contacts = await db.query(TABLE_CONTACT,
        where:
            "$COLUMN_REG_STATUS = ? AND $COLUMN_SAVED_PHONE = ? AND $COLUMN_NUMBER != ?",
        orderBy: "$COLUMN_NAME ASC",
        whereArgs: [0, 1, ""]);
    contacts.forEach((cont) {
      MyContact contact = MyContact.fromMap(cont);
      allContacts.add(contact);
    });
    return allContacts;
  }

  Future<List<MyContact>> geContactsForSyncFromDb() async {
    final db = await database;
    List<MyContact> allContacts = [];
    var contacts = await db.query(TABLE_CONTACT,
        where:
            "$COLUMN_REG_STATUS = ? OR $COLUMN_SAVED_PHONE = ? AND $COLUMN_NUMBER != ?",
        orderBy: "$COLUMN_NAME ASC",
        whereArgs: [0, 0, ""]);
    contacts.forEach((cont) {
      MyContact contact = MyContact.fromMap(cont);
      allContacts.add(contact);
    });
    return allContacts;
  }

  Future<Map> getContactThread(String phoneNumber) async {
    final db = await database;
    String subNumber;
    if (phoneNumber.startsWith("+")) {
      subNumber = phoneNumber.substring(4);
    } else {
      subNumber = phoneNumber.substring(1);
    }
    var trd = await db.query(TABLE_THREAD,
        columns: [COLUMN_THREAD_ID, COLUMN_FAVOURITE],
        where: "$COLUMN_MEMBER LIKE ?",
        whereArgs: ["%$subNumber"]);
    if (trd.length > 0) {
      final Map threadMap = {
        'id': trd[0]['id'],
        'favourite': trd[0]['is_favourite']
      };
      return threadMap;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getContactDetails(String threadId) async {
    Map<String, dynamic> contactDetails = Map();
    final db = await database;
    var phoneNumberResult = await db.query(TABLE_THREAD,
        columns: [COLUMN_MEMBER],
        where: '$COLUMN_THREAD_ID = ?',
        whereArgs: [threadId],
        limit: 1);
    contactDetails['phoneNumber'] = phoneNumberResult[0][COLUMN_MEMBER];
    String subMemberPhone;
    if (contactDetails['phoneNumber'].startsWith("+")) {
      subMemberPhone = contactDetails['phoneNumber'].substring(4);
    } else {
      subMemberPhone = contactDetails['phoneNumber'].substring(1);
    }
    var memberDetails = await db.query(TABLE_CONTACT,
        where: "$COLUMN_NUMBER LIKE ? AND $COLUMN_REG_STATUS = ?",
        whereArgs: ["%$subMemberPhone", 1],
        limit: 1);
    if (memberDetails.isNotEmpty) {
      contactDetails['displayName'] = memberDetails[0][COLUMN_NAME];
      contactDetails['contactChatID'] = memberDetails[0][COLUMN_CHAT_ID];
      contactDetails['pictureUrl'] =
          memberDetails[0][COLUMN_PROFILE_PICTURE_URL];
      contactDetails['picturePath'] =
          memberDetails[0][COLUMN_PROFILE_DOWNLOAD_PATH];
      contactDetails['pictureDownloaded'] =
          memberDetails[0][COLUMN_PROFILE_PICTURE_DOWNLOADED];
    }
    return contactDetails;
  }

  Future<Map<String, dynamic>> getSingleContactFromDb(String number) async {
    final db = await database;
    String subNumber;
    if (number.startsWith("+")) {
      subNumber = number.substring(4);
    } else {
      subNumber = number.substring(1);
    }
    var contactDetails = await db.query(TABLE_CONTACT,
        where: "$COLUMN_NUMBER LIKE ? ", whereArgs: ["%$subNumber"], limit: 1);
    if (contactDetails.length == 0) {
      return null;
    }
    return contactDetails[0];
  }

  //Get all threads with last message
  Future<List<Chat>> getAllChatsFromDb(String userNumber) async {
    List<Chat> allChat = [];
    final db = await database;
    List chats = await db.rawQuery(
        '''SELECT * FROM (SELECT t.id, t.members, t.is_favourite, msg.content as lastMessage, msg.created_at as lastMsgTime, msg.status as status
        FROM threads AS t
        JOIN messages AS msg ON t.id = msg.thread_id
        ORDER BY lastMsgTime DESC) AS chat  
        GROUP BY id ORDER BY chat.lastMsgTime DESC''');
    // print(chats);
    for (int i = 0; i < chats.length; i++) {
      String threadId = chats[i]['id'];
      String memberPhone = chats[i]["members"];
      String displayName;
      String contactChatID;
      String pictureUrl;
      String picturePath;
      int pictureDownloaded;
      String msgContent = chats[i]["lastMessage"];
      String msgTime = chats[i]["lastMsgTime"];
      String lastMsgStatus = chats[i]["status"];
      int favourite = chats[i]['is_favourite'];
      String subMemberPhone;
      if (memberPhone.startsWith("+")) {
        subMemberPhone = memberPhone.substring(4);
      } else {
        subMemberPhone = memberPhone.substring(1);
      }
      if (msgContent.isNotEmpty) {
        var memberDetails = await db.query(TABLE_CONTACT,
            where: "$COLUMN_NUMBER LIKE ? AND $COLUMN_REG_STATUS = ?",
            whereArgs: ["%$subMemberPhone", 1],
            limit: 1);
        if (memberDetails.isNotEmpty) {
          displayName = memberDetails[0][COLUMN_NAME];
          contactChatID = memberDetails[0][COLUMN_CHAT_ID];
          pictureUrl = memberDetails[0][COLUMN_PROFILE_PICTURE_URL];
          picturePath = memberDetails[0][COLUMN_PROFILE_DOWNLOAD_PATH];
          pictureDownloaded =
              memberDetails[0][COLUMN_PROFILE_PICTURE_DOWNLOADED];
        }
        var result = await db.rawQuery(
            "SELECT COUNT (*) FROM $TABLE_MESSAGE WHERE thread_id = ? AND sender != ? AND status != ?",
            [threadId, userNumber, "READ"]);
        final unreadMsgCount = Sqflite.firstIntValue(result);
        Chat chat = Chat(
          displayName: displayName == null || displayName.isEmpty ? '' : displayName,
          id: threadId,
          memberPhone: memberPhone,
          lastMessage: msgContent,
          lastMsgTime: msgTime,
          lastMsgStatus: lastMsgStatus,
          unreadMsgCount: unreadMsgCount,
          favourite: favourite,
          contactChatID: contactChatID,
          pictureUrl: pictureUrl,
          picturePath: picturePath,
          profilePictureDownloaded: pictureDownloaded,
        );
        // print('chatIDTest: ${chat.contactChatID}');
        // print('URL: $pictureUrl');
        // print('Path: $picturePath');
        // print('Downloaded: $pictureDownloaded');
        allChat.add(chat);
      }
    }
    // print(allChat);
    return allChat;
  }

  Future<List<ChatMessage>> fetchSingleChatMessageFromDbWithLimit(
      String threadId, int messagesFetched, int limit) async {
    final db = await database;
    List<ChatMessage> messages = [];
    var chats = await db.query(TABLE_MESSAGE,
        where: "$COLUMN_MSG_THREAD_ID = ?",
        orderBy: "$COLUMN_CREATED_AT DESC",
        offset: messagesFetched,
        limit: limit,
        whereArgs: [threadId]);
    chats.forEach((message) {
      messages.add(ChatMessage.fromDBMap(message));
    });
    return messages;
  }

  Future<bool> checkIfContactExist(String number) async {
    final db = await database;
    String subNumber;
    if (number.length < 5) {
      return false;
    } else {
      if (number.startsWith("+")) {
        subNumber = number.substring(4);
      } else {
        subNumber = number.substring(1);
      }
      var contactResult = await db.query(TABLE_CONTACT,
          columns: [COLUMN_NUMBER],
          where: '$COLUMN_NUMBER LIKE ?',
          whereArgs: ["%$subNumber"],
          limit: 1);
      if (contactResult.isEmpty) {
        return false;
      } else {
        return true;
      }
    }
  }

  Future<bool> checkIfThreadExist(String threadID) async {
    final db = await database;
    var threadResult = await db.query(TABLE_THREAD,
        columns: [COLUMN_THREAD_ID],
        where: '$COLUMN_THREAD_ID = ?',
        whereArgs: [threadID],
        limit: 1);
    if (threadResult.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future checkIfMessageExist(String messageID) async {
    final db = await database;
    var messageResult = await db.query(TABLE_MESSAGE,
        where: '$COLUMN_MESSAGE_ID = ?',
        whereArgs: [messageID],
        limit: 1);
    if (messageResult.isEmpty) {
      return false;
    } else {
      return messageResult[0];
    }
  }

  Future<List<MyContact>> getContactsWithoutImagesFromDb() async {
    final db = await database;
    List<MyContact> contacts = [];
    var chats = await db.query(TABLE_CONTACT,
        where:
            "$COLUMN_REG_STATUS == ? AND $COLUMN_PROFILE_PICTURE_DOWNLOADED != ?",
        whereArgs: [1, 1]);
    chats.forEach((cont) {
      // print(cont);
      contacts.add(MyContact.fromMap(cont));
    });
    return contacts;
  }

  Future<List<ChatMessage>> getUnsentChatMessageFromDb(
      String userNumber) async {
    final db = await database;
    List<ChatMessage> messages = [];
    List unsentMessages = await db.rawQuery('''SELECT msg.*, thd.members 
        FROM messages AS msg
        JOIN threads AS thd ON msg.thread_id = thd.id  WHERE $COLUMN_STATUS = ?
        ''', ['PENDING']);
    if (unsentMessages.length > 0) {
      unsentMessages.forEach((message) {
        messages.add(ChatMessage.fromDBMap(message));
      });
      // print(messages);
    }
    return messages;
  }

  Future<List<ChatMessage>> getAllUnsentFromDb() async {
    final db = await database;
    List<ChatMessage> messages = [];
    var chats = await db.query(TABLE_MESSAGE,
        where: "$COLUMN_STATUS = ?",
        orderBy: "$COLUMN_CREATED_AT DESC",
        whereArgs: ["PENDING"]);
    // print(chats);
    chats.forEach((message) {
      messages.add(ChatMessage.fromDBMap(message));
    });
    // print(messages);
    return messages;
  }

  Future<void> insertContact(MyContact contact) async {
    final db = await database;
    await db.insert(
      TABLE_CONTACT,
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> insertThread(Thread thread) async {
    final db = await database;
    await db.insert(
      TABLE_THREAD,
      thread.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertNewMessage(ChatMessage message) async {
    final db = await database;
    await db.insert(
      TABLE_MESSAGE,
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // print("message inserted");
  }

//Update reg contacts
  Future<void> updateRegContact(Map updateData, String number) async {
    final db = await database;
    String matchNumber;
    if (number.startsWith("+")) {
      matchNumber = number.substring(4);
    } else {
      matchNumber = number.substring(1);
    }
    // print(matchNumber);
    await db.update(
      TABLE_CONTACT,
      updateData,
      where: "$COLUMN_NUMBER Like '%$matchNumber'",
    );
  }

//Update all mesages as read when a chat is opened
  Future<void> updateReadMessages(threadId, userNumber) async {
    final db = await database;
    await db.update(TABLE_MESSAGE, {'status': 'READ'},
        where: "thread_id = ? AND sender != ? AND status != ?",
        whereArgs: [threadId, userNumber, "READ"]);
    print('success: Messages');
  }

//update message sent
  Future<void> updateSentMsgStatus(String messadeID) async {
    final db = await database;
    await db.update(TABLE_MESSAGE, {'status': 'SENT'},
        where: "$COLUMN_MESSAGE_ID = ?", whereArgs: [messadeID]);
  }

  //update message delivered
  Future<void> updateDeliveredMsgStatus(String messadeID) async {
    final db = await database;
    await db.update(TABLE_MESSAGE, {'status': 'DELIVERED'},
        where: "$COLUMN_MESSAGE_ID = ?", whereArgs: [messadeID]);
  }

  //mark chat/thread as favourite
  Future<void> addChatAsFav(String threadID) async {
    final db = await database;
    await db.update(TABLE_THREAD, {'is_favourite': 1},
        where: "$COLUMN_THREAD_ID = ?", whereArgs: [threadID]);
    // print("added as fav");
  }

  //remove chat/tread from favourite
  Future<void> removeChatFromFav(String threadID) async {
    final db = await database;
    await db.update(TABLE_THREAD, {'is_favourite': 0},
        where: "$COLUMN_THREAD_ID= ?", whereArgs: [threadID]);
    // print("Removed from fav");
  }
}
