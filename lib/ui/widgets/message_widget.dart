import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:MSG/utils/util_functions.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';

class MessageContainer extends StatelessWidget {
  final String searchquery;
  final String name;
  final String lastMessage;
  final int unreadMessages;
  final String msgTime;

  const MessageContainer({
    @required this.lastMessage,
    @required this.name,
    @required this.msgTime,
    @required this.searchquery,
    @required this.unreadMessages,
  });

  static final List colors = [
    Colors.amber,
    Colors.cyan,
    Colors.orange,
    Colors.indigoAccent,
    Colors.teal,
    Colors.green,
    Colors.yellow,
    Colors.blue,
    Colors.pinkAccent,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    int index = getColorMatch(name != null ? name[0] : '');
    bool isNotRead = unreadMessages > 0 ? true : false;
    // final isNotRead = true;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: colors[index],
            child: Center(
              child: Text(
                name != null
                    ? name[0] == "+" || name[0] == '0' ? '0' : name[0]
                    : '0',
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
              padding: EdgeInsets.symmetric(vertical: 5),
              child: searchquery.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "$name",
                                style: textStyle.copyWith(
                                    color: isNotRead
                                        ? AppColors.unreadText
                                        : AppColors.textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 1,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "$lastMessage",
                                style: textStyle.copyWith(
                                    color: AppColors.textColor2,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DynamicTextHighlighting(
                          text: name,
                          highlights: [searchquery],
                          caseSensitive: false,
                          style: textStyle.copyWith(
                              color: isNotRead
                                  ? AppColors.unreadText
                                  : AppColors.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                        // RichText(
                        //   text: TextSpan(
                        //     children: <TextSpan>[
                        //       TextSpan(
                        //         text: "$name",
                        //         style: textStyle.copyWith(
                        //             color: isNotRead
                        //                 ? AppColors.unreadText
                        //                 : AppColors.textColor,
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.w300),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 1,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "$lastMessage",
                                style: textStyle.copyWith(
                                    color: AppColors.textColor2,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          horizontalSpaceTiny,
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Center(
                    child: isNotRead
                        ? SizedBox(
                            height: 14,
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: AppColors.unreadText,
                              child: Center(
                                child: Text(
                                  unreadMessages.toString(),
                                  style: textStyle.copyWith(
                                      color: Colors.white, fontSize: 12.5),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(height: 14),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    getFullTime(msgTime),
                    style: textStyle.copyWith(
                        color: AppColors.textColor2,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w300),
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
