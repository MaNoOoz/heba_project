/*
 * Copyright (c) 2020.  Made With Love By Yaman Al-khateeb
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post2 {
  final String id;

//  final String profileImage;
  List<dynamic> imageUrls;
  final String hName;
  final String hDesc;
  final String hLocation;
  final String authorId;
  final Timestamp timestamp;

//  List<Like> likes;
//  List<Comment> comments;

//  final Timestamp postedAt;

  Post2({
//    @required this.postedAt,
    this.id,
//    this.profileImage,
    @required this.imageUrls,
    @required this.hName,
    @required this.hDesc,
    this.hLocation,
//    @required this.likes,
//    @required this.comments,
    @required this.authorId,
    @required this.timestamp,
  });

  ///  https://stackoverflow.com/questions/50808513/how-do-you-load-array-and-object-from-cloud-firestore-in-flutter
  factory Post2.fromDoc(DocumentSnapshot doc) {
    return Post2(
      id: doc.documentID,
//      profileImage: doc['profileImageUrl'] ?? '',
      imageUrls: List.from(doc['imagesUrls']),
      hName: doc['hName'],
      hDesc: doc['hDesc'],
      hLocation: doc['hLocation'],
//      likes: List.from(doc['likes']),
//      comments: List.from(doc['comments']),
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
//      postedAt: doc['timestamp'],
    );
  }

//  String timeAgo() {
//    final now = DateTime.now();
//    return timeago.format(now.subtract(now.difference(postedAt)));
//  }

//  bool isLikedBy(User user) {
//    return likes.any((like) => like.user.name == user.name);
//  }
//
//  void addLikeIfUnlikedFor(User user) {
//    if (!isLikedBy(user)) {
//      likes.add(Like(user: user));
//    }
//  }
//
//  void toggleLikeFor(User user) {
//    if (isLikedBy(user)) {
//      likes.removeWhere((like) => like.user.name == user.name);
//    } else {
//      addLikeIfUnlikedFor(user);
//    }
//  }
}
