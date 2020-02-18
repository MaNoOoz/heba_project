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
import 'package:heba_project/ui/shared/AppNavigation.dart';
import 'package:heba_project/ui/shared/UtilsImporter.dart';
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
        if (!snapshot.hasData) {
          var currentUserId =
          Provider
              .of<UserData>(context)
              .currentUserId = snapshot.data.uid;
//          print(" currentUserId : ${currentUserId.toString()}");
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
        theme: UtilsImporter().uStyleUtils.themeData,
        home: _getScreenId(),
        onGenerateRoute: Router.generateRoute,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
//          HomeScreen.id: (context) => HomeScreen(),
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
//    return StreamProvider<User>(
//      initialData: User.initial(),
//      create: (context) =>
//          locator<AuthService>().userController.stream,
//      child: MaterialApp(
//        title: 'SSDASD',
//        theme: ThemeData(),
//        initialRoute: 'login',
//        onGenerateRoute: Router.generateRoute,
//      ),
//    );
//  }
}
