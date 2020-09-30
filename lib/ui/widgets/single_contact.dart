import 'package:MSG/constant/route_names.dart';
import 'package:MSG/models/chat.dart';

import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class SingleContact extends StatelessWidget {
  final String number;
  final String name;
  final bool searching;
  final String matchString;
  //bool registered = false;
  const SingleContact(
      {this.number, this.name, this.searching, this.matchString});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            ChatViewRoute,
            arguments: {
              'chat': Chat(id: null, displayName: name, memberPhone: number),
              'fromContact': true
            },
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            horizontalSpaceSmall,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  searching
                      ? RichText(
                          text: TextSpan(
                            style: textStyle.copyWith(
                                fontSize: 16, fontWeight: FontWeight.normal),
                            children: <TextSpan>[
                              TextSpan(
                                  text: name.substring(0, matchString.length),
                                  style:
                                      TextStyle(color: AppColors.unreadText)),
                              TextSpan(
                                  text: name.substring(matchString.length),
                                  style: TextStyle(color: AppColors.textColor)),
                            ],
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            text: name,
                            style: textStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: AppColors.textColor),
                          ),
                        ),
                  // : Text(
                  //     name,
                  //     style: textStyle.copyWith(
                  //         color: AppColors.textColor,
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  Text(
                    number,
                    style: textStyle.copyWith(
                        color: AppColors.textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
