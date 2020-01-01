/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = Firestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final usersRef = _firestore.collection('users');
final postsRef = _firestore.collection('posts');
final followersRef = _firestore.collection('followers');
final followingRef = _firestore.collection('following');
final feedsRef = _firestore.collection('feeds');
final likesRef = _firestore.collection('likes');


// Colors
const Color lightBackgroundColor = Color(0xFFFFFFFF);
const Color darkBackgroundColor = Color(0x0000000);

// Padding
const double paddingZero = 0.0;
const double paddingXS = 2.0;
const double paddingS = 4.0;
const double paddingM = 8.0;
const double paddingL = 16.0;
const double paddingXL = 32.0;

// Margin
const double marginZero = 0.0;
const double marginXS = 2.0;
const double marginS = 4.0;
const double marginM = 8.0;
const double marginL = 16.0;
const double marginXL = 32.0;

// Spacing
const double spaceXS = 2.0;
const double spaceS = 4.0;
const double spaceM = 8.0;
const double spaceL = 16.0;
const double spaceXL = 32.0;

