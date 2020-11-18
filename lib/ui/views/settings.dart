import 'package:MSG/ui/shared/theme.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:MSG/utils/util_functions.dart';
import 'package:MSG/viewmodels/settings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool hideStatus = false;
  static final List colors = [
    Colors.amber,
    Colors.cyan,
    Colors.orange,
    Colors.indigoAccent,
    Colors.teal,
    Colors.green,
    Colors.yellow,
    Colors.blue,
    Colors.pinkAccent,
    Colors.purple,
  ];
  static final List darkColors = [
    Colors.grey[500],
    Colors.grey[600],
    Colors.grey[700],
    Colors.grey[800],
    Colors.grey[900],
    Colors.grey[500],
    Colors.grey[600],
    Colors.grey[700],
    Colors.grey[800],
    Colors.grey[900],
  ];

  @override
  Widget build(BuildContext context) {
    print("page Rebuilt");
    final themeData = Theme.of(context);
    return ViewModelBuilder<SettingsViewModel>.reactive(
        viewModelBuilder: () => SettingsViewModel(),
        builder: (context, model, snapshot) {
          print("page Rebuilt");

          int index = getColorMatch(
              model.accountName != null ? model.accountName[0] : '');
          return Consumer<ThemeNotifier>(builder: (context, notifier, child) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor:
                    notifier.darkTheme ? AppColors.darkBgColor : Colors.white,
                statusBarBrightness:
                    notifier.darkTheme ? Brightness.dark : Brightness.light,
                statusBarIconBrightness:
                    notifier.darkTheme ? Brightness.light : Brightness.dark,
                systemNavigationBarColor:
                    notifier.darkTheme ? Colors.black : Colors.white,
                systemNavigationBarIconBrightness:
                    notifier.darkTheme ? Brightness.light : Brightness.dark,
              ),
              child: SafeArea(
                child: Scaffold(
                    appBar: AppBar(
                      title: Text(
                        "Settings",
                        style: themeData.textTheme.headline6
                            .copyWith(fontSize: 22.5),
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        model.doubleIncrementCount();
                        print(model.count);
                      },
                      child: Icon(Icons.add),
                    ),
                    body: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 25),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Consumer<ThemeNotifier>(
                                    builder: (context, notifier, child) {
                                  return CircleAvatar(
                                    radius: 22,
                                    backgroundColor: notifier.darkTheme == true
                                        ? darkColors[index]
                                        : colors[index],
                                    child: Center(
                                      child: Text(
                                        model.accountName[0],
                                        style: themeData.textTheme.bodyText2
                                            .copyWith(
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              horizontalSpaceTiny,
                              Expanded(
                                  child: Text(
                                model.accountName,
                                style: themeData.textTheme.bodyText1.copyWith(
                                    fontSize: 23, fontWeight: FontWeight.w400),
                              ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.075,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: themeData.backgroundColor,
                            // shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: themeData.accentColor.withOpacity(0.5),
                                spreadRadius: 0.6,
                                blurRadius: 1,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 75),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: themeData.backgroundColor,
                                  // shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeData.accentColor
                                          .withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Dark/Light Theme',
                                      style: themeData.textTheme.bodyText1
                                          .copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Consumer<ThemeNotifier>(
                                          builder: (context, notifier, child) {
                                        return Switch(
                                            activeColor:
                                                AppColors.darkTextColor,
                                            value: notifier.darkTheme,
                                            onChanged: (value) {
                                              notifier.toggleTheme();
                                            });
                                      }),
                                    )
                                  ],
                                ),
                              ),
                              verticalSpace(50),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: themeData.backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeData.accentColor
                                          .withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Hide Status',
                                      style: themeData.textTheme.bodyText1
                                          .copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Switch(
                                          activeColor: AppColors.splashBlue,
                                          value: hideStatus,
                                          onChanged: (value) {
                                            setState(
                                                () => hideStatus = !hideStatus);
                                            print(darkTheme);
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          color: Colors.black,
                          child: Text("Counter: ${model.count}"),
                        )
                      ],
                    )),
              ),
            );
          });
        });
  }
}
