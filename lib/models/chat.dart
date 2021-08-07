class Chat {
  final String id;
  final String memberPhone;
  final String displayName;
  final String lastMessage;
  final String lastMsgTime;
  final String lastMsgStatus;
  final int unreadMsgCount;
  final int favourite;
  final String contactChatID;
  final String pictureUrl;
  final String picturePath;
  final int profilePictureDownloaded;

  Chat({
    this.id,
    this.memberPhone,
    this.displayName,
    this.lastMessage,
    this.lastMsgTime,
    this.lastMsgStatus,
    this.unreadMsgCount,
    this.favourite,
    this.contactChatID,
    this.pictureUrl,
    this.picturePath,
    this.profilePictureDownloaded,
  });
  // factory Chat.fromMap(Map<String, dynamic> map) => Chat(
  //       id: map['id'],
  //       displayName:
  //           map['displayName'] != null ? map['displayName'] : map['members'],
  //       memberPhone:
  //           map['phoneNumber'] != null ? map['phoneNumber'] : map['members'],
  //       lastMessage: map['lastMessage'],
  //       lastMsgTime: map['lastMsgTime'],
  //       lastMsgStatus: map['status'],
  //       favourite: map['favourite'],
  //       contactChatID: map['chatID'],
  //       pictureUrl: map['picture_url'],
  //       picturePath: map['picture_path'],
  //     );

  // Map<String, dynamic> toMap() => {
  //       id: id,
  //       displayName: displayName,
  //       memberPhone: memberPhone,
  //       lastMessage: lastMessage,
  //       lastMsgTime: lastMsgTime,
  //       lastMsgStatus: lastMsgStatus,
  //       contactChatID: contactChatID,
  //       pictureUrl: pictureUrl,
  //       picturePath: picturePath,
  //     };
}
