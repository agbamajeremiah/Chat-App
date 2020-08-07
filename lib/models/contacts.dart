import 'package:MSG/services/database_service.dart';

class MyContact {
  String contactId;
  String fullName;
  String phoneNumber;
  bool isActive;
  String status;
  DateTime lastSeen;

  MyContact(
      {this.contactId,
      this.fullName,
      this.status,
      this.isActive,
      this.phoneNumber});
  factory MyContact.fromSyncMap(Map<String, dynamic> json) => MyContact(
        status: json["status"],
        isActive: json["isActive"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseService.COLUMN_NAME: fullName,
      DatabaseService.COLUMN_NUMBER: phoneNumber,
      DatabaseService.COLUMN_REG_STATUS: false
    };
    if (contactId != null) {
      map[DatabaseService.COLUMN_ID] = contactId;
    }
    return map;
  }

  MyContact.fromMap(Map<String, dynamic> map) {
    contactId = map[DatabaseService.COLUMN_ID].toString();
    fullName = map[DatabaseService.COLUMN_NAME];
    phoneNumber = map[DatabaseService.COLUMN_NUMBER];
  }
}
