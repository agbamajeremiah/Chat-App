import 'package:MSG/utils/util_functions.dart';
import 'package:bubble/bubble.dart';
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
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
      child: isMe
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Bubble(
                  margin: BubbleEdges.only(top: 10),
                  nip: BubbleNip.rightTop,
                  color: themeData.primaryColor,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    constraints: BoxConstraints(
                        minWidth: 75.0,
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Text(
                      text,
                      style: themeData.textTheme.bodyText2
                          .copyWith(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        convertToTime(messageTime),
                        style: themeData.textTheme.bodyText1
                            .copyWith(fontSize: 13),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
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
                Bubble(
                  elevation: 1.0,
                  margin: BubbleEdges.only(top: 10),
                  nip: BubbleNip.leftTop,
                  color: themeData.backgroundColor,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    constraints: BoxConstraints(
                        minWidth: 75.0,
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Text(
                      text,
                      style:
                          themeData.textTheme.bodyText1.copyWith(fontSize: 16),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 35),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, bottom: 1, top: 2),
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
