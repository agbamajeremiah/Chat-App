import 'dart:math';

import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    @required this.name,
    @required this.message,
    this.isRead = false,
  });

  final String name, message;
  final bool isRead;

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
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
              // height: isRead ? 40 : 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$name",
                    style: textStyle.copyWith(
                        color: AppColors.textColor,
                        fontSize: 20,
                        fontWeight: isRead ? FontWeight.w100 : FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Text(
                      "$message",
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: isRead ? 1 : 3,
                      style: textStyle.copyWith(
                          color: AppColors.textColor2,
                          fontWeight:
                              isRead ? FontWeight.normal : FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "8:39 AM",
            style: textStyle.copyWith(color: AppColors.textColor2),
          )
        ],
      ),
    );
  }
}
