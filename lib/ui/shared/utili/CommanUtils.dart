/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

Function PRINT(String funName) {
  print("Called ${funName}");
}

class CommanUtils {
  /// checkConnection -------------------------------------------------------------------------
  static Future<bool> checkConnection() async {
    ConnectivityResult connectivityResult =
        await (new Connectivity().checkConnectivity());
    await Future.delayed(Duration(seconds: 2))
        .catchError((onError) => {print(onError)});
    debugPrint(connectivityResult.toString());

    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  static void showAlertForConfirmAddData(
      BuildContext context, String text, bool function) {
    var alert = new AlertDialog(
      content: Container(
        child: Row(
          children: <Widget>[Text(text)],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              function;
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.blue),
            )),
        FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  static void showAlert(BuildContext context, String text) {
    var alert = new AlertDialog(
      content: Container(
        child: Row(
          children: <Widget>[Text(text)],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  /// showSnackbar ---------------------------------------------------------------------
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

  /// showToast -------------------------------------------------------------------------
  void showToast(String message, BuildContext context) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  /// Validation ------------------------------------------------------------------------
  bool checkEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  String validatePassword(String value) {
    if (value.length < 6) {
      return "Must be at least 6 characters";
    } else {
      return "true";
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

  String validateNumber(String value) {
    if (value.length < 10) {
      return 'أدخل رقم صحيح';
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
}
