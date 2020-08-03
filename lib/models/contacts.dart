import 'package:MSG/services/database_service.dart';

class MyContact {
  String contactId;
  String fullName;
  String number;

  MyContact({this.contactId, this.fullName, this.number});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseService.COLUMN_NAME: fullName,
      DatabaseService.COLUMN_NUMBER: number
    };
    if (contactId != null) {
      map[DatabaseService.COLUMN_ID] = contactId;
    }
    return map;
  }

  MyContact.fromMap(Map<String, dynamic> map) {
    contactId = map[DatabaseService.COLUMN_ID].toString();
    fullName = map[DatabaseService.COLUMN_NAME];
    number = map[DatabaseService.COLUMN_NUMBER];
  }
}
