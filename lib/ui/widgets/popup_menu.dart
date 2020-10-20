import 'package:MSG/constant/route_names.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
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
    return PopupMenuButton<String>(
        //padding: EdgeInsets.symmetric(horizontal: 5),
        icon: Icon(Icons.more_vert, color: AppColors.textColor),
        onSelected: (option) {
          _switchMenuScreen(option, context);
        },
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem(
              child: Text("Profile", style: menuTextStyle),
              value: "profile",
            ),
            PopupMenuDivider(
              height: 2,
            ),
            PopupMenuItem(
              child: Text("Settings", style: menuTextStyle),
              value: "settings",
            ),
            PopupMenuDivider(
              height: 2,
            ),
            PopupMenuItem(
              child: Text("Help", style: menuTextStyle),
              value: "help",
            ),
          ];
        });
  }
}
//enum MenuOption { Profile, Settings, Help }
