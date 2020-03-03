/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heba_project/models/user_model.dart';

class FirestoreServiceAuth {
  /// vars ==============================================
  static final _firebase_Auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  /// signOutGoogle =================================================================
  static Future<String> signOutGoogle() async {
    await googleSignIn.signOut();
    print("signOutGoogle : User Sign Out");
    return 'signInWithGoogle succeeded:';
  }

  /// signUpUser =================================================================
  static void signUpUser(BuildContext context, String name, String email,
      String password, String imageUrl) async {
    try {
      log("signUpUser Called");

      AuthResult authResult =
      await _firebase_Auth.createUserWithEmailAndPassword(
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
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  /// logout =================================================================
  static void logout() {
    _firebase_Auth.signOut();
    print("logout : User Sign Out");
  }

  /// login =================================================================
  static void login(String email, String password) async {
    try {
      await _firebase_Auth.signInWithEmailAndPassword(
          email: email, password: password);
      new Future.delayed(new Duration(seconds: 3), () {});
    } catch (e) {
      print(e);
    }
  }

  /// isUserLogged =================================================================
  Future<bool> isUserLogged() async {
    FirebaseUser firebaseUser = await getLoggedFirebaseUser();

    if (firebaseUser != null) {
      IdTokenResult tokenResult = await firebaseUser.getIdToken(refresh: true);
      return tokenResult.token != null;
    } else {
      return false;
    }
  }

  Future<FirebaseUser> getLoggedFirebaseUser() async {
    return _firebase_Auth.currentUser();
  }

  /// saveDetailsFromGoogleAuth =================================================================
  static Future<User> saveDetailsFromGoogleAuth(FirebaseUser user) async {
    DocumentReference ref = _firestore.collection('/users').document(user
        .uid); //reference of the user's document node in database/users. This node is created using uid
    final bool userExists =
    !await ref
        .snapshots()
        .isEmpty; // check if user exists or not
    var data = {
      //add details received from google auth
      'uid': user.uid,
      'email': user.email,
      'name': user.displayName,
    };
    if (!userExists && user.photoUrl != null) {
      // if user entry exists then we would not want to override the photo url with the one received from googel auth
      data['profileImageUrl'] = user.photoUrl;
    }
    ref.setData(data, merge: true); // set the data
    final DocumentSnapshot currentDocument =
    await ref.get(); // get updated data reference

//    await SharedObjects.prefs
//        .setString(Constants.sessionUsername, user.displayName);

    return User.fromFirestore(
        currentDocument); // create a user object and return
  }

  static Future<User> saveProfileDetails(FirebaseUser user,
      String profileImageUrl, String email, String bio) async {
    String uid = _firestore.document(user.uid).toString();
    //get a reference to the map
    DocumentReference mapReference = _firestore.document(user.uid);
    var mapData = {'uid': uid};
    //map the uid to the username
    mapReference.setData(mapData);

    DocumentReference ref = _firestore.document(
        uid); //reference of the user's document node in database/users. This node is created using uid
    var data = {
      'photoUrl': profileImageUrl,
      'email': email,
      'bio': bio,
    };
    await ref.setData(data, merge: true); // set the photourl, age and username
    final DocumentSnapshot currentDocument =
    await ref.get(); // get updated data back from firestore
    return User.fromFirestore(
        currentDocument); // create a user object and return it
  }

//  Future<String> currentUser() async {
//    FirebaseUser user = await _auth.currentUser();
//    return user != null ? user.uid : null;
//  }

}
