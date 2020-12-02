import 'package:MSG/models/chat.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/models/thread.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  //Contact  table fields
  static const String TABLE_CONTACT = "contacts";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "displayName";
  static const String COLUMN_NUMBER = "phoneNumber";
  static const String COLUMN_REG_STATUS = "reg_status";

  //Thread  table fields
  static const String TABLE_THREAD = "threads";
  static const String COLUMN_THREAD_ID = "id";
  static const String COLUMN_MEMBER = "members";

  //Message  table fields
  static const String TABLE_MESSAGE = "messages";
  static const String COLUMN_MESSAGE_ID = "id";
  static const String COLUMN_CONTENT = "content";
  static const String COLUMN_MSG_THREAD_ID = "thread_id";
  static const String COLUMN_STATUS = "status";
  static const String COLUMN_SENDER = "sender";
  static const String COLUMN_CREATED_AT = "created_at";
  static const String COLUMN_QUOTE = "quote";

  DatabaseService._();
  static final DatabaseService db = DatabaseService._();

  Database _database;
  Future<Database> get database async {
    print("Database getter called");
    if (_database != null) {
      return _database;
    }
    _database = await createDatabase();
    return _database;
  }
/*
  Future deleteDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "msg_db.db");
    await deleteDatabase(path);
  }
  */

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'new_msg_db.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("creating contact db");
        await database.execute(
          "CREATE TABLE $TABLE_CONTACT ("
          "$COLUMN_ID INTEGER UNIQUE PRIMARY KEY, "
          "$COLUMN_NAME TEXT, "
          "$COLUMN_NUMBER TEXT UNIQUE, "
          "$COLUMN_REG_STATUS INTEGER NOT NULL "
          ")",
        );
        await database.execute(
          "CREATE TABLE $TABLE_THREAD ("
          "$COLUMN_THREAD_ID TEXT UNIQUE PRIMARY KEY, "
          "$COLUMN_MEMBER TEXT "
          ")",
        );
        await database.execute(
          "CREATE TABLE $TABLE_MESSAGE ("
          "$COLUMN_MESSAGE_ID TEXT UNIQUE PRIMARY KEY, "
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
    List<MyContact> allContacts = List<MyContact>();
    var contacts = await db.query(TABLE_CONTACT,
        columns: [COLUMN_ID, COLUMN_NAME, COLUMN_NUMBER, COLUMN_REG_STATUS],
        where: "$COLUMN_REG_STATUS = ?",
        whereArgs: [1]);
    contacts.forEach((cont) {
      MyContact contact = MyContact.fromMap(cont);
      allContacts.add(contact);
    });
    allContacts.forEach((element) {
      print(element.contactId);
      print(element.regStatus);
      print(element.fullName);
    });
    return allContacts;
  }

  Future<List<MyContact>> getUnRegContactsFromDb() async {
    final db = await database;
    List<MyContact> allContacts = List<MyContact>();
    var contacts = await db.query(TABLE_CONTACT,
        where: "$COLUMN_REG_STATUS = ? AND $COLUMN_NUMBER != ?",
        whereArgs: [0, ""]);
    contacts.forEach((cont) {
      MyContact contact = MyContact.fromMap(cont);
      allContacts.add(contact);
    });
    return allContacts;
  }

  Future<List<MyContact>> getAllContactsFromDb() async {
    final db = await database;
    List<MyContact> allContacts = List<MyContact>();
    var contacts = await db.query(
      TABLE_CONTACT,
      columns: [COLUMN_ID, COLUMN_NUMBER, COLUMN_NAME, COLUMN_REG_STATUS],
    );
    contacts.forEach((cont) {
      MyContact contact = MyContact.fromMap(cont);
      allContacts.add(contact);
    });
    return allContacts;
  }

  Future<String> getContactThread(String phoneNumber) async {
    String number = phoneNumber.startsWith("+")
        ? phoneNumber.substring(4)
        : phoneNumber.substring(1);
    print(number);
    final db = await database;
    var trd = await db.query(TABLE_THREAD,
        columns: [COLUMN_THREAD_ID],
        where: "$COLUMN_MEMBER LIKE ?",
        whereArgs: ["%$number"]);
    if (trd.length > 0) {
      return trd[0]['id'];
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getContactDetails(String threadId) async {
    Map<String, dynamic> contactDetails = Map();
    final db = await database;
    var phoneNumberResult = await db.query(TABLE_THREAD,
        columns: [COLUMN_MEMBER],
        where: '$COLUMN_ID = ?',
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
      contactDetails['displayName'] = memberDetails[0]['displayName'];
    } else {
      contactDetails['displayName'] = contactDetails['phoneNumber'];
    }
    return contactDetails;
  }

  Future<List<MyContact>> getSingleContactFromDb(String number) async {
    final db = await database;
    List<MyContact> singleContact = List<MyContact>();
    var contacts = await db.query(TABLE_CONTACT,
        columns: [COLUMN_ID, COLUMN_NAME, COLUMN_NUMBER, COLUMN_REG_STATUS],
        where: "$COLUMN_NUMBER = ?",
        whereArgs: [number]);

    contacts.forEach((cont) {
      MyContact contact = MyContact.fromMap(cont);
      singleContact.add(contact);
    });
    return singleContact;
  }

  Future<List<Chat>> getAllUserThreads() async {
    List<Chat> allChat = [];
    final db = await database;
    var threads = await db
        .query(TABLE_THREAD, columns: [COLUMN_THREAD_ID, COLUMN_MEMBER]);
    threads.forEach((thd) {
      allChat.add(Chat(id: thd['id'], memberPhone: thd['members']));
    });
    // print(allChat);
    return allChat;
  }

  Future<List<Chat>> getAllChatsFromDb(String userNumber) async {
    List<Chat> allChat = [];
    final db = await database;
    List chats = await db.rawQuery(
        '''SELECT * FROM (SELECT t.id, t.members, msg.content as lastMessage, msg.created_at as lastMsgTime, msg.status as status
        FROM threads AS t
        JOIN messages AS msg ON t.id = msg.thread_id
        ORDER BY lastMsgTime ASC) AS chat  
        GROUP BY id ORDER BY chat.lastMsgTime DESC''');
    // print(chats);
    // var threads = await db.query(TABLE_THREAD);
    // print(threads);

    for (int i = 0; i < chats.length; i++) {
      String threadId = chats[i]['id'];
      String memberPhone = chats[i]["members"];
      String displayName;
      String msgContent = chats[i]["lastMessage"];
      String msgTime = chats[i]["lastMsgTime"];
      String lastMsgStatus = chats[i]["status"];
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
          displayName = memberDetails[0]['displayName'];
        } else {
          displayName = memberPhone;
        }
        var result = await db.rawQuery(
            "SELECT COUNT (*) FROM $TABLE_MESSAGE WHERE thread_id = ? AND sender != ? AND status != ?",
            [threadId, userNumber, "READ"]);
        final unreadMsgCount = Sqflite.firstIntValue(result);
        print(unreadMsgCount);
        Chat chat = Chat(
            displayName: displayName,
            id: threadId,
            memberPhone: memberPhone,
            lastMessage: msgContent,
            lastMsgTime: msgTime,
            lastMsgStatus: lastMsgStatus,
            unreadMsgCount: unreadMsgCount);
        allChat.add(chat);
      }
    }
    print(allChat);
    return allChat;
  }

  // Future<List<Message>> getSingleChatMessageFromDb(
  //     String threadId, int offset, int limit) async {
  //   print(threadId);
  //   final db = await database;
  //   List<Message> messages = List<Message>();
  //   var chats = await db.query(TABLE_MESSAGE,
  //       where: "$COLUMN_MSG_THREAD_ID = ?",
  //       orderBy: "$COLUMN_CREATED_AT DESC",
  //       offset: offset,
  //       limit: limit,
  //       whereArgs: [threadId]);
  //   chats.forEach((message) {
  //     messages.add(Message.fromDBMap(message));
  //   });
  //   return messages;
  // }
  Future<List<Message>> getSingleChatMessageFromDb(threadId) async {
    final db = await database;
    List<Message> messages = List<Message>();
    var chats = await db.query(TABLE_MESSAGE,
        where: "$COLUMN_MSG_THREAD_ID = ?",
        orderBy: "$COLUMN_CREATED_AT DESC",
        whereArgs: [threadId]);
    chats.forEach((message) {
      messages.add(Message.fromDBMap(message));
    });
    return messages;
  }

  Future<List<Message>> getUnsentChatMessageFromDb(String userNumber) async {
    final db = await database;
    List<Message> messages = List<Message>();
    List unsentMessages = await db.rawQuery('''SELECT msg.*, thd.members 
        FROM messages AS msg
        JOIN threads AS thd ON msg.thread_id = thd.id  WHERE $COLUMN_STATUS = ?
        ''', ['PENDING']);
    if (unsentMessages.length > 0) {
      unsentMessages.forEach((message) {
        messages.add(Message.fromDBMap(message));
      });
      // print(messages);
    }
    return messages;
  }

  Future<List<Message>> getAllUnsentFromDb() async {
    final db = await database;
    List<Message> messages = List<Message>();
    var chats = await db.query(TABLE_MESSAGE,
        where: "$COLUMN_STATUS = ?",
        orderBy: "$COLUMN_CREATED_AT DESC",
        whereArgs: ["PENDING"]);
    // print(chats);
    chats.forEach((message) {
      messages.add(Message.fromDBMap(message));
    });
    print(messages);
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

  Future<void> insertNewMessage(Message message) async {
    final db = await database;
    await db.insert(
      TABLE_MESSAGE,
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("message inserted");
  }

  Future<void> updateRegContact(String phoneNumber) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE $TABLE_CONTACT 
      SET $COLUMN_REG_STATUS = ?
      WHERE $COLUMN_NUMBER Like '%$phoneNumber'
    ''', [1]);
  }

  Future<void> updateReadMessages(threadId, userNumber) async {
    final db = await database;
    await db.update(TABLE_MESSAGE, {'status': 'READ'},
        where: "thread_id = ? AND sender != ? AND status != ?",
        whereArgs: [threadId, userNumber, "READ"]);
    print('success');
  }

  Future<void> updateMessageStatus(String msgId, String status) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE $TABLE_MESSAGE 
      SET $COLUMN_STATUS = ?
      WHERE $COLUMN_MESSAGE_ID = ?
    ''', [status, msgId]);
    print("message updated");
  }
}
