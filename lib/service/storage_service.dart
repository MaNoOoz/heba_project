/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:heba_project/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../ui/shared/constants.dart';

class StorageService {
  ///
//  static Future<String> uploadUserProfileImage(
//      String url, File imageFile) async {
//    String photoId = Uuid().v4();
//    File image = await compressImage(photoId, imageFile);
//
//    if (url.isNotEmpty) {
//      // Updating user profile image
//      RegExp exp = RegExp(r'userProfile_(.*).jpg');
//      photoId = exp.firstMatch(url)[1];
//    }
//    var child = 'images/users/userProfile_$photoId.jpg';
//    StorageUploadTask uploadTask = storageRef.child(child ?? "images/users").putFile(image);
//    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
//    String downloadUrl = await storageSnap.ref.getDownloadURL();
//    return downloadUrl;
//  }

  ///

//  static Future<String> uploadPostImage(String url, File imageFile) async {
//    String photoId = Uuid().v4();
//    File image = await compressImage(photoId, imageFile);
//
//    if (url.isNotEmpty) {
//      // Updating user profile image
//      RegExp exp = RegExp(r'posts_(.*).jpg');
//      photoId = exp.firstMatch(url)[1];
//    }
//
//    StorageUploadTask uploadTask =
//        storageRef.child('images/posts_$photoId.jpg').putFile(image);
//    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
//    String downloadUrl = await storageSnap.ref.getDownloadURL();
//    return downloadUrl;
//  }

  ///
//  static Future<File> waterMarkImage( File image) async {
//
//    // Read a jpeg image from file.
//    Image result = decodeJpg(image.readAsBytesSync());
//    // Draw some text using 24pt arial font
//    drawString(result, arial_24, 0, 0, 'HEBA');
//     File('test.png').writeAsBytesSync(encodePng(result));
//    return resultfile;
//
//    final tempDir = await getTemporaryDirectory();
//    final path = tempDir.path;
//    File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
//      image.absolute.path,
//      '$path/img_$photoId.jpg',
//      quality: 70,
//    );
//  }

  ///
//  static Future<String> uploadPost(File imageFile) async {
//    String photoId = Uuid().v4();
//    File image = await compressImage(photoId, imageFile);
//    StorageUploadTask uploadTask =
//        storageRef.child('images/posts/post_$photoId.jpg').putFile(image);
//    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
//    String downloadUrl = await storageSnap.ref.getDownloadURL();
//    return downloadUrl;
//  }

  /// Edit  Images before upload to Database
//  static Future<String> editedImages(Asset imageFile) async {
////    await imageFile.requestOriginal();
//
//    ByteData byteData = await imageFile.requestOriginal();
//    List<int> imageData = byteData.buffer.asUint8List();
//    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
//    StorageUploadTask uploadTask = reference.putData(imageData);
//    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
//    String mDownloadUR = await storageTaskSnapshot.ref.getDownloadURL();
//    // Get the download URL
//
//    return mDownloadUR;
//  }

  static Future<File> compressImage(String photoId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    );
    return compressedImageFile;
  }

  static Future<StorageTaskSnapshot> uploadUserProfileImageInSignUp(
      File imageFile, String currentUserID) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);
//    File imageWithWatermark = await waterMarkImage(image);

    /// path to the images from hebat todo 1 use it later to delete images
    var pathInCloud = 'images/Hebat/$currentUserID/HebaImages_$photoId.jpg';
    final StorageUploadTask uploadTask =
        storageRef.child(pathInCloud).putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;

//    String downloadUrl = await storageSnap.ref.getDownloadURL();
//    setState(() {
//      _tasks.add(uploadTask);
//    });

    return storageSnap;
  }

  static Future<String> downloadUrl(StorageTaskSnapshot storageSnap) async {
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<void> ReadyToDeleteTask({HebaModel model, int index}) async {
    print("ReadyToDeleteTask Called");

    /// path to the images from hebat todo 1 use it later to delete images

    /// WTTTF is This
    StorageReference reference =
        FirebaseStorage.instance.ref().child("imageLink");
//   StorageReference reference = FirebaseStorage.instance.ref().child(singleImageUrl);
    print("image reference : ${reference.path}");
    reference.delete().then((value) {
      print("image reference : ${reference.path} image Deleted");
    }).catchError((onError) {
      print("OnError :${onError.toString()}");
    });
  }
}
