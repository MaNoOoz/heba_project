/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String documentId;
  String name;
  String profileImageUrl;
  String email;
  String uid;
  Timestamp lastSeen;

  User({
    this.uid,
    this.documentId,
    this.name,
    this.profileImageUrl,
    this.email,
    this.lastSeen,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
//    Chat chat = Chat();
//    print("${chat.chatId}");
//    var list = doc['chats'] as List;
//    List<String> chatIds = list.map<String>((i) => chat.chatId).toList();

    Map data = doc.data;

    return User(
//        chatIds: chatIds,
        documentId: doc.documentID,
        uid: data['uid'],
        name: data['name'],
        email: data['email'],
        lastSeen: data['lastSeen'],
        profileImageUrl: data['profileImageUrl']);
  }

//  factory User.fromDoc(DocumentSnapshot doc) {
//    return User(
//      id: doc.documentID,
//      name: doc['name'] ?? 'no Name',
//      profileImageUrl: doc['profileImageUrl'],
//      email: doc['email'] ?? 'NoEmail',
//    );
//  }

  factory User.fromMap(Map data) {
//    Map map = data;
//    var list = map['chats'] as List;
//    List<String> chatIds = list.map<String>((i) => chat.chatId).toList();

    return User(
        documentId: data['uid'],
        lastSeen: data['lastSeen'],
        name: data['name'],
        email: data['email'],
        profileImageUrl: data['profileImageUrl']);
  }

  @override
  String toString() {
    return 'User{documentId: $documentId, name: $name, profileImageUrl: $profileImageUrl, email: $email}';
  }
}
