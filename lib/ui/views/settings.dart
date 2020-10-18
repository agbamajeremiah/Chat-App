import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:MSG/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool darkTheme = false;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: AppColors.textColor,
            ),
            backgroundColor: Colors.white,
            title: Text(
              "Settings",
              style:
                  textStyle.copyWith(color: AppColors.textColor, fontSize: 20),
            ),
            elevation: 1.0,
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 25),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: colors[5],
                        child: Center(
                          child: Text(
                            'J',
                            style: textStyle.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    horizontalSpaceTiny,
                    Expanded(
                        child: Text(
                      'Jerry Agbama',
                      style: textStyle.copyWith(
                        fontSize: 23,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.075,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 75),
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dark/Light Theme',
                            style: textStyle.copyWith(
                              fontSize: 20,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            // child: FlutterSwitch(
                            //   valueFontSize: 15.0,
                            //   toggleSize: 45.0,
                            //   value: status,
                            //   borderRadius: 30.0,
                            //   showOnOff: true,
                            //   onToggle: (val) {
                            //     setState(() {
                            //       status = val;
                            //     });
                            //   },
                            // ),
                            child: Switch(
                                activeColor: Colors.black,
                                value: darkTheme,
                                onChanged: (value) {
                                  setState(() => darkTheme = !darkTheme);
                                  print(darkTheme);
                                }),
                          )
                        ],
                      ),
                    ),
                    verticalSpace(50),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hide Status',
                            style: textStyle.copyWith(
                              fontSize: 20,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            // child: FlutterSwitch(
                            //   valueFontSize: 15.0,
                            //   toggleSize: 45.0,
                            //   value: status,
                            //   borderRadius: 30.0,
                            //   showOnOff: true,
                            //   onToggle: (val) {
                            //     setState(() {
                            //       status = val;
                            //     });
                            //   },
                            // ),
                            child: Switch(
                                activeColor: AppColors.splashBlue,
                                value: hideStatus,
                                onChanged: (value) {
                                  setState(() => hideStatus = !hideStatus);
                                  print(darkTheme);
                                }),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
