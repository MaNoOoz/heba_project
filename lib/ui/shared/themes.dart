/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';
import 'package:google_fonts_arabic/fonts.dart';

import 'StringUtils.dart';

ThemeData themeData = ThemeData(
  primaryColor: Colors.blue,
  accentColor: Colors.blueAccent[500],
  fontFamily: ArabicFonts.Cairo,
  textTheme: TextTheme(
      display1: TextStyle(wordSpacing: 2, fontFamily: ArabicFonts.Cairo)),
);

TextStyle AppTextFontFamily() {
  return TextStyle(
      color: Colors.white, fontFamily: StringUtils().cairo, fontSize: 14);
}
