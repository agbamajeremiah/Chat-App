import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/utils/util_functions.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String sender, text;
  final bool isMe;
  final String messageTime;
  final String status;

  MessageBubble(
      {this.sender, this.text, this.isMe, this.messageTime, this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: isMe
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          convertToTime(messageTime),
                          style:
                              textStyle.copyWith(color: AppColors.textColor2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: status == 'SENT'
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: 17,
                                  ),
                                  Icon(
                                    Icons.check,
                                    color: Colors.lightBlueAccent,
                                    size: 17,
                                  ),
                                ],
                              )
                            : status == 'RECEIVED'
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.lightBlueAccent,
                                        size: 17,
                                      ),
                                      Icon(
                                        Icons.check,
                                        color: Colors.lightBlueAccent,
                                        size: 17,
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      SizedBox(
                                        width: 17,
                                      ),
                                      Icon(
                                        Icons.sync,
                                        color: Colors.lightBlueAccent,
                                        size: 17,
                                      )
                                    ],
                                  ),
                      ),
                    ],
                  ),
                ),
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: Colors.lightBlueAccent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: SizedBox(
                            width: 20,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          convertToTime(messageTime),
                          style:
                              textStyle.copyWith(color: AppColors.textColor2),
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20),
                    child: Text(
                      text,
                      style:
                          TextStyle(fontSize: 16, color: AppColors.textColor),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
