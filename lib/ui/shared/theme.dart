import 'package:MSG/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: Colors.white,
  primaryColor: AppColors.primaryColor,
  accentColor: AppColors.accentColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'Ubuntu',
  appBarTheme: AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(
      color: AppColors.primaryColor,
    ),
    elevation: 2.0,
  ),
  iconTheme: IconThemeData(color: AppColors.primaryColor),
  inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(fontSize: 15, color: Colors.black)),
  buttonTheme:
      ButtonThemeData(buttonColor: Colors.blue, focusColor: Colors.amber),
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: Colors.blue),
  textTheme: TextTheme(
    headline6: TextStyle(
      fontFamily: 'Ubuntu',
      color: AppColors.textColor,
      fontSize: 25,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
    ),
    subtitle1: TextStyle(
        color: Colors.white,
        fontFamily: 'Ubuntu',
        fontSize: 15,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400),
    subtitle2: TextStyle(
        color: AppColors.textColor,
        fontFamily: 'Ubuntu',
        fontSize: 15,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400),
    bodyText1: TextStyle(
        color: AppColors.textColor,
        fontFamily: 'Ubuntu',
        fontSize: 15,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400),
    bodyText2: TextStyle(
        fontFamily: 'Ubuntu',
        fontSize: 15,
        color: Colors.white,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400),
  ),
  dividerColor: Colors.grey,
);
ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: AppColors.darkBgColor,
    scaffoldBackgroundColor: AppColors.darkBgColor,
    primaryColor: AppColors.darkPrimaryColor,
    accentColor: AppColors.accentColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Ubuntu',
    appBarTheme: AppBarTheme(
      color: AppColors.darkBgColor,
      iconTheme: IconThemeData(color: AppColors.darkTextColor),
      elevation: 2.0,
    ),
    iconTheme: IconThemeData(color: AppColors.darkTextColor),
    inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 15, color: AppColors.darkTextColor)),
    buttonTheme:
        ButtonThemeData(buttonColor: Colors.grey, focusColor: Colors.amber),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey, foregroundColor: AppColors.darkTextColor),
    textTheme: TextTheme(
      headline6: TextStyle(
          color: AppColors.darkTextColor,
          fontFamily: 'Ubuntu',
          fontSize: 25,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500),
      subtitle1: TextStyle(
          color: AppColors.darkTextColor,
          fontFamily: 'Ubuntu',
          fontSize: 15,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400),
      subtitle2: TextStyle(
          color: AppColors.greyColor,
          fontFamily: 'Ubuntu',
          fontSize: 15,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400),
      bodyText1: TextStyle(
          color: AppColors.darkTextColor,
          fontFamily: 'Ubuntu',
          fontSize: 15,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400),
      bodyText2: TextStyle(
          fontFamily: 'Ubuntu',
          fontSize: 15,
          color: AppColors.darkBgColor,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400),
    ),
    dividerColor: AppColors.darkDividerColor);

class ThemeNotifier extends ChangeNotifier {
  final String themeKey = 'theme';
  SharedPreferences _prefs;
  bool _darkTheme;
  bool get darkTheme => _darkTheme;
  ThemeNotifier() {
    // _darkTheme = true;
    _getThemeFromPrefs();
  }

  _initPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  _getThemeFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(themeKey) ?? false;
    notifyListeners();
  }

  _saveThemeToPrefs() async {
    await _initPrefs();
    await _prefs.setBool(themeKey, _darkTheme);
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    print(_darkTheme.toString());
    _saveThemeToPrefs();
    notifyListeners();
  }
}
