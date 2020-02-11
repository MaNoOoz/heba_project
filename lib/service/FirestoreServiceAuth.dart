/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static void signUpUser(BuildContext context, String name, String email,
      String password, String imageUrl) async {
    try {
      log("signUpUser Called");

      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser signedInUser = authResult.user;
      if (signedInUser != null) {
        _firestore.collection('/users').document(signedInUser.uid).setData({
          'email': email,
          'name': name,
          'profileImageUrl': imageUrl,
        });
//        todo
//       var singedUserId = Provider
//            .of<UserData>(context)
//            .currentUserId = signedInUser.uid;
//        print("User ID : $singedUserId");
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  static void logout() {
    _auth.signOut();
  }

  static void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      new Future.delayed(new Duration(seconds: 3), () {});
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isUserLogged() async {
    FirebaseUser firebaseUser = await getLoggedFirebaseUser();

    if (firebaseUser != null) {
      IdTokenResult tokenResult = await firebaseUser.getIdToken(refresh: true);
      return tokenResult.token != null;
    } else {
      return false;
    }
  }

  Future<FirebaseUser> getLoggedFirebaseUser() {
    return _auth.currentUser();
  }

//  Api _api = locator<Api>();
//
//  StreamController<User> userController = StreamController<User>();
//
//  Future<bool> login(int userId) async {
//    var fetchedUser = await _api.getUserProfile(userId);
//    var hasUser = fetchedUser != null;
//    if (hasUser) {
//      userController.add(fetchedUser);
//    }
//
//    return hasUser;
//  }
}
