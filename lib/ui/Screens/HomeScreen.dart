/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/models/Chat.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/ui/Screens/profile_screen.dart';
import 'package:heba_project/ui/Screens/search_screen.dart';
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

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Expanded(child: Text('Are you sure?')),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

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
    final ChatModel conversation = Provider
        .of<UserData>(context)
        .conver;
    final User user = Provider
        .of<UserData>(context)
        .user;
//    var currentLocation = Provider.of<UserLocation>(context);
//    var currentUser = Provider.of<FirebaseUser>(context);
//     currentLocation = Us;
//    log(' home Screen : currentLocation.address value is currentLocationFrom stream = ${currentLocation.address}');

//    UniqueKey key;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            FeedScreen(
              currentUserId: currentUserId,
              userId: currentUserId,
            ),
            SearchScreen(
              currentUserId: currentUserId,
            ),
            CreatePostScreen(
              currentUserId: currentUserId,
            ),
            ChatListScreen(
              currentUserId: currentUserId,
            ),
            ProfileScreen(
              currentUserId: currentUserId,
              userId: currentUserId,
//              user: user,
//              chat: chat,
            ),
          ],
          onPageChanged: (int index) {
            setState(() {
              _currentTab = index;
            });
          },
        ),
        bottomNavigationBar: CupertinoTabBar(
//          key: key,
          inactiveColor: Colors.grey,
          border: Border.all(color: Colors.grey, width: 1),
          currentIndex: _currentTab,
          onTap: (int index) {
            if (index == 2) {
//            openDialog();
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
                color: Colors.green,
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
                color: Colors.green,
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
                color: Colors.green,
                size: 52.0,
              ),
              icon: Icon(
                Icons.add_circle,
                color: Colors.orange,

                size: 50.0,
//              color: Colors.blue,
              ),
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.comment,

//              FontAwesomeIcons.commentAlt,
                color: Colors.green,
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
                color: Colors.green,
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
      ),
    );
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
