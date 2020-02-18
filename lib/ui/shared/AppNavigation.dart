import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heba_project/ui/Screens/Create_post_screen.dart';
import 'package:heba_project/ui/Screens/HomeScreen.dart';
import 'package:heba_project/ui/Screens/LoginScreen.dart';
import 'package:heba_project/ui/Screens/SignupScreen.dart';

const String initialRoute = "login";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home_screen':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case 'login_screen':
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case 'signup_screen':
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case 'CreatePostScreen':
        return MaterialPageRoute(builder: (_) => CreatePostScreen());
//      case 'post':
//        var post = settings.arguments as Post;
//        return MaterialPageRoute(builder: (_) => PostView(post: post));
      default:
        return MaterialPageRoute(
            builder: (_) =>
                Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
