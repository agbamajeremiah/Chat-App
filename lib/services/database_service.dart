import 'package:MSG/models/contacts.dart';
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
  static const String COLUMN_CREATED_AT = "created_id";
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

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'msgDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("creating contact db");
        await database.execute(
          "CREATE TABLE $TABLE_CONTACT ("
          "$COLUMN_ID INTEGER PRIMARY KEY, "
          "$COLUMN_NAME TEXT, "
          "$COLUMN_NUMBER TEXT, "
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
          "$COLUMN_MESSAGE_ID TEXT PRIMARY KEY, "
          "$COLUMN_CONTENT TEXT, "
          "$COLUMN_MSG_THREAD_ID TEXT, "
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

  Future<List<MyContact>> getUnRegContactsFromDb() async {
    final db = await database;
    List<MyContact> allContacts = List<MyContact>();
    var contacts = await db.query(TABLE_CONTACT,
        columns: [COLUMN_NUMBER, COLUMN_REG_STATUS],
        where: "$COLUMN_REG_STATUS = ?",
        whereArgs: [0]);
    contacts.forEach((cont) {
      MyContact contact = MyContact.fromMap(cont);
      allContacts.add(contact);
    });
    return allContacts;
  }

  Future<List<Thread>> getAllChatsFromDb() async {
    final db = await database;
    List<Thread> allChats = List<Thread>();
    var chats = await db.query(
      TABLE_THREAD,
      columns: [COLUMN_THREAD_ID, COLUMN_MEMBER],
    );
    chats.forEach((chat) {
      allChats.add(Thread.fromDBMap(chat));
    });
    return allChats;
  }

  Future<void> insertContact(MyContact contact) async {
    final db = await database;
    await db.insert(
      TABLE_CONTACT,
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertThread(Thread thread) async {
    final db = await database;
    await db.insert(
      TABLE_THREAD,
      thread.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> updateRegContact(String phoneNumber) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE $TABLE_CONTACT 
      SET $COLUMN_REG_STATUS = ?
      WHERE $COLUMN_NUMBER Like '%$phoneNumber'
    ''', [1]);
  }
}
