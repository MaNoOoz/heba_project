/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const googleMapsApiKey = 'AIzaSyDRMvVRVlma0gjFhELTtESq53WsVqvllGw';

/// sup collication
const USERMESSAGES = "USER-MESSAGES";
const USERCHATS = "chat";
const CHAT = "chat";
const List<String> cities = [
  "القصيم",
  "الرياض",
  "الشرقيه",
  "جده",
  "مكه",
  "ينبع",
  "حفر الباطن",
  "المدينة المنورة",
  "الطايف",
  "تبوك",
  "حائل",
  "أبها",
  "الباحة",
  "جيزان",
  "نجران",
  "الجوف",
  "عرعر"
];
const List<String> ContactMrthods = [
  "واتساب",
  "تيلجرام",
  "تويتر",
  "انستجرام",
  "فيسبوك",
  "هبة",
  "SMS",
  "إتصال"
];
const smartChat = [
  {'app': 'https://wa.me/849908854', 'iconData': FontAwesomeIcons.whatsapp},
  {'app': 'tel:8499999999', 'iconData': FontAwesomeIcons.phone},
  {'app': 'sms://8499999999', 'iconData': FontAwesomeIcons.sms},
  {
    'app': 'https://tawk.to/chat/5e5cab81a89cda5a1888d472/default',
    'iconData': FontAwesomeIcons.facebookMessenger
  }
];
final themeColor = Color(0xfff5a623);
final primaryColor = Color(0xff203152);
final greyColor = Color(0xffaeaeae);
final greyColor2 = Color(0xffE8E8E8);

final _firestore = Firestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final usersRef = _firestore.collection('users');
final postsRef = _firestore.collection('posts');
final publicpostsRef = _firestore.collection('publicposts');
final contacts = _firestore.collection('contacts');
final CHATS = _firestore.collection('chats');

final Query publicpostsRefWtihQuery =
    _firestore.collection('publicposts').where("hName", isEqualTo: "uyyhh");
final locations = _firestore.collection('locations');
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
const double padding = 16.0;
const double avatarRadius = 66.0;
// Spacing
const double spaceXS = 2.0;
const double spaceS = 4.0;
const double spaceM = 8.0;
const double spaceL = 16.0;
const double spaceXL = 32.0;
