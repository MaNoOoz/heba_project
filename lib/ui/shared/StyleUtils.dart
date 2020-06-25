/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';
import 'package:google_fonts_arabic/fonts.dart';

import 'StringUtils.dart';
import 'UtilsImporter.dart';

const bold = TextStyle(fontWeight: FontWeight.bold);
const link = TextStyle(color: Color(0xFF3F729B));
const headerStyle = TextStyle(fontSize: 35, fontWeight: FontWeight.w900);
const subHeaderStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500);

class StyleUtils {
  /// ========================================================================================================
  InputDecoration textFieldDecorationSquere({String hint, String lable}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(16),
      prefixIcon: Icon(Icons.card_giftcard),
      hintText: hint,
      labelText: lable,
      hintStyle: TextStyle(color: Colors.grey),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.all(Radius.circular(26)),
      ),
    );
  }

  /// ========================================================================================================
  InputDecoration textFieldDecorationCircle(
      {String hint, String lable, Icon icon}) {
    return InputDecoration(
//      prefixIcon: icon,
      icon: icon,
//      suffixIcon: icon,
      contentPadding: EdgeInsets.all(10),
      hintText: hint,
      labelText: lable,
      hintStyle: TextStyle(color: Colors.grey),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }

  /// ========================================================================================================
  TextStyle loginTextFieldStyle() {
    return TextStyle(
        color: Colors.black, fontFamily: StringUtils().cairo, fontSize: 14);
  }

  /// ========================================================================================================
  TextStyle segmanetTextStyle() {
    return TextStyle(
        fontFamily: UtilsImporter().uStringUtils.cairo,
        color: Colors.black87,
        fontWeight: FontWeight.w700,
        fontSize: 16);
  }

  /// ========================================================================================================
  TextStyle homeTextStyle() {
    return TextStyle(
        color: Colors.black, fontFamily: StringUtils().cairo, fontSize: 28);
  }

  /// ========================================================================================================
  TextStyle dialoagTextStyle() {
    return TextStyle(
        color: Colors.amber,
        fontFamily: StringUtils().cairo,
        letterSpacing: 3.0,
        fontWeight: FontWeight.bold,
        fontSize: 28);
  }

  /// ========================================================================================================

  ThemeData themeData = ThemeData(
    primaryColor: Colors.blue,
    accentColor: Colors.blueAccent[500],
    fontFamily: ArabicFonts.Tajawal,
    textTheme: TextTheme(
        display1: TextStyle(fontSize: 14, fontFamily: ArabicFonts.Tajawal)),
  );

/// ========================================================================================================

/// ========================================================================================================

}
