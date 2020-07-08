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

BoxDecoration buttonDecoration = BoxDecoration(
    border: Border.all(
      // color: AppColors().background,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(26));
// Field Variables

const double fieldHeight = 55;
const double smallFieldHeight = 40;
const double inputFieldBottomMargin = 30;
const double inputFieldSmallBottomMargin = 0;
const EdgeInsets fieldPadding = const EdgeInsets.symmetric(horizontal: 15);
const EdgeInsets largeFieldPadding =
    const EdgeInsets.symmetric(horizontal: 15, vertical: 15);

// Text Variables
final TextStyle buttonTitleTextStyle = GoogleFonts.montserrat(
    textStyle: TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 21,
  color: AppColors.textColor,
));
final TextStyle buttonTitleTextStyleBlack = GoogleFonts.montserrat(
    textStyle: TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 20,
  color: AppColors.textColor,
));

final TextStyle textStyle = GoogleFonts.montserrat(
  textStyle: TextStyle(
    fontSize: 11,
    color: Colors.white,
  ),
);
