import 'package:MSG/constant/route_names.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchContact extends StatelessWidget {
  final String contactName;
  final String number;
  final String matchString;
  SearchContact({this.contactName, this.number, this.matchString});
  String firstPos = "";
  String middlePos = "";
  String finalPos = "";
  //final startBoldIndex = contactName.indexOf();
  //final endBoldIndex = str.indexOf(end, startIndex + start.length);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, ChatViewRoute);
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
                  Text(
                    contactName,
                    style: textStyle.copyWith(
                        color: AppColors.textColor,
                        fontSize: 17,
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
            ))
          ],
        ),
      ),
    );
  }
}
