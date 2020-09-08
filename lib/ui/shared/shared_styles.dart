import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

// Box Decorations

BoxDecoration fieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: Colors.white,
    border: Border.all(color: AppColors.textColor, width: 2));

BoxDecoration disabledFieldDecortaion = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: Colors.transparent,
    border: Border.all(color: AppColors.textColor, width: 2));

BoxDecoration buttonDecoration =
    BoxDecoration(borderRadius: BorderRadius.circular(26));
// Field Variables

const double fieldHeight = 55;
const double smallFieldHeight = 40;
const double inputFieldBottomMargin = 30;
const double inputFieldSmallBottomMargin = 0;
const EdgeInsets fieldPadding = const EdgeInsets.symmetric(horizontal: 15);
const EdgeInsets largeFieldPadding =
    const EdgeInsets.symmetric(horizontal: 15, vertical: 15);

// Text Variables
final TextStyle buttonTitleTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 21,
  color: Colors.white,
));
final TextStyle buttonTitleTextStyleBlack = GoogleFonts.poppins(
    textStyle: TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 20,
  color: AppColors.textColor,
));

final TextStyle textStyle = TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: 13,
    color: Colors.white,
    fontStyle: FontStyle.normal);

final TextStyle menuTextStyle = GoogleFonts.poppins(
  textStyle: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  ),
);
const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
final TextStyle welcomeText = GoogleFonts.meieScript(
  textStyle: TextStyle(
    fontSize: 63,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
);
