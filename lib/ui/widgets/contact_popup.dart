import 'package:MSG/constant/route_names.dart';
import 'package:flutter/material.dart';

class ContactPopupMenu extends StatefulWidget {
  final Function synContact;
  ContactPopupMenu({Key key, @required this.synContact});
  @override
  _ContactPopupMenuState createState() => _ContactPopupMenuState();
}

class _ContactPopupMenuState extends State<ContactPopupMenu> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return PopupMenuButton<String>(
        color: themeData.backgroundColor,
        icon: Icon(
          Icons.more_vert,
        ),
        onSelected: (option) {
          switch (option) {
            case "refresh":
              print("refresh contacts");
              widget.synContact();
              break;
            case "settings":
              print("Switch to Settings");
              Navigator.pushNamed(context, SettingsViewRoute);
              break;
            case "help":
              print("Switch to Help Screen");
              break;
            default:
          }
        },
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem(
              child: Text("Refresh"),
              value: "refresh",
              textStyle: themeData.textTheme.bodyText1.copyWith(fontSize: 13.5),
            ),
            PopupMenuDivider(
              height: 2,
            ),
            PopupMenuItem(
              child: Text("Settings"),
              value: "settings",
              textStyle: themeData.textTheme.bodyText1.copyWith(fontSize: 13.5),
            ),
            PopupMenuDivider(
              height: 2,
            ),
            PopupMenuItem(
              child: Text("Help"),
              textStyle: themeData.textTheme.bodyText1.copyWith(fontSize: 13.5),
              value: "help",
            ),
          ];
        });
  }
}
