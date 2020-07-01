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
import 'package:heba_project/ui/shared/helperFuncs.dart';
import 'package:provider/provider.dart';

import 'ChatListScreen.dart';
import 'Create_post_screen.dart';
import 'FeedScreen.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class HomeScreen extends StatefulWidget {
  static String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  PageController _pageController;
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
    final String currentUserId = Provider.of<UserData>(context).currentUserId;
    var user = Provider.of<FirebaseUser>(context);

    return WillPopScope(
      onWillPop: () async {
        return helperFunctions.OnWillPop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: buildPageView(currentUserId),
        bottomNavigationBar: CurvedNavigationBar(
          index: bottomSelectedIndex,
          height: 50,
          buttonBackgroundColor: Colors.blueGrey,
          backgroundColor: Colors.white,
          color: Colors.blueGrey,
          items: <Widget>[
            Icon(Icons.home, color: Colors.white, size: 30),
//            Icon(Icons.search, color: Colors.white, size: 30),
            Icon(Icons.add, color: Colors.white, size: 30),
            Icon(Icons.comment, color: Colors.white, size: 30),
            Icon(Icons.account_circle, color: Colors.white, size: 30),
          ],
          onTap: (int index) {
            bottomTapped(index);
//            if (index == 2) {
////            openDialog();
//            }
//            setState(() {
//              _currentTab = index;
//            });
          },
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
