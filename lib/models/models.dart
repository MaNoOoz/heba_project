/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

// https://github.com/googlecodelabs/flutter-cupertino-store/blob/master/step-06/lib/model/product.dart
//enum Category {
//  all,
//  accessories,
//  clothing,
//  home,
//}

class HebaModel {
  final String id;

  /// todo : add List Of comments and likes
  //  final String profileImage;
  List<dynamic> imageUrls;
  String hName;
  String oName;
  String oImage;
  String hDesc;
  String hCity;
  String authorId;
  Timestamp timestamp;
  bool isFeatured;
  bool isMine;
  UserLocation location;
  GeoPoint geoPoint;
  GeoFirePoint geoFirePoint;
  final DocumentReference reference;

  HebaModel({
    this.geoFirePoint,
    this.geoPoint,
    this.reference,
    this.id,
    this.isFeatured,
    this.imageUrls,
    this.oImage,
    this.oName,
    this.isMine,
    this.hCity,
    @required this.hName,
    @required this.hDesc,
    this.location,
    @required this.authorId,
    this.timestamp,
  });

  ///  https://stackoverflow.com/questions/50808513/how-do-you-load-array-and-object-from-cloud-firestore-in-flutter
//  Post2.fromSnapshot(DocumentSnapshot map)
//      : this.fromMap(map.data, reference: map.reference);

  factory HebaModel.fromFirestore(DocumentSnapshot doc) {
//

    return HebaModel(
        id: doc['id'] ?? "show ya 3athem",
        imageUrls: List<String>.from(doc['imagesUrls'] ?? ["ss", "ss"]),
        hName: doc['hName'] ?? "noName",
        oName: doc['oName'] ?? "noName",
        hCity: doc['hCity'] ?? "hCity",
        geoPoint: doc['geoPoint'],
        isFeatured: doc['isFeatured'] ?? false,
        oImage: doc['oImage'] ?? "noImage",
        isMine: doc['isMine'],
        hDesc: doc['hDesc'] ?? "noDesc",
        authorId: doc['authorId'] ?? "noAuthorId",
        timestamp: doc['timestamp' ?? "noDate"],
        reference: doc.reference);
  }

//  HebaModel.fromSnapshot(DocumentSnapshot map)
//      : id = map.documentID,
//        imageUrls = List.from(map['imagesUrls'] ?? ["ss", "ss"]),
//        hName = map['hName'] ?? "noName",
//        oName = map['oName'] ?? "noName",
////        car = Car.fromJson(map['car']),
//        location = UserLocation.fromJson(map['location']),
//        isFeatured = map['isFeatured'] ?? false,
//        isMine = map['isMine'] ?? false,
//        oImage = map['oImage'] ?? "noImage",
//        hDesc = map['hDesc'] ?? "noDesc",
////        hLocation = map['hLocation'] ?? "noLocation",
//        authorId = map['authorId'] ?? "noAuthorId",
//        timestamp = map['timestamp' ?? "noDate"];

  factory HebaModel.fromMap(Map<dynamic, dynamic> map) => HebaModel(
//      id: map['id'],
        imageUrls: List.from(map['imagesUrls'] ?? ["ss", "ss"]),
        hName: map['hName'] ?? "noName",
        oName: map['oName'] ?? "noName",
        hCity: map['hCity'] ?? "hCity",
        geoPoint: map['geoPoint'] ?? "geoPoint",
        isFeatured: map['isFeatured'] ?? false,
        isMine: map['isMine'] ?? true,
        oImage: map['oImage'] ?? "noImage",
        hDesc: map['hDesc'] ?? "noDesc",
        authorId: map['authorId'] ?? "noAuthorId",
        timestamp: map['timestamp' ?? "noDate"],
//      reference: map['reference'],
      );

  @override
  String toString() => "Record<$id:>";

  factory HebaModel.fromDb(Map<String, dynamic> mapDb) {
    return HebaModel(
      id: mapDb['id'],
      imageUrls: jsonDecode(mapDb['imagesUrls']),
      hName: mapDb['hName'] ?? "noName",
      oName: mapDb['oName'] ?? "noName",
//      category: doc['category'] ?? "category",
      isFeatured: mapDb['isFeatured'] == 0 ?? 0,
      oImage: mapDb['oImage'] ?? "noImage",
      hDesc: mapDb['hDesc'] ?? "noDesc",
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
      "authorId": authorId,
      "isFeatured": isFeatured ? 1 : 0,
    };
  }

  Map<String, dynamic> toMapAsJson() {
    return <String, dynamic>{
      "imageUrls": jsonEncode(imageUrls),
      "hName": this.hName,
      "id": this.id,
      "oName": this.oName,
      "oImage": this.oImage,
      "hCity": this.hCity,
      "hDesc": this.hDesc,
      "geoPoint": this.geoPoint,
      "authorId": this.authorId,
      "isFeatured": this.isFeatured,
      "isMine": this.isMine,
    };
  }
}

class UserLocation {
  double latitude;
  double longitude;
  String address;
  DocumentReference reference;

//  UserLocation();

  UserLocation.fromFeilds(
      {this.latitude, this.reference, this.longitude, this.address});

