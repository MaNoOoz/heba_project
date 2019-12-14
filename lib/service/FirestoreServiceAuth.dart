import 'dart:async';

import 'package:heba_project/models/user.dart';
import 'package:heba_project/service/api.dart';
import 'package:heba_project/service/service_loceter.dart';

class FirestoreServiceAuth {
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
