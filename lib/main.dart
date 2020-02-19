/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heba_project/ui/Screens/Create_post_screen.dart';
import 'package:heba_project/ui/Screens/FeedScreen.dart';
import 'package:heba_project/ui/Screens/HomeScreen.dart';
import 'package:heba_project/ui/Screens/LoginScreen.dart';
import 'package:heba_project/ui/Screens/SignupScreen.dart';
import 'package:heba_project/ui/Screens/chat_screen.dart';
import 'package:heba_project/ui/Screens/profile_screen.dart';
import 'package:heba_project/ui/shared/AppNavigation.dart';
import 'package:heba_project/ui/shared/theme.dart';
import 'package:provider/provider.dart';

import 'models/user_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
//        todo make sure this is the right way to check user
        if (!snapshot.hasData == false) {
//          var cu =  AuthService().currentUser();

          var currentUserId = Provider
              .of<UserData>(context, listen: true)
              .currentUserId = snapshot.data.uid;
          print("currentUserId  : ${currentUserId.toString()}");
          return HomeScreen();
        } else {
          return LoginScreen(
            primaryColor: Color(0xFF4aa0d5),
            backgroundColor: Colors.white,
            backgroundImage: new AssetImage("assets/images/building.gif"),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Force DeviceOrientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        title: 'Heba Project',
        debugShowCheckedModeBanner: false,
        theme: buildThemeData(),
        home: _getScreenId(),
        onGenerateRoute: Router.generateRoute,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          ChatsScreen.id: (context) => ChatsScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          ProfileScreen.id: (context) => ProfileScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          CreatePostScreen.id: (context) => CreatePostScreen(),
          FeedScreen.id: (context) {
            return FeedScreen();
          }
        },
      ),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return MultiProvider(
//      providers: [
//        StreamProvider<FirebaseUser>.value(
//          value: FirebaseAuth.instance.onAuthStateChanged,
//          child: MaterialApp(
//            title: 'SSDASD',
//            theme: ThemeData(),
//            initialRoute: 'login',
//            onGenerateRoute: Router.generateRoute,
//          ),
//        ),
//      ],
//    );
//  }
}