  factory UserLocation.fromJson(Map<dynamic, dynamic> parsedJson) {
    return UserLocation.fromFeilds(
      latitude: parsedJson['lat'] as num ?? 2.0,
      longitude: parsedJson['long'] as num ?? 2.0,
      address: parsedJson['address'] as String ?? "sasd",
    );
  }

  UserLocation.fromJsonMap(Map json, {this.reference})
      : latitude = json['lat'] as num ?? 2.0,
        longitude = json['long'] as num ?? 2.0,
        address = json['address'] as String ?? "sasd";

  UserLocation.fromMapt(Map<dynamic, dynamic> json)
      : latitude = json['lat'] as num ?? 2.0,
        longitude = json['long'] as num ?? 2.0,
        address = json['address'] as String ?? "sasd";

//  UserLocation.fromDoc(DocumentSnapshot map) : this.fromJsonMap(map.data, reference: map.reference);
  UserLocation.fromDoc(DocumentSnapshot map)
      : latitude = map['lat'],
        longitude = map['long'],
        address = map['address'];

  static UserLocation fromMap(Map<dynamic, dynamic> map) {
    UserLocation loc = new UserLocation.fromMapt(map);
    loc.latitude = map["lat"].toDouble();
    loc.longitude = map["long"].toDouble();
    loc.address = map["address"].toString();

    return loc;
  }
}

String messageToJson(Message data) => json.encode(data.toMap());

class Message {
  String message;
  String idFrom;
  String senderName;
  String idTo;
  String documentId;
  String chatId;
  String createdAt;
  Timestamp timestamp;
  bool seen;
  DocumentReference documentReference;

  Message({this.message,
    this.idFrom,
    this.senderName,
    this.idTo,
    this.documentId,
    this.chatId,
    this.createdAt,
    this.timestamp,
    this.seen,
    this.documentReference});

  //  factory Message.fromFirestore(DocumentSnapshot doc) {
//    Map data = doc.data;
//    return Message.fromMap(data);
//  }

  factory Message.fromFirestoref(DocumentSnapshot doc) {
    return Message(
      documentId: doc.documentID,
      timestamp: doc['timeStamp'],
      createdAt: doc['createdAt'],
      idFrom: doc['idFrom'],
      idTo: doc['idTo'],
      message: doc['message'],
      seen: doc['seen'],
      senderName: doc['senderName'],
      chatId: doc['chatId'],
      documentReference: doc['DocumentReference'],
    );
  }

  Message.fromFirestore(DocumentSnapshot doc)
      : documentId = doc.documentID,
        documentReference = doc.reference,
        timestamp = doc['timestamp'],
        idFrom = doc['idFrom'],
        idTo = doc['idTo'],
        message = doc['content'],
        chatId = doc['chatId'];

  factory Message.fromMap(Map data) {
    return Message(
      message: data['content'] ?? "",
      timestamp: data['timestamp'] ?? Timestamp.now(),
      idFrom: data['idFrom'] ?? "",
      idTo: data['idTo'] ?? "",
      documentId: data['documentId'] ?? "",
      chatId: data['chatId'] ?? "",
      documentReference: data['documentReference'],
    );
  }

  Map<String, dynamic> toMap() =>
      {
        "content": message == null ? null : message,
        "idFrom": idFrom == null ? null : idFrom,
        "idTo": idTo == null ? null : idTo,
        "documentId": documentId == null ? null : documentId,
        "timestamp": timestamp == null ? null : timestamp,
        "chatId": chatId == null ? null : chatId,
        "documentReference":
        documentReference == null ? null : documentReference,
      };
}

class ChatModel extends ChangeNotifier {}

class Chat {
  final String chatId;

//  final List<Message> messages;
//  final User chatingFrom;
//  final User chatingWith;

  List<User> users;

//  Chat({this.chatId, this.messages, this.chatingFrom, this.chatingWith});
  Chat(this.chatId, this.users);

  factory Chat.fromFiresore(DocumentSnapshot doc) {
    doc.documentID;

    var list = doc['messages'] as List;
    var userList = doc['users'] as List;
    List<Message> msgs = list.map((i) => Message.fromFirestore(i)).toList();
    List<User> users = userList.map((i) => User.fromFirestore(i)).toList();

    return Chat(
      doc['chatId'],
      users,
    );
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    var userList = map['users'] as List;

    List<User> users = userList.map((i) => User.fromFirestore(i)).toList();

    /// todo ???
    ///
    return Chat(
      map['chatId'],
      users,
    );
  }

  Map<String, dynamic> toMap() =>
      {
        "chatId": chatId == null ? null : chatId,
        "users": users == null ? null : users,
      };
}

//  factory Chat.fromMap(Map<String,dynamic> map) {
//
////    var list = map['messages'] as List;
////    List<Message> msgs = list.map((i) => Message.fromFirestore(i)).toList();
//
//    /// todo ???
//    ///
//    return Chat(
//      chatId: map['chatId'],
////      messages: msgs,
////      sender: User.fromFirestore(map['sender']),
////      reciver: User.fromFirestore(map['reciver']),
//    );
//  }
//
//  Map<String, dynamic> ToMap() {
//    return {
//      "chatId": chatId == null ? null : chatId,
//      "users": users == null ? null : users,
//
//    };
//  }
//}
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
