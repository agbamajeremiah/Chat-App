import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/shared_styles.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
            style: textStyle.copyWith(color: AppColors.textColor, fontSize: 20),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
