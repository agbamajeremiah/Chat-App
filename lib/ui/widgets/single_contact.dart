import 'dart:io';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/constant/route_names.dart';
import 'package:MSG/models/chat.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleContact extends StatelessWidget {
  final String number;
  final String name;
  final bool searching;
  final String matchString;
  final bool registered;
  //bool registered = false;
  const SingleContact(
      {this.number,
      this.name,
      this.searching,
      this.matchString,
      this.registered});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: InkWell(
        onTap: () async {
          if (registered == true) {
            Navigator.pushNamed(
              context,
              ChatViewRoute,
              arguments: {
                'chat': Chat(id: null, displayName: name, memberPhone: number),
                'fromContact': true
              },
            );
          } else {
            final AuthenticationSerivice _authenticationSerivice =
                locator<AuthenticationSerivice>();
            final _profileName = _authenticationSerivice.profileName;
            if (number != null && _profileName != null) {
              if (Platform.isAndroid) {
                final _smsUrl =
                    "sms: $number?body=$_profileName%20is%20inviting%20you%20to%20to%20join%20MSG.%20Download%20app%20https://www.google.com/";
                if (await canLaunch(_smsUrl)) {
                  await launch(_smsUrl);
                }
              } else if (Platform.isIOS) {
                final _smsUrl =
                    "sms: $number?body=$_profileName%20is%20inviting%20you%20to%20to%20join%20MSG.%20Download%20app%20https://www.google.com/";
                if (await canLaunch(_smsUrl)) {
                  await launch(_smsUrl);
                }
              }
            }
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                color: themeData.accentColor,
              ),
            ),
            horizontalSpaceSmall,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    searching
                        ? RichText(
                            text: TextSpan(
                              style: themeData.textTheme.bodyText1.copyWith(
                                fontSize: 16,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: name.substring(0, matchString.length),
                                    style: themeData.textTheme.bodyText1
                                        .copyWith(color: AppColors.unreadText)),
                                TextSpan(
                                    text: name.substring(matchString.length),
                                    style: themeData.textTheme.bodyText1),
                              ],
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                                text: name,
                                style: themeData.textTheme.bodyText1),
                          ),
                    Text(
                      number,
                      style: themeData.textTheme.bodyText1
                          .copyWith(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
