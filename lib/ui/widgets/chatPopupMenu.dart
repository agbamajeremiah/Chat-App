import 'package:MSG/constant/route_names.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class ChatPopupMenu extends StatefulWidget {
  final Function favFunction;
  final bool favourite;
  ChatPopupMenu( this.favourite, this.favFunction );
  @override
  _ChatPopupMenuState createState() => _ChatPopupMenuState();
}

class _ChatPopupMenuState extends State<ChatPopupMenu> {
  void _switchMenuScreen(String option, BuildContext cxt) {
    switch (option) {
      case "favourite":
        print('add to favourite');
        if (widget.favourite == false) {
          widget.favFunction(1);
        } else {
          widget.favFunction(0);
        }
        break;
      case "search":
        print("search");
        // Navigator.pushNamed(context, SettingsViewRoute);
        break;
      case "settings":
        print("Switch to Settings");
        Navigator.pushNamed(context, Routes.settingsViewRoute);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return PopupMenuButton<String>(
        color: AppColors.bgGrey,
        padding: EdgeInsets.all(5.0),
        icon: Icon(
          Icons.more_vert,
          color: AppColors.primaryColor,
        ),
        onSelected: (option) {
          _switchMenuScreen(option, context);
        },
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem(
              child:  !widget.favourite ? Text("Add to favourite"): Text("Remove favourite") ,
              value: "favourite",
              textStyle: themeData.textTheme.bodyText1.copyWith(fontSize: 13.5),
            ),
            PopupMenuDivider(
              height: 2,
            ),
            PopupMenuItem(
              child: Text("Search"),
              value: "search",
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
          ];
        });
  }
}
