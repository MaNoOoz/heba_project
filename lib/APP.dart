import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/service/FirestoreServiceAuth.dart';
import 'package:heba_project/service/service_loceter.dart';
import 'package:heba_project/ui/shared/router.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>(
      initialData: User.initial(),
      create: (context) =>locator<FirestoreServiceAuth>().userController.stream,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(),
        initialRoute: 'login',
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }

}
