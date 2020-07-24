import 'dart:math';

import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {
  final String name, message;
  final bool isRead;
  static int unreadMessages = 1;

  const MessageContainer({
    @required this.name,
    @required this.message,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    List colors = [
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.blue,
      Colors.pinkAccent,
      Colors.purple
    ];
    Random random = new Random();
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
                name[0],
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
                    "$message",
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
                    "8:39 AM",
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
