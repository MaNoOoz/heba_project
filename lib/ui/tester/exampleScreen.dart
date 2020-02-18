/*
 * Copyright (c) 2020.  Made With Love By Yaman Al-khateeb
 */

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts_arabic/fonts.dart';

class TestScreen extends StatefulWidget {
  @override
  StateTestScreen createState() {
    return StateTestScreen();
  }
}

class StateTestScreen extends State<TestScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

//  todo /// 1- Create animation controller
//  todo /// 2- Initialize  animation controller in initState
//  todo /// 3- Injecting behavior  SingleTickerProviderStateMixin
//  todo /// 4- Create  animation Object
//  todo /// 5- Override  Dispose Method  to dispose controller

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 3000),
    );
    animation = new CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn)
      ..addListener(() {
        this.setState(() {
          log("Started and Running ${animation.value}");
        });

        animationController.forward();
      });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 500,
      height: 500,
      child: Center(
        child: Text(
          "TestScreen",
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
            fontFamily: ArabicFonts.Cairo,
            fontSize: 22.0 * animationController.value,
          ),
        ),
      ),
    );
  }
}
