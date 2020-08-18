import 'package:MSG/constant/route_names.dart';
import 'package:MSG/models/chat.dart';

import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class SingleContact extends StatelessWidget {
  final String number;
  final String name;
  const SingleContact({this.number, this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, ChatViewRoute,
              arguments:
                  Chat(id: null, displayName: name, memberPhone: number));
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
                  Text(
                    name,
                    style: textStyle.copyWith(
                        color: AppColors.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
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
