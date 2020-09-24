/*
 * Copyright (c) 2020.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';
import 'package:heba_project/ui/shared/utili/Constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

enum DialogAction { yes, abort }

class CustomDialog1 {
  static Future<DialogAction> addNewHebaDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    var showSpinner = false;

    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            OutlineButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.abort),
              child: const Text(
                'لا إصبر',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
            OutlineButton(
              onPressed: () async {
                Navigator.of(context).pop(DialogAction.yes);
              },
              child: const Text(
                'أكييييد',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
            ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Text(''),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }
}

class CustomDialog2 extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  CustomDialog2({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        //...bottom card part,
        Container(
          padding: EdgeInsets.only(
            top: avatarRadius + padding,
            bottom: padding,
            left: padding,
            right: padding,
          ),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
        //...top circlular image part,
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: avatarRadius,
          ),
        ),
      ],
    );
  }
}
