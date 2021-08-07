import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/utils/util_functions.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Container(
      child: isMe
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.70),
                  child: Container(
                    child: Bubble(
                      margin: BubbleEdges.only(top: 5.0),
                      nip: BubbleNip.rightTop,
                      color: themeData.primaryColor,
                      child: Wrap(
                          runSpacing: 2.0,
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.end,
                          spacing: 10.0,
                          children: [
                            SelectableLinkify(
                              onOpen: (link) async {
                                if (await canLaunch(link.url)) {
                                  await launch(link.url);
                                } else {
                                  throw 'Could not launch $link';
                                }
                              },
                              text: text,
                              textAlign: TextAlign.left,
                              style: themeData.textTheme.bodyText2.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              linkStyle: themeData.textTheme.bodyText2.copyWith(
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                color: Colors.lightBlue,
                              ),
                              options: LinkifyOptions(humanize: false),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 7.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    convertToTime(messageTime),
                                    style: themeData.textTheme.bodyText2
                                        .copyWith(fontSize: 12.5),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 2.0, right: 2.0),
                                    child: status == 'SENT'
                                        ? Row(
                                            children: [
                                              SizedBox(width: 2),
                                              Icon(
                                                Icons.done,
                                                color:
                                                    themeData.backgroundColor,
                                                size: 12,
                                              ),
                                            ],
                                          )
                                        : status == 'DELIVERED'
                                            ? Row(
                                                children: [
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Icon(
                                                    Icons.done_all,
                                                    color: themeData
                                                        .backgroundColor,
                                                    size: 12,
                                                  )
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Icon(
                                                    Icons.sync,
                                                    color: themeData
                                                        .backgroundColor,
                                                    size: 12,
                                                  ),
                                                ],
                                              ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.70),
                  child: Bubble(
                    elevation: 1.0,
                    margin: BubbleEdges.only(top: 5),
                    nip: BubbleNip.leftTop,
                    color: AppColors.secondaryColor,
                    child: Wrap(
                        runSpacing: 2.0,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        spacing: 10.0,
                        children: [
                          SelectableLinkify(
                            text: text,
                            onOpen: (link) async {
                              if (await canLaunch(link.url)) {
                                await launch(link.url);
                              } else {
                                throw 'Could not launch $link';
                              }
                            },
                            style: themeData.textTheme.bodyText1
                                .copyWith(fontSize: 16),
                            linkStyle: themeData.textTheme.bodyText2.copyWith(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              color: Colors.lightBlue,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 7.5),
                            child: Text(
                              convertToTime(messageTime),
                              style: themeData.textTheme.bodyText1
                                  .copyWith(fontSize: 12.5),
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
    );
  }
}
