/*
 * Copyright (c) 2020.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';
import 'package:google_fonts_arabic/fonts.dart';

import '../Assets.dart';

ThemeData buildThemeData() {
  final baseTheme = ThemeData(fontFamily: ArabicFonts.Tajawal);

  return baseTheme.copyWith(
    primaryColor: CustomColors.primaryColor,
    scaffoldBackgroundColor: CustomColors.scaffoldColor,
    appBarTheme: AppBarTheme(
      color: CustomColors.appBarColor,
      elevation: 0,
    ),
  );
}
