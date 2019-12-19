/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';

class StringUtils {
  //Font
  String cairo = 'Cairo';

  //Labels
  String strSagmentCotnact = 'Contact';
  String strSagmentGroup = 'Groups';
  String strSgamentFav = 'Favourite';

  String labelEmail = 'Email';
  String lablePassword = 'Password';
  String lableFullname0 = 'Child Name';
  String lableFullname1 = 'الإسم';
  String lableFullname2 = 'الوصف';
  String lableFullname3 = 'المكان';
  String lableMobile = 'Mobile number';
  String lableLoginAccount = 'Login to your Account.';
  String lableCreateAccount = 'Add Contact';
  String btnAdd = 'Add';
  String labelSociaAccount = 'Or signup using social media.';
  String retrunEmail = "Enter valid Email";
  String retrunName = "Name required minimum 4 characters";
  String retrunNumber = "Please enter valid Number";
  String messageSuccess = 'Added successfully';
  String deleteMessageSuccess = 'Deleted successfully';
  String updateMessageSuccess = 'Update successfully';
  String userPlaceHolder =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQmNZxADT7Tc0oznG7e55bA-WvkdkV7CLNXtHs9QB1jwJdb-gt';

  //hint

  String hintOTP = 'Enter OTP';
  String hintName = ' مثال :تلفزيون';
  String hintDesc = 'مثال : الوصف';
  String hintLocation = 'مثال : الرياض';
  String hintContact = 'Ex.  واتس';
  String hintNumber = 'Ex. +919825711336';
  String hintEmail = 'Ex. prashant09mca@gmail.com';

  //Images

  String icFacebook = 'images/ic_facebook.png';
  String icGoogle = 'images/ic_google.png';
  String icPhone = 'images/ic_phone.png';
  String logofb = 'images/logofb.jpg';

  static const CNAME = 'childNames';
  static const KEY_PLUS_VOTES = 'mPlusVotes';
  static const KEY_MINUS_VOTES = 'mMinusVotes';
  static const KEY_NAME = 'childName';
  static const KEY_ISFAV = 'isfav';
  static const KEY_ISMALE = 'isMale';
  static const KEY_ID = 'ID';

  static var FakeNameList = [
    {"childName": "راما", "mPlusVotes": 15, "mMinusVotes": 20, "isfav": false},
    {
      "childName": "ليليان",
      "mPlusVotes": 14,
      "mMinusVotes": 20,
      "isfav": false
    },
    {"childName": "جود", "mPlusVotes": 11, "mMinusVotes": 20, "isfav": false},
    {"childName": "جلنار", "mPlusVotes": 10, "mMinusVotes": 20, "isfav": false},
    {"childName": "جولي", "mPlusVotes": 1, "mMinusVotes": 20, "isfav": false},
    {"childName": "جنات", "mPlusVotes": 13, "mMinusVotes": 20, "isfav": false},
    {"childName": "مهى", "mPlusVotes": 10, "mMinusVotes": 20, "isfav": false},
    {"childName": "نهى", "mPlusVotes": 10, "mMinusVotes": 20, "isfav": false},
    {"childName": "شام", "mPlusVotes": 10, "mMinusVotes": 20, "isfav": false},
  ];

//  List<Name> mNameList = List<Name>()  ;

//  [
//    {"childName": "راما", "mPlusVotes": 15, "mMinusVotes": 20   ,"isfav":false      },
//    {"childName": "ليليان", "mPlusVotes": 14, "mMinusVotes": 20 ,"isfav":false      },
//    {"childName": "جود", "mPlusVotes": 11, "mMinusVotes": 20    ,"isfav":false      },
//    {"childName": "جلنار", "mPlusVotes": 10, "mMinusVotes": 20  ,"isfav":false      },
//    {"childName": "جولي", "mPlusVotes": 1, "mMinusVotes": 20    ,"isfav":false      },
//    {"childName": "جنات", "mPlusVotes": 13, "mMinusVotes": 20   ,"isfav":false      },
//    {"childName": "مهى", "mPlusVotes": 10, "mMinusVotes": 20    ,"isfav":false      },
//    {"childName": "نهى", "mPlusVotes": 10, "mMinusVotes": 20    ,"isfav":false      },
//    {"childName": "شام", "mPlusVotes": 10, "mMinusVotes": 20    ,"isfav":false      },
//  ];

  // ignore: non_constant_identifier_names
  static var MenuItems = ["Favorite", "About Me"];

  static const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0),
    ),
  );
}
