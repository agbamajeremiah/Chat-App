//
import 'package:intl/intl.dart';

String convertToTime(String stringTime) {
  return DateFormat.jm().format(DateTime.parse(stringTime));
}

String getFullTime(String stringTime) {
  var returnTime;
  DateTime curTime = DateTime.now();
  print(curTime);
  DateTime msgTime = DateTime.parse(stringTime);
  print(msgTime);
  int dayDiff = curTime.day - msgTime.day;
  print(dayDiff);
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
