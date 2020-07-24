import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:flutter/material.dart';

class MyPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        //padding: EdgeInsets.symmetric(horizontal: 5),
        icon: Icon(Icons.more_vert),
        onSelected: (option) {
          print(option);
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
