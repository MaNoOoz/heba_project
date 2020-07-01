/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heba_project/service/LocationService.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/state/AppState.dart';
import 'package:heba_project/ui/Screens/ChatScreen.dart';
import 'package:heba_project/ui/Screens/Create_post_screen.dart';
import 'package:heba_project/ui/Screens/FeedScreen.dart';
import 'package:heba_project/ui/Screens/HomeScreen.dart';
import 'package:heba_project/ui/Screens/Location_Pickup.dart';
import 'package:heba_project/ui/Screens/LoginScreen.dart';
import 'package:heba_project/ui/Screens/SignupScreen.dart';
import 'package:heba_project/ui/Screens/profile_screen.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';
import 'models/user_data.dart';
import 'ui/Screens/ChatListScreen.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseUser firebaseUser;

  Widget _getScreenId() {
    return SafeArea(
      child: StreamBuilder<FirebaseUser>(
        initialData: firebaseUser,
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, AsyncSnapshot map) {
//        todo make sure this is the right way to check user
          if (!map.hasData == false) {
            var cU = Provider.of<UserData>(context, listen: true)
                .currentUserId = map.data.uid;
//            var fUser = Provider.of<FirebaseUser>(context);
//
//            var checkUserUid = cU == cU;

            // ADDED
//            helperFunctions.SaveUserUid(checkUserUid);
//            helperFunctions.SaveUserEmail(fUser.email);
//            helperFunctions.SaveUserName(fUser.displayName);

            Provider.of<UserData>(context, listen: true).currentChatId =
                map.data.uid.toString().substring(0, 14);

            return HomeScreen();
          } else {
            return LoginScreen(
              primaryColor: Color(0xFF4aa0d5),
              backgroundColor: Colors.white,
              backgroundImage: new AssetImage("assets/images/building.gif"),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Force DeviceOrientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
//
//        statusBarColor: Colors.white,/* set Status bar color in Android devices. */
//
//        statusBarIconBrightness: Brightness.dark,/* set Status bar icons color in Android devices.*/
//
//        statusBarBrightness: Brightness.dark)/* set Status bar icon color in iOS. */
//    );
    final textTheme = Theme
        .of(context)
        .textTheme;
    return MultiProvider(
      child: ChangeNotifierProvider(
        create: (context) => UserData(),
        child: MaterialApp(
          title: 'Heba Project }',
          debugShowCheckedModeBanner: false,
//          theme: ThemeData(textTheme: GoogleFonts.cairoTextTheme(textTheme).copyWith()),
          theme: ThemeData(

            textTheme: GoogleFonts.cairoTextTheme(Theme
                .of(context)
                .textTheme),),

          darkTheme: ThemeData.dark(),
          home: _getScreenId(),
//          onGenerateRoute: Router.generateRoute,
          routes: {
            LoginScreen.id: (context) => LoginScreen(),
            ChatListScreen.id: (context) => ChatListScreen(),
            ChatScreen.id: (context) => ChatScreen(),
            HomeScreen.id: (context) => HomeScreen(),
            ProfileScreen.id: (context) => ProfileScreen(),
            SignupScreen.id: (context) => SignupScreen(),
            CreatePostScreen.id: (context) => CreatePostScreen(),
//            MapScreen.id: (context) => MapScreen(
//                  context: context,
//                ),
            Location_Pickup.id: (context) => Location_Pickup(),
            FeedScreen.id: (context) => FeedScreen(),
          },
        ),
      ),
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
//        ChangeNotifierProvider<ChatState>(create: (_) => ChatState()),

        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
        StreamProvider<UserLocation>.value(
            value: LocationService().locationStream),
        StreamProvider<Position>.value(
            value: LocationService().locationStream2),
        StreamProvider<Chat>.value(value: DatabaseService().chatsStream),
//        StreamProvider<UserLocation>.value(value: LocationService().locationStream),
//        StreamProvider<Post2>.value(value: DatabaseService().PostsStream), // Not Working
      ],
    );
  }
}
