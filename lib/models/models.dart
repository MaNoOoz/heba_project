/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Post2 {
  final String id;

//  final String profileImage;
  List<dynamic> imageUrls;
  final String hName;
  final String oName;
  final String oImage;
  final String hDesc;
  final String hLocation;
  final String authorId;
  final Timestamp timestamp;

  Post2({
    this.id,
    this.imageUrls,
    this.oImage,
    this.oName,
    @required this.hName,
    @required this.hDesc,
    this.hLocation,
    @required this.authorId,
    @required this.timestamp,
  });

  ///  https://stackoverflow.com/questions/50808513/how-do-you-load-array-and-object-from-cloud-firestore-in-flutter
  factory Post2.fromDoc(DocumentSnapshot doc) {
    return Post2(
      id: doc.documentID,
      imageUrls: List.from(doc['imagesUrls'] ?? ["ss", "ss"]),
      hName: doc['hName'] ?? "noName",
      oName: doc['oName'] ?? "noName",
      oImage: doc['oImage'] ?? "noImage",
      hDesc: doc['hDesc'] ?? "noDesc",
      hLocation: doc['hLocation'] ?? "noLocation",
      authorId: doc['authorId'] ?? "noAuthorId",
      timestamp: doc['timestamp' ?? "noDate"],
    );
  }
}
