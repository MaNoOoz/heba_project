/*
 * Copyright (c) 2020.  Made With Love By Yaman Al-khateeb
 */

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/service/FirestoreServiceAuth.dart';
import 'package:heba_project/ui/Screens/HomeScreen.dart';
import 'package:heba_project/ui/Screens/LoginScreen.dart';
import 'package:heba_project/ui/Screens/profile_screen.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool IsBack;
  final bool isImageVisble;
  final String title;
  final Color color;
  final Color flexColor;
  final double flexSpace;
  final Widget card;
  final currentUserName;

  CustomAppBar({
    this.card,
    this.flexSpace,
    Key key,
    this.currentUserName,
    this.title,
    this.color,
    this.flexColor,
    @required this.isImageVisble,
    @required this.IsBack,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  final Size preferredSize; // default is 56.0

}

class _CustomAppBarState extends State<CustomAppBar> {
  FirebaseUser user;

  @override
  void initState() {
    // TODO: implement initState
    initUser();

    super.initState();
  }

  initUser() async {
    return await FirestoreServiceAuth.getLoggedFirebaseUser()
        .then((FirebaseUser value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = Provider.of<UserData>(context).currentUserId;
    final FirebaseUser currentUser = Provider.of<FirebaseUser>(context);

    return PreferredSize(
      preferredSize: Size.fromHeight(130),
      child: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: widget.color,
        title:

//
            Text(
          widget.title,
          style: GoogleFonts.cairo(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Visibility(
            visible: widget.IsBack,
            child: GestureDetector(
//          onTap: () => Navigator.pushNamed(context, isHome ? notificationsViewRoute : homeViewRoute),
              onTap: () => Navigator.pushNamed(context, HomeScreen.id),
              child: IconButton(
                padding: EdgeInsets.only(left: 10.0),
                onPressed: () => Navigator.pop(context),
                icon: Icon(CupertinoIcons.back),
                iconSize: 24.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        actions: <Widget>[
//          FutureBuilder(
//            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//
////            if (!snapshot.hasData) {
////              return mStatlessWidgets().EmptyView();
////            }
//              return GestureDetector(
//                onTap: () {},
//                child: Visibility(
//                  visible: widget.isImageVisble,
//                  child: PopupMenuButton(
//                    child: GestureDetector(
//                      child: Container(
//                        margin: EdgeInsets.all(10),
//                        height: 20.0,
//                        width: 40.0,
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(10.0),
////                          image: DecorationImage(
////                            image:
////                                user.photoUrl.isEmpty ?? 'assets/images/uph.jpg'
////                                    ? Image.asset('assets/images/uph.jpg')
////                                    : NetworkImage(user.photoUrl),
////                            fit: BoxFit.cover,
////                          ),
//                          image: DecorationImage(
//                            image:currentUser.photoUrl.
//                               isEmpty ?? 'assets/images/uph.jpg'
//                                    ? Image.asset('assets/images/uph.jpg')
//                                    : NetworkImage(currentUser.photoUrl),
//                            fit: BoxFit.cover,
//                          ),
//                        ),
//                      ),
//                    ),
//                    offset: Offset(0, 55),
//                    onSelected: ((value) async {
//                      if (value == 'Logout') {
//                        await FirestoreServiceAuth.signOutFirebase();
//                        await FirestoreServiceAuth.signOutGoogle()
//                            .whenComplete(() {
//                          Navigator.of(context).push(
//                            MaterialPageRoute(
//                              builder: (context) {
//                                return LoginScreen();
//                              },
//                            ),
//                          );
//                        });
//                      } else if (value == 'profile') {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (_) => ProfileScreen(
//                                userId: currentUserId,
//                                currentUserId: currentUserId,
//                              ),
//                            ));
//                      }
//                      return "Sign Out object";
//                    }),
//                    itemBuilder: (BuildContext context) {
//                      return [
//                        PopupMenuItem(
//                          value: 'Logout',
//                          child: Text('Logout'),
//                        ),
//                        PopupMenuItem(
//                          value: 'profile',
//                          child: Text('Profile'),
//                        ),
//                      ];
//                    },
//                  ),
//                ),
//              );
//              ;
//            },
//          ),

          GestureDetector(
            onTap: () {},
            child: Visibility(
              visible: widget.isImageVisble,
              child: PopupMenuButton(
                child: GestureDetector(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: 20.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
//                          image: DecorationImage(
//                            image:
//                                user.photoUrl.isEmpty ?? 'assets/images/uph.jpg'
//                                    ? Image.asset('assets/images/uph.jpg')
//                                    : NetworkImage(user.photoUrl),
//                            fit: BoxFit.cover,
//                          ),
                      image: DecorationImage(
                        image: currentUser.photoUrl.isEmpty ??
                                'assets/images/uph.jpg'
                            ? Image.asset('assets/images/uph.jpg')
                            : NetworkImage(currentUser.photoUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                offset: Offset(0, 55),
                onSelected: ((value) async {
                  if (value == 'Logout') {
                    await FirestoreServiceAuth.signOutFirebase();
                    await FirestoreServiceAuth.signOutGoogle().whenComplete(() {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    });
                  } else if (value == 'profile') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                            userId: currentUserId,
                            currentUserId: currentUserId,
                          ),
                        ));
                  }
                  return "Sign Out object";
                }),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'Logout',
                      child: Text('Logout'),
                    ),
                    PopupMenuItem(
                      value: 'profile',
                      child: Text('Profile'),
                    ),
                  ];
                },
              ),
            ),
          ),
        ],
//        bottom:widget.card,
      ),
    );
  }
}
