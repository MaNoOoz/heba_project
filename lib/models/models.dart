/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

//import 'package:timeago/timeago.dart' as timeago;
//import 'package:meta/meta.dart';

//const placeholderStories = <Story>[Story()];
//
//const nickwu241 =
//    User(name: 'nickwu241', imageUrl: 'assets/images/nickwu241.jpg');
//const grootlover = User(
//    name: 'grootlover',
//    imageUrl: 'assets/images/grootlover.jpg',
//    stories: placeholderStories);
//const starlord = User(
//    name: 'starlord',
//    imageUrl: 'assets/images/starlord.jpg',
//    stories: placeholderStories);
//const gamora = User(
//    name: 'gamora',
//    imageUrl: 'assets/images/gamora.jpg',
//    stories: placeholderStories);
//const rocket = User(
//    name: 'rocket',
//    imageUrl: 'assets/images/rocket.jpg',
//    stories: placeholderStories);
//const nebula = User(
//    name: 'nebula',
//    imageUrl: 'assets/images/nebula.jpg',
//    stories: placeholderStories);
//
//const currentUser = nickwu241;

class Post2 {
  final String id;
  dynamic imageUrls;
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

//class User {
//  final String name;
//  final String imageUrl;
//  final List<Story> stories;
//
//  const User({
//    @required this.name,
//    this.imageUrl,
//    this.stories = const <Story>[],
//  });
//}

//class Comment {
//  String text;
//  final User user;
//  final DateTime commentedAt;
//  List<Like> likes;
//
//  bool isLikedBy(User user) {
//    return likes.any((like) => like.user.name == user.name);
//  }
//
//  void toggleLikeFor(User user) {
//    if (isLikedBy(user)) {
//      likes.removeWhere((like) => like.user.name == user.name);
//    } else {
//      likes.add(Like(user: user));
//    }
//  }
//
//  Comment({
//    @required this.text,
//    @required this.user,
//    @required this.commentedAt,
//    @required this.likes,
//  });
//}
//
//class Like {
//  final User user;
//
//  Like({@required this.user});
//}
//
//class Story {
//  const Story();
//}
//
//class student {
//  String id;
//  String name;
//  String score;
//
//  student({this.id, this.name, this.score});
//
//  factory student.fromjson(Map<String, dynamic> parsedJson) {
//    return student(
//      id: parsedJson['id'] ?? '',
//      name: parsedJson['name'] ?? '',
//      score: parsedJson['score'] ?? '15',
//    );
//  }
//
//  Future<String> loadAStudentAsset() async {
//    String mData =
//        await rootBundle.loadString('assets/student.json').catchError((error) {
//      print("object $error");
//    });
//    var jsonRespons = json.decode(mData);
//
//    student mStudent = student.fromjson(jsonRespons);
////    throw Exception('your json file path is null bro');
//    /// test error handling
//
//    if (mData == null) {
//      return Future.error('your json file path is null bro');
//
//      ///Or
////      mData =null;
//    }
////    throw Exception('your json file path is null bro');
//    print("${mStudent.score}");
//
//    return mData;
//  }
//}
