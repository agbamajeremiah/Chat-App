import 'package:MSG/constant/route_names.dart';
import 'package:flutter/material.dart';

class MyPopupMenu extends StatefulWidget {
  @override
  _MyPopupMenuState createState() => _MyPopupMenuState();
}

class _MyPopupMenuState extends State<MyPopupMenu> {
  void _switchMenuScreen(String option, BuildContext cxt) {
    switch (option) {
      case "profile":
        Navigator.pushNamed(context, ProfileViewRoute);
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
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return PopupMenuButton<String>(
        color: themeData.backgroundColor,

        //padding: EdgeInsets.symmetric(horizontal: 5),
        icon: Icon(Icons.more_vert),
        onSelected: (option) {
          _switchMenuScreen(option, context);
        },
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem(
              child: Text("Profile"),
              value: "profile",
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
              value: "help",
              textStyle: themeData.textTheme.bodyText1.copyWith(fontSize: 13.5),
            ),
          ];
        });
  }
}
//enum MenuOption { Profile, Settings, Help }
