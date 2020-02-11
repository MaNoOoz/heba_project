/*
 * Copyright (c) 2020.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[100],
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
