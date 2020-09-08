class Chat {
  final String id;
  final String memberPhone;
  final String displayName;
  final String lastMessage;
  final String lastMsgTime;
  final String lastMsgStatus;

  Chat(
      {this.id,
      this.memberPhone,
      this.displayName,
      this.lastMessage,
      this.lastMsgTime,
      this.lastMsgStatus});
  factory Chat.fromMap(Map<String, dynamic> map) => Chat(
        id: map['id'],
        displayName:
            map['displayName'] != null ? map['displayName'] : map['members'],
        memberPhone:
            map['phoneNumber'] != null ? map['phoneNumber'] : map['members'],
        lastMessage: map['lastMessage'],
        lastMsgTime: map['lastMsgTime'],
        lastMsgStatus: map['status'],
      );

  Map<String, dynamic> toMap() => {
        id: id,
        displayName: displayName,
        memberPhone: memberPhone,
        lastMessage: lastMessage,
        lastMsgTime: lastMsgTime,
        lastMessage: lastMsgStatus,
      };
}
