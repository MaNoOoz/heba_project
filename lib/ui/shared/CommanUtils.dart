/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

Function PRINT(String funName) {
  print("Called ${funName}");
}

class CommanUtils {
  void showSnackbar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: 3),
      ),
    );
  }

  static String generateImagePlaceHolderUrl(
      {int width = 200, int height = 80}) {
    return 'https://via.placeholder.com/${width}x${height}';
  }

  bool checkEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  bool validatePassword(String value) {
    if (value.length < 6) {
      return false;
    } else {
      return true;
    }
  }

  String validateName(String value) {
    if (value.length < 2) {
      return 'أدخل إسم صحيح';
    } else if (value.isEmpty) {
      return 'عدد الأحرف قليل ';
    } else {
      return null;
    }
  }

  String validateDesc(String value) {
    if (value.length < 2) {
      return 'أدخل وصف صحيح';
    } else {
      return null;
    }
  }

  String validateLocation(String value) {
    if (value.length < 2) {
      return 'أدخل موقع صحيح';
    } else {
      return null;
    }
  }

  bool validateMobile(String value) {
    String patttern = r'([+]?\d{1,2}[.-\s]?)?(\d{3}[.-]?){2}\d{4}';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  void showToast(String message, BuildContext context) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }
}
