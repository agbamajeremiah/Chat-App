import 'package:MSG/services/database_service.dart';

class MyContact {
  String contactId;
  String fullName;
  String phoneNumber;
  bool isActive;
  int regStatus; // 0 for not registered, 1 for registered
  DateTime lastSeen;

  MyContact(
      {this.contactId,
      this.fullName,
      this.regStatus,
      this.isActive,
      this.phoneNumber});
  factory MyContact.fromSyncMap(Map<String, dynamic> json) => MyContact(
        isActive: json["isActive"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseService.COLUMN_NAME: fullName,
      DatabaseService.COLUMN_NUMBER: phoneNumber,
      DatabaseService.COLUMN_REG_STATUS: regStatus
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
    regStatus = map[DatabaseService.COLUMN_REG_STATUS];
  }
}
