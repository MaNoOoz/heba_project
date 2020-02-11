/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';
import 'package:google_fonts_arabic/fonts.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'هبة',
          style: TextStyle(
            color: Colors.black,
            fontFamily: ArabicFonts.Cairo,
            fontSize: 35.0,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Activity',
        ),
      ),
    );
  }
}
