import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heba_project/models/user.dart';
import 'package:heba_project/service/api.dart';
import 'package:heba_project/service/service_loceter.dart';

class AuthService {

  Api _api = locator<Api>();

  StreamController<User> userController = StreamController<User>();

  Future<bool> login(int userId) async {
    var fetchedUser = await _api.getUserProfile(userId);
    var hasUser = fetchedUser != null;
    if (hasUser) {
      userController.add(fetchedUser);
    }

    return hasUser;
  }
}
