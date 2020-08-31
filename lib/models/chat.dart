class Chat {
  final String id;
  final String memberPhone;
  final String displayName;
  final String lastMessage;
  final String lastMsgTime;

  Chat({
    this.id,
    this.memberPhone,
    this.displayName,
    this.lastMessage,
    this.lastMsgTime,
  });
  factory Chat.fromMap(Map<String, dynamic> map) => Chat(
      id: map['id'],
      displayName:
          map['displayName'] != null ? map['displayName'] : map['members'],
      memberPhone:
          map['phoneNumber'] != null ? map['phoneNumber'] : map['members'],
      lastMessage: map['lastMessage'],
      lastMsgTime: map['lastMsgTime']);

  Map<String, dynamic> toMap() => {
        id: id,
        displayName: displayName,
        memberPhone: memberPhone,
        lastMessage: lastMessage,
        lastMsgTime: lastMsgTime,
      };
}
