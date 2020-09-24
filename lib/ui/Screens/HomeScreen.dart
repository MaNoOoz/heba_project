/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/ui/Screens/profile_screen.dart';
import 'package:provider/provider.dart';

import 'file:///H:/Android%20Projects/Projects/Flutter%20Projects/Mine/heba_project/lib/ui/shared/utili/helperFuncs.dart';

import 'Add_Screen.dart';
import 'ChatListScreen.dart';
import 'FeedScreen.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class HomeScreen extends StatefulWidget {
  static String id = "home_screen";

//  HomeScreen({ this.mapView});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//  int _currentTab = 0;
  PageController _pageController;

  bool isBarVisible = true;

  void onChanged(bool newValue) {
    setState(() {
      isBarVisible = newValue;
    });
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  var bottomSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    final String currentUserId = Provider
        .of<UserData>(context)
        .currentUserId;


    return WillPopScope(
      onWillPop: () async {
        return helperFunctions.OnWillPop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: buildPageView(currentUserId),
        bottomNavigationBar: Visibility(
          visible: isBarVisible,
          child: buildCurvedNavigationBar(
              bottomTapped: bottomTapped,
              bottomSelectedIndex: bottomSelectedIndex,
              pageController: pageController),
        ),
      ),
    );
  }

  PageView buildPageView(String currentUserId) {
    return PageView(
      controller: pageController,
      children: <Widget>[
        FeedScreen(
          currentUserId: currentUserId,
          userId: currentUserId,
          isBarVisible: isBarVisible,
          onChanged: onChanged,
        ),
//          SearchScreen(
//            currentUserId: currentUserId,
//          ),
        CreatePostScreen(
          currentUserId: currentUserId,
        ),
        ChatListScreen(
          currentUserId: currentUserId,
          userID: currentUserId,
        ),
        // ChatListScreen(  currentUserId: currentUserId,
        // userID: currentUserId,),

        // ChatRoom(),
        ProfileScreen(
          currentUserId: currentUserId,
          userId: currentUserId,
//              user: user,
//              chat: chat,
        ),
      ],
      onPageChanged: (int index) {
        pageChanged(index);
      },
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
      log("Current Tap : $bottomSelectedIndex");
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void init() async {
    var status = await helperFunctions.checkNetwork();
    if (status == true) {
      log("NetWork is  :$status");
    } else {
      log("NetWork is  :$status");
    }
  }

  /// Methods
//  void openDialog() async {
//    Navigator.of(context).push(
//      new MaterialPageRoute<Null>(
//          builder: (BuildContext context) {
//            return CreatePostScreen();
//          },
//          fullscreenDialog: true),
//    );
//  }

///
}

class buildCurvedNavigationBar extends StatelessWidget {
  final bottomSelectedIndex;
  final PageController pageController;
  final Function bottomTapped;

  buildCurvedNavigationBar(
      {this.bottomSelectedIndex, this.pageController, this.bottomTapped});

//  void bottomTapped(int index) {
//    setState(() {
//     widget. bottomSelectedIndex = index;
//     widget.pageController.animateToPage(index,
//          duration: Duration(milliseconds: 500), curve: Curves.ease);
//    });
//  }
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(animationCurve: Curves.bounceInOut,
        index: bottomSelectedIndex,
        height: 50,
        buttonBackgroundColor: Colors.blueGrey,
        backgroundColor: Colors.white,
        color: Colors.blueGrey,
        items: <Widget>[
          Icon(Icons.home, color: Colors.white, size: 24),
//            Icon(Icons.search, color: Colors.white, size: 30),
          Icon(Icons.add, color: Colors.white, size: 24),
          Icon(Icons.comment, color: Colors.white, size: 24),
          Icon(Icons.account_circle, color: Colors.white, size: 24),
        ],
        onTap: (int index) {
          return bottomTapped(index);
        });
  }
}
