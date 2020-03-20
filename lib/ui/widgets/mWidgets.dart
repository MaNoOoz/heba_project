/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';

class mWidgets {
  Widget mAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: Center(
        child: IconButton(
            padding: EdgeInsets.only(left: 30.0),
            onPressed: () => print('Menu'),
            icon: Icon(Icons.menu),
            iconSize: 30.0,
            color: Colors.black45),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/appicon.png',
              width: 32,
              height: 32,
              fit: BoxFit.scaleDown,
              scale: 3.0,
            ),
          ),
          Text(
            'هبــة',
            style: TextStyle(
              fontSize: 32,
              color: Colors.black45,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black45,
          ),
          onPressed: () async {
//            FirestoreServiceAuth.logout();
//            Navigator.pushNamed(context, LoginScreen.id);

            print("message");
          },
        ),
      ],
    );
  }
}
