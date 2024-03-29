import 'dart:math';
import 'package:intl/intl.dart';

String convertToTime(String stringTime) {
  return DateFormat.jm().format(DateTime.parse(stringTime));
}

String getFullTime(String stringTime) {
  var returnTime;
  DateTime curTime = DateTime.now();
  DateTime msgTime = DateTime.parse(stringTime);
  int dayDiff = curTime.day - msgTime.day;
  switch (dayDiff) {
    case 0:
      returnTime = DateFormat.jm().format(DateTime.parse(stringTime));
      break;
    case 1:
      returnTime = "Yesterday";
      break;
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
      returnTime = DateFormat.E().add_jm().format(DateTime.parse(stringTime));
      break;
    default:
      returnTime = DateFormat.yMd().format(DateTime.parse(stringTime));
  }
  return returnTime;
}

String getDisplayDate(String stringTime) {
  var returnTime;
  DateTime curTime = DateTime.now();
  DateTime msgTime = DateTime.parse(stringTime);
  int dayDiff = curTime.day - msgTime.day;
  switch (dayDiff) {
    case 0:
      returnTime = "Today";
      break;
    case 1:
      returnTime = "Yesterday";
      break;
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
      returnTime =
          DateFormat.d().add_yMMMM().format(DateTime.parse(stringTime));
      break;
    default:
      returnTime =
          DateFormat.d().add_yMMMM().format(DateTime.parse(stringTime));
  }
  return returnTime;
}

int getColorMatch(String firstLetter) {
  int colorIndex;
  if (firstLetter == "") {
    colorIndex = 0;
  } else {
    String letterToLower = firstLetter.toLowerCase();
    switch (letterToLower) {
      case 'a':
      case 'b':
      case 'c':
        colorIndex = 1;
        break;
      case 'd':
      case 'e':
      case 'f':
        colorIndex = 2;
        break;
      case 'g':
      case 'h':
      case 'i':
        colorIndex = 3;
        break;
      case 'j':
      case 'k':
      case 'l':
        colorIndex = 4;
        break;
      case 'm':
      case 'n':
      case 'o':
        colorIndex = 5;
        break;
      case 'p':
      case 'g':
      case 'r':
        colorIndex = 6;
        break;
      case 's':
      case 't':
      case 'u':
        colorIndex = 7;
        break;
      case 'v':
      case 'w':
      case 'x':
        colorIndex = 8;
        break;
      case 'y':
      case 'z':
        colorIndex = 9;
        break;
      default:
        colorIndex = 0;
    }
  }
  return colorIndex;
}

String convertToLocalTime(String jsonTime) {
  DateTime msgTime = DateTime.parse(jsonTime);
  var newTime = msgTime.toLocal().toIso8601String();
  // print("new time: " + newTime);
  return newTime;
}

String generateMessageId() {
  int length = 25;
  var r = Random();
  const prefix = '5d';
  const _chars =
      '1234567890AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  return prefix +
      List.generate(length, (index) => _chars[r.nextInt(_chars.length)]).join();
}

String escapeSpecial(String query) {
  return query.replaceAllMapped(RegExp(r'[.*+?^${}()|[\]\\]'), (x) {
    return "\\${x[0]}";
  });
}
