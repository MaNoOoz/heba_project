/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/ui/Screens/chat_screen.dart';
import 'package:heba_project/ui/Screens/profile_screen.dart';
import 'package:heba_project/ui/Screens/search_screen.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = Provider
        .of<UserData>(context)
        .currentUserId;
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedScreen(
            currentUserId: currentUserId,
          ),
          SearchScreen(),
          CreatePostScreen(),
          ChatsScreen(),
          ProfileScreen(
            currentUserId: currentUserId,
            userId: currentUserId,
          ),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentTab,
        onTap: (int index) {
          if (index == 2) {
            openDialog();
          }
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        activeColor: Colors.black45,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.home,
              color: Colors.blue[800],
              size: 42.0,
            ),
            icon: Icon(
              Icons.home,
              size: 32.0,
//              color: Colors.green,
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.search,
              color: Colors.blue[800],
              size: 42.0,
            ),
            icon: Icon(
              Icons.search,
              size: 32.0,
//              color: Colors.amber,
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.add_circle,
              color: Colors.blue[800],
              size: 42.0,
            ),
            icon: Icon(
              Icons.add_circle,
              size: 32.0,
//              color: Colors.blue,
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.comment,

//              FontAwesomeIcons.commentAlt,
              color: Colors.blue[800],
              size: 42.0,
            ),
            icon: Icon(
              Icons.comment,
              size: 32.0,
//              color: Colors.blue,
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.account_circle,
              color: Colors.blue[800],
              size: 42.0,
            ),
            icon: Icon(
              Icons.account_circle,
              size: 32.0,
//              color: Colors.deepOrangeAccent,
            ),
          ),
        ],
      ),
    );
  }

  /// Methods
  void openDialog() async {
    Navigator.of(context).push(
      new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return new CreatePostScreen();
          },
          fullscreenDialog: true),
    );
  }

///
}
