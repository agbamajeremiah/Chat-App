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
    final themeData = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: isMe
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Material(
                  elevation: 0.0,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  color: themeData.primaryColor,
                  child: Column(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            minWidth: 100.0,
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 15, right: 15),
                        child: Text(
                          text,
                          style: themeData.textTheme.bodyText2
                              .copyWith(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      // Container(
                      //   constraints: BoxConstraints(
                      //       minWidth: 100,
                      //       maxWidth: MediaQuery.of(context).size.width * 0.6),
                      //   child: Align(
                      //     alignment: Alignment.bottomRight,
                      //     child: Padding(
                      //       padding:
                      //           const EdgeInsets.only(right: 10, bottom: 5),
                      //       child: Text(
                      //         convertToTime(messageTime),
                      //         style: textStyle.copyWith(color: Colors.white),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Text(
                          convertToTime(messageTime),
                          style: themeData.textTheme.bodyText1
                              .copyWith(fontSize: 13),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                        ),
                        child: status == 'SENT'
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Icon(
                                    Icons.check,
                                    color: themeData.primaryColor,
                                    size: 15,
                                  ),
                                ],
                              )
                            : status == 'READ'
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: themeData.primaryColor,
                                        size: 15,
                                      ),
                                      Icon(
                                        Icons.check,
                                        color: themeData.primaryColor,
                                        size: 15,
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        Icons.sync,
                                        color: themeData.primaryColor,
                                        size: 15,
                                      )
                                    ],
                                  ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Material(
                  elevation: 1.0,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: themeData.backgroundColor,
                  child: Container(
                    constraints: BoxConstraints(
                        minWidth: 100.0,
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    padding: const EdgeInsets.symmetric(
                        vertical: 7.5, horizontal: 15),
                    child: Text(text,
                        style: themeData.textTheme.bodyText1
                            .copyWith(fontSize: 16)),
                  ),
                ),
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
                        padding:
                            const EdgeInsets.only(left: 5, right: 5, bottom: 1),
                        child: Text(
                          convertToTime(messageTime),
                          style: themeData.textTheme.bodyText1
                              .copyWith(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
