/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/ui/shared/utili/Constants.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreServiceAuth {
  /// vars ==============================================
  static final _firebase_Auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();
  static final PublishSubject loading = PublishSubject();

  /// signOut Google =================================================================
  static Future<String> signOutGoogle() async {
    await googleSignIn.signOut();
    print("signOutGoogle : User Sign Out");
    return 'signInWithGoogle succeeded:';
  }

  /// signOut Firebase =================================================================
  static Future<String> signOutFirebase() async {
    await _firebase_Auth.signOut();
    print("signOutFirebase : User Sign Out");
    return 'signOutFirebase Succeeded:';
  }

  /// signUpUser =================================================================
  static Future<String> signUpUserFromInput(BuildContext context, String name,
      String email, String password, String imageUrl) async {
    try {
      log("signUpUserFromInput Called ");

      AuthResult authResult =
          await _firebase_Auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser signedInUser = authResult.user;
      print("signed in " +
          signedInUser.displayName +
          "\n" +
          signedInUser.photoUrl);
      var clonedUser = await saveDetailsFromGoogleAuth(signedInUser);
      print("signed in " +
          clonedUser.documentId +
          clonedUser.name +
          "\n" +
//        savedUser.name +
//        savedUser.id +
          "\n" +
          clonedUser.profileImageUrl);

//      if (signedInUser != null) {
//        usersRef.document(signedInUser.uid).setData({
//          'email': email,
//          'name': name,
//          'profileImageUrl': imageUrl ?? "${AvailableImages.appIcon}",
//          'uid': signedInUser.uid,
//          'chats': [],
//        });
//        Navigator.pop(context);
//      }
    } catch (e) {
      log(e.toString());
    }
    Navigator.pop(context);
  }

  /// login =================================================================
  static void loginWithFirebase(String email, String password) async {
    try {
      await _firebase_Auth.signInWithEmailAndPassword(
          email: email, password: password);
      new Future.delayed(new Duration(seconds: 3), () {});
    } catch (e) {
      print(e);
    }
  }

  /// isUserLogged =================================================================
  static Future<bool> isUserLogged() async {
    FirebaseUser firebaseUser = await getLoggedFirebaseUser();

    if (firebaseUser != null) {
      IdTokenResult tokenResult = await firebaseUser.getIdToken(refresh: true);
      return tokenResult.token != null;
    } else {
      return false;
    }
  }

  static Future<FirebaseUser> getLoggedFirebaseUser() async {
    return _firebase_Auth.currentUser();
  }

  /// saveDetailsFromGoogleAuth =================================================================
  static Future<String> signInWithGoogle() async {
    print("signInWithGoogle Called");

    loading.add(true);
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult =
    await _firebase_Auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebase_Auth.currentUser();
    assert(user.uid == currentUser.uid);
    print("signed in " + user.displayName + "\n" + user.photoUrl);
    var clonedUser = await saveDetailsFromGoogleAuth(user);
//    var savedUser = await saveProfileDetails(user, user.photoUrl, user.email, user.email);

    print("signed in " +
        clonedUser.documentId +
        clonedUser.name +
        "\n" +
//        savedUser.name +
//        savedUser.id +
        "\n" +
        clonedUser.profileImageUrl);

    loading.add(false);

    return 'signInWithGoogle succeeded: $clonedUser';
  }

  /// saveDetailsFromGoogleAuth =================================================================
  ///
  static Future<User> saveDetailsFromGoogleAuth(FirebaseUser user) async {
    print("saveDetailsFromGoogleAuth");

    DocumentReference ref = usersRef.document(user
        .uid); //reference of the user's document node in database/users. This node is created using uid
    final bool userExists =
    !await ref
        .snapshots()
        .isEmpty; // check if user exists or not
    var data = {
      //add details received from google auth
      'profileImageUrl': user.photoUrl,
      'email': user.email,
      'name': user.displayName,
      'uid': user.uid,
      'lastSeen': DateTime.now(),
    };
    if (!userExists && user.photoUrl != null) {
      // if user entry exists then we would not want to override the photo url with the one received from googel auth
      data['profileImageUrl'] = user.photoUrl;
    }
    ref.setData(data, merge: true); // set the data
    final DocumentSnapshot currentDocument =
    await ref.get(); // get updated data reference

    return User.fromFirestore(
        currentDocument); // create a user object and return
  }

/// saveDetailsFromGoogleAuth =================================================================
//  static Future<User> saveDetailsFromGoogleAuth(FirebaseUser user) async {
//    DocumentReference ref = _firestore.collection('/users').document(user
//        .uid); //reference of the user's document node in database/users. This node is created using uid
//    final bool userExists =
//        !await ref.snapshots().isEmpty; // check if user exists or not
//    var data = {
//      //add details received from google auth
//      'uid': user.uid,
//      'email': user.email,
//      'name': user.displayName,
//    };
//    if (!userExists && user.photoUrl != null) {
//      // if user entry exists then we would not want to override the photo url with the one received from googel auth
//      data['photoUrl'] = user.photoUrl;
//    }
//    ref.setData(data, merge: true); // set the data
//    final DocumentSnapshot currentDocument =
//        await ref.get(); // get updated data reference
//
////    await SharedObjects.prefs
////        .setString(Constants.sessionUsername, user.displayName);
//
//    return User.fromFirestore(
//        currentDocument); // create a user object and return
//  }

//  static Future<User> saveProfileDetails(FirebaseUser user,
//      String profileImageUrl, String email, String bio) async {
//    String uid = _firestore.document(user.uid).toString();
//    //get a reference to the map
//    DocumentReference mapReference = _firestore.document(user.uid);
//    var mapData = {'uid': uid};
//    //map the uid to the username
//    mapReference.setData(mapData);
//
//    DocumentReference ref = _firestore.document(
//        uid); //reference of the user's document node in database/users. This node is created using uid
//    var data = {
//      'photoUrl': profileImageUrl,
//      'email': email,
//      'bio': bio,
//    };
//    await ref.setData(data, merge: true); // set the photourl, age and username
//    final DocumentSnapshot currentDocument =
//        await ref.get(); // get updated data back from firestore
//    return User.fromFirestore(
//        currentDocument); // create a user object and return it
//  }

//  Future<String> currentUser() async {
//    FirebaseUser user = await _auth.currentUser();
//    return user != null ? user.uid : null;
//  }

}
