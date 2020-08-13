import 'package:MSG/constant/route_names.dart';
import 'package:MSG/models/contacts.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class SearchContact extends StatelessWidget {
  final String contactName;
  final String number;
  final String matchString;
  SearchContact({this.contactName, this.number, this.matchString});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, ChatViewRoute,
              arguments: MyContact(fullName: contactName, phoneNumber: number));
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
                child: Container(
              //padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: textStyle.copyWith(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: contactName.substring(0, matchString.length),
                            style: TextStyle(color: AppColors.unreadText)),
                        TextSpan(
                            text: contactName.substring(matchString.length),
                            style: TextStyle(color: AppColors.textColor)),
                      ],
                    ),
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
            ))
          ],
        ),
      ),
    );
  }
}
