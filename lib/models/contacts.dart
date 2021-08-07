import 'package:MSG/services/database_service.dart';

class MyContact {
  // String contactId;
  String fullName;
  String phoneNumber;
  bool isActive;
  int regStatus; // 0 for not registered, 1 for registered
  DateTime lastSeen;
  String chatId;
  String profilePictureUrl;
  String profilePicturePath;
  int pictureDownloaded; // 0 for not downloaded, 1 for downloaded
  int savedPhone; //0 for reg contact not in phone, 1 for contacts saved in phone

  MyContact({
    this.fullName,
    this.regStatus,
    this.isActive,
    this.phoneNumber,
    this.chatId,
    this.profilePictureUrl,
    this.profilePicturePath,
    this.pictureDownloaded,
    this.savedPhone,
  });
  factory MyContact.fromSyncMap(Map<String, dynamic> json) => MyContact(
        isActive: json["isActive"],
        phoneNumber: json["phoneNumber"],
        chatId: json["_id"],
        profilePictureUrl: json['displayPicture'],
      );

  Map<String, dynamic> toMap() => {
        DatabaseService.COLUMN_NAME: fullName ??  "",
        DatabaseService.COLUMN_NUMBER: phoneNumber,
        DatabaseService.COLUMN_REG_STATUS: regStatus,
        DatabaseService.COLUMN_CHAT_ID: chatId,
        DatabaseService.COLUMN_PROFILE_PICTURE_DOWNLOADED:
            pictureDownloaded != null ? pictureDownloaded : 0,
        DatabaseService.COLUMN_SAVED_PHONE: savedPhone != null ? savedPhone : 0
      };

  MyContact.fromMap(Map<String, dynamic> map) {
    fullName = map[DatabaseService.COLUMN_NAME];
    phoneNumber = map[DatabaseService.COLUMN_NUMBER];
    regStatus = map[DatabaseService.COLUMN_REG_STATUS];
    chatId = map[DatabaseService.COLUMN_CHAT_ID];
    profilePictureUrl = map[DatabaseService.COLUMN_PROFILE_PICTURE_URL];
    profilePicturePath = map[DatabaseService.COLUMN_PROFILE_DOWNLOAD_PATH];
    pictureDownloaded = map[DatabaseService.COLUMN_PROFILE_PICTURE_DOWNLOADED];
    savedPhone = map[DatabaseService.COLUMN_SAVED_PHONE];
  }
}
