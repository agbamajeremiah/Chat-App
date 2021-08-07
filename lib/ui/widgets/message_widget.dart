import 'dart:io';

import 'package:MSG/constant/assets.dart';
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
  final String number;
  final String lastMessage;
  final int unreadMessages;
  final String msgTime;
  final String picturePath;

  const MessageContainer({
    @required this.lastMessage,
    @required this.number,
    @required this.name,
    @required this.msgTime,
    @required this.searchquery,
    @required this.unreadMessages,
    @required this.picturePath,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    bool isNotRead = unreadMessages > 0 ? true : false;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<ThemeNotifier>(builder: (context, notifier, child) {
            return CircleAvatar(
                radius: 24,
                backgroundImage: picturePath != null
                    ? FileImage(File(picturePath))
                    : AssetImage(AppAssets.profile_default_pics),
                backgroundColor: notifier.darkTheme == true
                    ? Colors.grey
                    : Colors.grey[400]);
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
                                text: name != null && name.isNotEmpty ? name : number,
                                style: themeData.textTheme.bodyText1.copyWith(
                                    color: isNotRead
                                        ? AppColors.unreadText
                                        : Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
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
                          highlightColor: AppColors.unreadText,
                          style: themeData.textTheme.bodyText1.copyWith(
                              color: isNotRead
                                  ? AppColors.unreadText
                                  : themeData.textTheme.bodyText1.color,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        HighlightedSearchText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: lastMessage,
                            highlights: [searchquery],
                            highlightColor: AppColors.unreadText,
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
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Center(
                    child: isNotRead
                        ? SizedBox(
                            height: 17.5,
                            child: CircleAvatar(
                              backgroundColor: AppColors.unreadText,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    unreadMessages.toString(),
                                    style: textStyle.copyWith(
                                        color: Colors.white, fontSize: 9.5),
                                  ),
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
                        fontSize: 12,
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
