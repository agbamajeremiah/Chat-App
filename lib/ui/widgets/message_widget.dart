import 'dart:math';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:MSG/utils/util_functions.dart';
import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {
  final String name;
  final bool isRead;
  final String lastMessage;
  static int unreadMessages = 1;
  final String msgTime;

  const MessageContainer({
    @required this.lastMessage,
    @required this.name,
    @required this.msgTime,
    this.isRead = false,
  });

  static final List colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
    Colors.pinkAccent,
    Colors.purple
  ];
  static final Random random = new Random();

  @override
  Widget build(BuildContext context) {
    int index = random.nextInt(colors.length);
    return Container(
      padding: EdgeInsets.only(left: 10, right: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: colors[index],
            child: Center(
              child: Text(
                name != null ? name[0] : '',
                style: textStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          horizontalSpaceSmall,
          Expanded(
            child: Container(
              //padding: EdgeInsets.only(top: 5),
              // height: isRead ? 40 : 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$name",
                    style: textStyle.copyWith(
                        color:
                            isRead ? AppColors.textColor : AppColors.unreadText,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "$lastMessage",
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                    style: textStyle.copyWith(
                        color: AppColors.textColor2,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            height: 45,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Center(
                  child: isRead
                      ? null
                      : CircleAvatar(
                          radius: 8,
                          backgroundColor: AppColors.unreadText,
                          child: Center(
                            child: Text(
                              unreadMessages.toString(),
                              style: textStyle.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    convertToTime(msgTime),
                    style: textStyle.copyWith(color: AppColors.textColor2),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
