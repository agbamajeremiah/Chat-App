class User {
  final String userId;
  final String mobileNumber;
  final String displayName;
  User({this.userId, this.mobileNumber, this.displayName});
}

final allContacts = List<User>.generate(
    100,
    (index) => User(
        userId: index.toString(),
        mobileNumber: "+234 80 000$index",
        displayName: "Jerry${index + 1}"));
