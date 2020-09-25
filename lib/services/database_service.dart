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

  Future<String> getContactThread(String number) async {
    final db = await database;
    var trd = await db.query(TABLE_THREAD,
        columns: [COLUMN_THREAD_ID],
        where: "$COLUMN_MEMBER = ?",
        whereArgs: [number]);
    if (trd.length > 0) {
      return trd[0]['id'];
    } else {
      return null;
    }
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

  Future<List<Chat>> getAllChatsFromDb2() async {
    final db = await database;
    var threads = await db.query(TABLE_THREAD);
    List<Chat> allChats = await mapChatsToThread(threads);
    print(allChats);
    return allChats;
  }

  Future<List<Chat>> mapChatsToThread(var threads) async {
    final db = await database;
    List<Chat> allChat = [];
    threads.forEach((thd) async {
      String threadId = thd["id"];
      String memberPhone = thd["members"];
      String displayName;
      String displayPhone = memberPhone;
      String msgContent;
      String msgTime;
      String subMemberPhone;
      if (memberPhone.startsWith("+")) {
        subMemberPhone = memberPhone.substring(5);
      } else {
        subMemberPhone = memberPhone.substring(1);
      }
      print(subMemberPhone);
      var lastMsgDetails = await db.query(TABLE_MESSAGE,
          where: "$COLUMN_MSG_THREAD_ID = ?",
          orderBy: "$COLUMN_CREATED_AT DESC",
          limit: 1,
          whereArgs: [threadId]);
      print(lastMsgDetails);
      if (lastMsgDetails.isNotEmpty) {
        msgContent = lastMsgDetails[0]['content'];
        msgTime = lastMsgDetails[0]['created_at'];
        print(lastMsgDetails.isNotEmpty.toString());
        var memberDetails = await db.query(TABLE_CONTACT,
            where: "$COLUMN_NUMBER LIKE ? AND $COLUMN_REG_STATUS = ?",
            whereArgs: ["%$subMemberPhone", 1],
            limit: 1);
        if (memberDetails.isNotEmpty) {
          displayName = memberDetails[0]['displayName'];
          displayPhone = memberDetails[0]['phoneNumber'];
        } else {
          displayName = memberPhone;
        }
        print(threadId + displayName + displayPhone + msgContent + msgTime);
        Chat chat = Chat(
            displayName: displayName,
            id: threadId,
            memberPhone: memberPhone,
            lastMessage: msgContent,
            lastMsgTime: msgTime);

        allChat.add(chat);
      }
    });
    return allChat;
  }

  Future<List<Chat>> getAllChatsFromDb() async {
    final db = await database;
    List<Chat> allChats = [];
    List chats = await db.rawQuery(
        '''SELECT * FROM (SELECT t.id, t.members, contacts.displayName, contacts.phoneNumber, msg.thread_id, msg.content as lastMessage, msg.created_at as lastMsgTime, msg.status as status
        FROM threads AS t
        LEFT JOIN contacts ON t.members = contacts.phoneNumber
        JOIN messages AS msg ON t.id = msg.thread_id
        ORDER BY lastMsgTime DESC) AS chat  
        GROUP BY id ORDER BY chat.lastMsgTime DESC''');
    // print(chats);

    chats.forEach((element) {
      // print(element);
    });
    chats.forEach((chat) {
      allChats.add(Chat.fromMap(chat));
    });
    return allChats;
  }

  Future<List<Message>> getSingleChatMessageFromDb(String threadId) async {
    final db = await database;
    List<Message> messages = List<Message>();
    var chats = await db.query(TABLE_MESSAGE,
        where: "$COLUMN_MSG_THREAD_ID = ?",
        orderBy: "$COLUMN_CREATED_AT DESC",
        whereArgs: [threadId]);
    // print(chats);
    chats.forEach((message) {
      messages.add(Message.fromDBMap(message));
    });
    return messages;
  }

  Future<List<Message>> getUnsentChatMessageFromDb(String threadId) async {
    final db = await database;
    List<Message> messages = List<Message>();
    var chats = await db.query(TABLE_MESSAGE,
        where: "$COLUMN_MSG_THREAD_ID = ? AND $COLUMN_STATUS = ?",
        orderBy: "$COLUMN_CREATED_AT DESC",
        whereArgs: [threadId, "PENDING"]);
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

  Future<void> updateResentMessages(Message message, String oldMsgId) async {
    final db = await database;
    await db.update(
      TABLE_MESSAGE,
      message.toMap(),
      where: "$COLUMN_MESSAGE_ID = ?",
      whereArgs: [oldMsgId],
    );
  }
}
