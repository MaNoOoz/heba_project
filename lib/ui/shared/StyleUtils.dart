import 'package:flutter/material.dart';

import 'StringUtils.dart';
import 'UtilsImporter.dart';

class StyleUtils {
  /// ========================================================================================================
  InputDecoration textFieldDecorationSquer({String hint, String lable}) {
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
      icon: icon,
      contentPadding: EdgeInsets.all(16),
      hintText: hint,
      labelText: lable,
      hintStyle: TextStyle(color: Colors.grey),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(26)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(26)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(26)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.all(Radius.circular(26)),
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
        fontFamily: UtilsImporter().stringUtils.cairo,
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

  TextStyle AppTextStyle() {
    return TextStyle(
        color: Colors.black45,
        fontFamily: StringUtils().cairo,
        letterSpacing: 3.0,
        fontWeight: FontWeight.bold,
        fontSize: 28);
  }
}
