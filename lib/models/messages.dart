class Message {
  final String messageId;
  final String messageBody;
  final String sentTime;
  final String receiptTime;
  final String senderId;
  final String receiverId;

  Message(
      {this.messageId,
      this.messageBody,
      this.sentTime,
      this.receiptTime,
      this.senderId,
      this.receiverId});
}
