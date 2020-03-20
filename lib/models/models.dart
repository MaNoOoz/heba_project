/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

// https://github.com/googlecodelabs/flutter-cupertino-store/blob/master/step-06/lib/model/product.dart
enum Category {
  all,
  accessories,
  clothing,
  home,
}

class Post2 {
  final String id;

  /// todo : add List Of comments and likes
  //  final String profileImage;
  final List<dynamic> imageUrls;
  final String hName;
  final String oName;
  final String oImage;
  final String hDesc;
  final String hLocation;
  final String authorId;
  final Timestamp timestamp;
  final Category category;
  final bool isFeatured;

  const Post2({
    this.id,
    this.isFeatured,
    this.imageUrls,
    this.oImage,
    this.oName,
    this.category,
    @required this.hName,
    @required this.hDesc,
    this.hLocation,
    @required this.authorId,
    this.timestamp,
  });

  ///  https://stackoverflow.com/questions/50808513/how-do-you-load-array-and-object-from-cloud-firestore-in-flutter
  factory Post2.fromDoc(DocumentSnapshot doc) {
    return Post2(
      id: doc.documentID,
      imageUrls: List.from(doc['imagesUrls'] ?? ["ss", "ss"]),
      hName: doc['hName'] ?? "noName",
      oName: doc['oName'] ?? "noName",
//      category: doc['category'] ?? "category",
      isFeatured: doc['isFeatured'] ?? false,
      oImage: doc['oImage'] ?? "noImage",
      hDesc: doc['hDesc'] ?? "noDesc",
      hLocation: doc['hLocation'] ?? "noLocation",
      authorId: doc['authorId'] ?? "noAuthorId",
      timestamp: doc['timestamp' ?? "noDate"],
    );
  }

  factory Post2.fromDb(Map<String, dynamic> mapDb) {
    return Post2(
      id: mapDb['id'],
      imageUrls: jsonDecode(mapDb['imagesUrls']),
      hName: mapDb['hName'] ?? "noName",
      oName: mapDb['oName'] ?? "noName",
//      category: doc['category'] ?? "category",
      isFeatured: mapDb['isFeatured'] == 0 ?? 0,
      oImage: mapDb['oImage'] ?? "noImage",
      hDesc: mapDb['hDesc'] ?? "noDesc",
      hLocation: mapDb['hLocation'] ?? "noLocation",
      authorId: mapDb['authorId'] ?? "noAuthorId",
//      timestamp: doc['timestamp' ?? "noDate"],
    );
  }

  Map<String, dynamic> toMapForLocalDb() {
    return <String, dynamic>{
      "imageUrls": jsonEncode(imageUrls),
      "hName": hName,
      "id": id,
      "oName": oName,
      "oImage": oImage,
      "hDesc": hDesc,
      "hLocation": hLocation,
      "authorId": authorId,
      "isFeatured": isFeatured ? 1 : 0,
    };
  }

  Map<String, dynamic> toMapAsJson() {
    return <String, dynamic>{
      "imageUrls": jsonEncode(imageUrls),
      "hName": hName,
      "id": id,
      "oName": oName,
      "oImage": oImage,
      "hDesc": hDesc,
      "hLocation": hLocation,
      "authorId": authorId,
      "isFeatured": isFeatured ? 1 : 0,
    };
  }
}
