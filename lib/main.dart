import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/ui/Screens/FeedScreen.dart';
import 'package:heba_project/ui/Screens/HomeScreen.dart';
import 'package:heba_project/ui/Screens/LoginScreen.dart';
import 'package:heba_project/ui/Screens/SignupScreen.dart';
import 'package:heba_project/ui/shared/themes.dart';
import 'package:provider/provider.dart';

import 'models/user_data.dart';

void main() {
//  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        title: 'Heba Project',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: _getScreenId(),
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          FeedScreen.id: (context) => FeedScreen(),
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
