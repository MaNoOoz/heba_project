/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String profileImageUrl;
  final String email;
  final String bio;

  User({
    this.id,
    this.name,
    this.profileImageUrl,
    this.email,
    this.bio,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(
        id: doc.documentID,
        name: data['name'],
        email: data['email'],
        bio: data['bio'],
        profileImageUrl: data['profileImageUrl']);
  }
  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      name: doc['name'] ?? 'no Name',
      profileImageUrl: doc['profileImageUrl'],
      email: doc['email'] ?? 'NoEmail',
      bio: doc['bio'] ?? '',
    );
  }
}
