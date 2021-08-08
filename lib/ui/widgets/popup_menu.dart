import 'package:MSG/constant/route_names.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class MyPopupMenu extends StatefulWidget {
  @override
  _MyPopupMenuState createState() => _MyPopupMenuState();
}

class _MyPopupMenuState extends State<MyPopupMenu> {
  void _openHelpDialog(BuildContext context) {
    final themeData = Theme.of(context);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                constraints: BoxConstraints(maxHeight: 85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "MSG Messenger",
                        style: themeData.textTheme.subtitle2
                            .copyWith(fontSize: 22.5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                        " Version: 1.1.2",
                        style: themeData.textTheme.subtitle2,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10),
                    //   child: Text(
                    //     " Developed by 525System",
                    //     style: themeData.textTheme.subtitle2,
                    //   ),
                    // ),
                  ],
                ),
              ),
              actions: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("CLOSE",  style: themeData.textTheme.subtitle2.copyWith(fontSize: 16, color: AppColors.primaryColor),)
                  ),
                )
              ],
            ));
  }

  void _switchMenuScreen(String option, BuildContext cxt) {
    switch (option) {
      case "profile":
        Navigator.pushNamed(context, Routes.profileViewRoute);
        break;
      case "settings":
        print("Switch to Settings");
        Navigator.pushNamed(context, Routes.settingsViewRoute);
        break;
      case "info":
        _openHelpDialog(context);
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
        icon: Icon(Icons.more_vert, color: Colors.white,),
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
              child: Text("Info"),
              value: "info",
              textStyle: themeData.textTheme.bodyText1.copyWith(fontSize: 13.5),
            ),
          ];
        });
  }
}