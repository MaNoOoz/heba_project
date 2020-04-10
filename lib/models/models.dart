/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

// https://github.com/googlecodelabs/flutter-cupertino-store/blob/master/step-06/lib/model/product.dart
//enum Category {
//  all,
//  accessories,
//  clothing,
//  home,
//}

class Car {
  String id;

  Car({this.id});

  factory Car.fromJson(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
    );
  }

  Map<String, dynamic> toMap() =>
      <String, dynamic>{
        'id': this.id,
      };

  String drive() {
    return "dr+iving ...";
  }

//  Car.fromJson(Map<String, dynamic> map) : id = map['id'];

}

class Post2 {
  final String id;

  /// todo : add List Of comments and likes
  //  final String profileImage;
  List<dynamic> imageUrls;
  String hName;
  String oName;
  String oImage;
  String hDesc;
  String authorId;
  Timestamp timestamp;
  bool isFeatured;
  bool isMine;
  UserLocation location;

//  Map location;
  Car car;
  DocumentReference reference;

  Post2({
    this.reference,
    this.id,
    this.car,
    this.isFeatured,
    this.imageUrls,
    this.oImage,
    this.oName,
    this.isMine,
    @required this.hName,
    @required this.hDesc,
    this.location,
    @required this.authorId,
    this.timestamp,
  });

  ///  https://stackoverflow.com/questions/50808513/how-do-you-load-array-and-object-from-cloud-firestore-in-flutter
//  Post2.fromSnapshot(DocumentSnapshot map)
//      : this.fromMap(map.data, reference: map.reference);

  factory Post2.fromFirestore(DocumentSnapshot doc) {
//    Map data = doc.data;

    return Post2(
      id: doc.documentID,
      imageUrls: List<String>.from(doc['imagesUrls'] ?? ["ss", "ss"]),
      hName: doc['hName'] ?? "noName",
      oName: doc['oName'] ?? "noName",
//      location: data['location'] ?? UserLocation(longitude: 23, latitude: 12, address: "asd"),
//      location: UserLocation.fromDoc(doc['location']),
      location: UserLocation.fromMap(doc['location']),
      isFeatured: doc['isFeatured'] ?? false,
//      car: Car.fromJson({"id": "0"}) ?? Car.fromJson({"id": "1"}),
      oImage: doc['oImage'] ?? "noImage",
      hDesc: doc['hDesc'] ?? "noDesc",
      authorId: doc['authorId'] ?? "noAuthorId",
      timestamp: doc['timestamp' ?? "noDate"],
    );
  }

//  Post2.fromSnapshot(DocumentSnapshot map)
//      : id = map.documentID,
//        imageUrls = List.from(map['imagesUrls'] ?? ["ss", "ss"]),
//        hName = map['hName'] ?? "noName",
//        oName = map['oName'] ?? "noName",
//        car = Car.fromJson(map['car']),
//        location = UserLocation.fromJson(map['location']),
//        isFeatured = map['isFeatured'] ?? false,
//        isMine = map['isMine'] ?? false,
//        oImage = map['oImage'] ?? "noImage",
//        hDesc = map['hDesc'] ?? "noDesc",
//        hLocation = map['hLocation'] ?? "noLocation",
//        authorId = map['authorId'] ?? "noAuthorId",
//        timestamp = map['timestamp' ?? "noDate"];

  factory Post2.fromMap(Map<String, dynamic> map, {reference}) {
    return Post2(
      id: map['id'],
      imageUrls: List.from(map['imagesUrls'] ?? ["ss", "ss"]),
      hName: map['hName'] ?? "noName",
      oName: map['oName'] ?? "noName",
//      location: UserLocation.fromJson(map['location']),
      isFeatured: map['isFeatured'] ?? false,
      isMine: map['isMine'] ?? true,
      oImage: map['oImage'] ?? "noImage",
      hDesc: map['hDesc'] ?? "noDesc",
      authorId: map['authorId'] ?? "noAuthorId",
      timestamp: map['timestamp' ?? "noDate"],
      reference: map['reference' ?? "reference"],
    );
  }

  @override
  String toString() => "Record<$hName:$hDesc>";
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
      "hDesc": this.hDesc,
      "authorId": this.authorId,
      "car": this.car.toMap(),
      "isFeatured": this.isFeatured ? 1 : 0,
    };
  }
}

class UserLocation {
  double latitude;
  double longitude;
  String address;
  DocumentReference reference;

  UserLocation();

  UserLocation.fromFeilds(
      {this.latitude, this.reference, this.longitude, this.address});

  factory UserLocation.fromJson(Map<dynamic, dynamic> parsedJson) {
    return UserLocation.fromFeilds(
      latitude: parsedJson['lat'] as num ?? 2.0,
      longitude: parsedJson['long'] as num ?? 2.0,
      address: parsedJson['address'] as String ?? "sasd",
    );
  }

  UserLocation.fromJsonMap(Map<dynamic, dynamic> json, {this.reference})
      : latitude = json['lat'] as num ?? 2.0,
        longitude = json['long'] as num ?? 2.0,
        address = json['address'] as String ?? "sasd";

  UserLocation.fromDoc(DocumentSnapshot map)
      : this.fromJsonMap(map.data, reference: map.reference);

  static UserLocation fromMap(Map<dynamic, dynamic> map) {
    UserLocation gameReivew = new UserLocation();
    gameReivew.latitude = map["lat"].toDouble();
    gameReivew.longitude = map["long"].toDouble();
    gameReivew.address = map["address"].toString();

    return gameReivew;
  }
}
