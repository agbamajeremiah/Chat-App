import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/theme.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:MSG/ui/widgets/search_text.dart';
import 'package:MSG/utils/util_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  static final List darkColors = [
    Colors.grey[900],
    Colors.grey[600],
    Colors.grey[700],
    Colors.grey[800],
    Colors.grey[900],
    Colors.grey[900],
    Colors.grey[600],
    Colors.grey[700],
    Colors.grey[800],
    Colors.grey[900],
  ];

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    int index = getColorMatch(name != null ? name[0] : '');
    bool isNotRead = unreadMessages > 0 ? true : false;
    // final isNotRead = true;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<ThemeNotifier>(builder: (context, notifier, child) {
            return CircleAvatar(
              radius: 22,
              backgroundColor: notifier.darkTheme == true
                  ? darkColors[index]
                  : colors[index],
              child: Center(
                child: Text(
                  name != null
                      ? name[0] == "+" || name[0] == '0'
                          ? '0'
                          : name[0]
                      : '0',
                  style: themeData.textTheme.subtitle1.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
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
                                style: themeData.textTheme.bodyText1.copyWith(
                                    color: isNotRead
                                        ? AppColors.unreadText
                                        : themeData.textTheme.bodyText1.color,
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
                                  style: themeData.textTheme.bodyText1.copyWith(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w300)),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HighlightedSearchText(
                          text: name,
                          highlights: [searchquery],
                          highlightColor: AppColors.primaryColor,
                          style: themeData.textTheme.bodyText1.copyWith(
                              color: isNotRead
                                  ? AppColors.unreadText
                                  : themeData.textTheme.bodyText1.color,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                        HighlightedSearchText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: lastMessage,
                            highlights: [searchquery],
                            highlightColor: AppColors.primaryColor,
                            style: themeData.textTheme.bodyText1.copyWith(
                                fontSize: 13.5, fontWeight: FontWeight.w300)),
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
                              radius: 7.5,
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
