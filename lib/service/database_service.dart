/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/ui/shared/Constants.dart';

class DatabaseService {
  Post2 post;
  StreamController<Post2> _Post2Controller = StreamController<Post2>();

  Stream<Post2> get PostsStream => _Post2Controller.stream;

//
//  DatabaseService() {
//    List<Post2> posts = [];
//    publicpostsRef.snapshots().listen((snapshot) {
//      if (snapshot != null) {
//        List<DocumentSnapshot> documents = snapshot.documents;
//        documents.forEach((DocumentSnapshot doc) {
//          post = new Post2.fromSnapshot(doc);
//          posts.add(post);
//        });
//        _Post2Controller.add(post);
//      }
//    });
//  }

  static HebaPostsFromDb(Post2 postModel) async {
//    List<Post2> posts = await DatabaseService.getAllPosts2();
    List<Post2> posts = [];
    QuerySnapshot qn = await publicpostsRef.getDocuments();

    List<DocumentSnapshot> documents = qn.documents;
    documents.forEach((DocumentSnapshot doc) {
      postModel = new Post2.fromFirestore(doc);
      posts.add(postModel);
    });

    print("_setupPosts  ${postModel.hName}");
    print("_setupPosts  ${posts.length}");
    return posts;
  }

  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
    usersRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }

  /// ===============================================================================
  static void createPrivatePost(Post2 post) {
    postsRef.document(post.authorId).collection('userPosts').add({
      'imagesUrls': post.imageUrls,
      'hName': post.hName,
      'isFeatured': post.isFeatured,
//      'location': post.location,
      'oName': post.oName,
      'oImage': post.oImage,
      'hDesc': post.hDesc,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }

  /// Publish to Wall ===============================================================
  static void createPublicPosts(Post2 post) {
    publicpostsRef.add({
      'imagesUrls': post.imageUrls,
      'hName': post.hName,
      'oName': post.oName,
      'isFeatured': post.isFeatured,
      'isMine': post.isMine ?? false,
//      'location': post.location,
//      'car': post.car,
      'oImage': post.oImage,
      'hDesc': post.hDesc,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }

  static Future<bool> createPublicPosts2(Post2 post) async {
    var tt = true;
    publicpostsRef.add({
      'imagesUrls': post.imageUrls,
      'hName': post.hName,
      'oName': post.oName,
      'isFeatured': post.isFeatured,
      'isMine': post.isMine ?? false,
      'location': post.location,
      'oImage': post.oImage,
      'hDesc': post.hDesc,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
    return tt;
  }

  static void editPublicPosts(Post2 post) {
    publicpostsRef.add({
      'imagesUrls': post.imageUrls,
      'hName': post.hName,
      'oName': post.oName,
      'isFeatured': post.isFeatured,
//      'location': post.location,
      'oImage': post.oImage,
      'hDesc': post.hDesc,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }

//  static Stream<List<Post2>> getAllPosts() {
//    var ref = publicpostsRef.orderBy('timestamp', descending: true);
//
//    return ref.snapshots().map((list) =>
//        list.documents.map((doc) => Post2.fromSnapshot(doc)).toList());
//
////    List<dynamic> posts = feedSnapshot.documents.map((doc) => Post2.fromDoc(doc)).toList() ;
//  }

//  static Future<List<dynamic>> getAllPosts2() async {
//    QuerySnapshot feedSnapshot = await publicpostsRef
//        .orderBy('timestamp', descending: true)
//        .getDocuments();
//
//    List<dynamic> posts =
//        feedSnapshot.documents.map((doc) => Post2.fromSnapshot(doc)).toList();
//    return posts;
//
////    List<dynamic> posts = feedSnapshot.documents.map((doc) => Post2.fromDoc(doc)).toList() ;
//  }

  /// ===============================================================================
  static Future<List<Post2>> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnapshot = await postsRef
        .document(userId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post2> posts = userPostsSnapshot.documents
        .map((doc) => Post2.fromFirestore(doc))
        .toList();
    return posts;
  }

  static Future<User> getUserWithId(String userId) async {
    DocumentSnapshot userDocSnapshot = await usersRef.document(userId).get();
    if (userDocSnapshot.exists) {
      return User.fromDoc(userDocSnapshot);
    }
    return User();
  }

//  static Future<List<Post2>> getFeedPrivatePosts(String userId) async {
//    QuerySnapshot feedSnapshot = await feedsRef
//        .document(userId)
//        .collection('userFeed')
//        .orderBy('timestamp', descending: true)
//        .getDocuments();
//
//    List<Post2> posts =
//        feedSnapshot.documents.map((doc) => Post2.fromSnapshot(doc)).toList();
//    return posts;
//  }

  static void followUser({String currentUserId, String userId}) {
    // Add user to current user's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .setData({});
    // Add current user to user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData({});
  }

  static void unfollowUser({String currentUserId, String userId}) {
    // Remove user from current user's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // Remove current user from user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser({String currentUserId, String userId}) async {
    DocumentSnapshot followingDoc = await followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get();
    return followingDoc.exists;
  }

  static Future<int> numFollowing(String userId) async {
    QuerySnapshot followingSnapshot = await followingRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();
    return followingSnapshot.documents.length;
  }

  static Future<int> numFollowers(String userId) async {
    QuerySnapshot followersSnapshot = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();
    return followersSnapshot.documents.length;
  }

  static void likePost({String currentUserId, Post2 post}) {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);
    postRef.get().then((doc) {
      int likeCount = doc.data['likeCount'];
      postRef.updateData({'likeCount': likeCount + 1});
      likesRef
          .document(post.id)
          .collection('postLikes')
          .document(currentUserId)
          .setData({});
    });
  }

  static void unlikePost({String currentUserId, Post2 post}) {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);
    postRef.get().then((doc) {
      int likeCount = doc.data['likeCount'];
      postRef.updateData({'likeCount': likeCount - 1});
      likesRef
          .document(post.id)
          .collection('postLikes')
          .document(currentUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  static Future<bool> didLikePost({String currentUserId, Post2 post}) async {
    DocumentSnapshot userDoc = await likesRef
        .document(post.id)
        .collection('postLikes')
        .document(currentUserId)
        .get();
    return userDoc.exists;
  }
}
