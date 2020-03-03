/*
 * Copyright (c) 2020.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
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
                'No',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
            OutlineButton(
              onPressed: () {
                Navigator.of(context).pop(DialogAction.yes);
              },
              child: const Text(
                'Yes',
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
