/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heba_project/models/Chat.dart';
import 'package:heba_project/models/Message.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/ui/shared/Constants.dart';

class DatabaseService {
  //  Post2 post;
  StreamController<HebaModel> controller = StreamController<HebaModel>();

  //
  //  Stream<Post2> get PostsStream => _Post2Controller.stream;

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

  /// Feed Page ==================================================

  static HebaPostsFromDb(HebaModel postModel) async {
    List<HebaModel> posts = [];
    QuerySnapshot qn = await publicpostsRef.getDocuments();

    List<DocumentSnapshot> documents = qn.documents;
    documents.forEach((DocumentSnapshot doc) {
      postModel = new HebaModel.fromFirestore(doc);
      posts.add(postModel);
    });

    /// Logs
    documents.map((e) =>
        e.data.forEach((key, value) {
          print("HebaPostsFromDb : Key : $key, Value : $value");
        }));

    /// Logs

    return posts;
  }

  /// as A Stream
  Stream<HebaModel> get hebatStream => controller.stream;

  mStreamOfHeba(HebaModel postModel) async {
    List<HebaModel> posts = [];
    QuerySnapshot qn = await publicpostsRef.getDocuments();
    Stream<HebaModel> stream;
    List<DocumentSnapshot> documents = qn.documents;
    documents.map((DocumentSnapshot msg) {
      var heba = HebaModel.fromFirestore(msg);
      controller.add(heba);
      return heba;
    });

    documents.forEach((DocumentSnapshot doc) {
      postModel = new HebaModel.fromFirestore(doc);
      posts.add(postModel);
    });

    /// Logs
    documents.map((e) =>
        e.data.forEach((key, value) {
          print("HebaPostsFromDb : Key : $key, Value : $value");
        }));

    /// Logs

    return posts;
  }

  static void updateUser(User user) {
    usersRef.document(user.documentId).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
    });
  }

  static Future<QuerySnapshot> searchUsers(String keyword) {
    Future<QuerySnapshot> users = usersRef.where(
        'name', isGreaterThanOrEqualTo: keyword).getDocuments();
    return users;
  }

  /// todo Fix
  static Future<QuerySnapshot> searchChats(String keyword, User user,
      Chat chat) {
    Future<QuerySnapshot> chats = contacts.document(user.uid).collection(
        'userChats')
        .where(chat.chatId, isGreaterThanOrEqualTo: keyword)
        .getDocuments();
    return chats;
  }

  /// Create Post Page ===============================================================================
  static void createPrivatePost(HebaModel post) {
    postsRef.document(post.authorId).collection('userPosts').add({
      'imagesUrls': post.imageUrls,
      'hName': post.hName,
      'isFeatured': post.isFeatured,
      'location': post.location,
      'oName': post.oName,
      'oImage': post.oImage,
//      'geoPoint': post.geoPoint,
      'isMine': post.isMine ?? false,
      'hDesc': post.hDesc,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }

  static void createPublicPosts(HebaModel post) {
//    Map<dynamic, dynamic> sd = {
//      'lat': 12.0,
//      'long': 12.9,
//    };

    publicpostsRef.add({
      'geoPoint': post.geoPoint,
      'imagesUrls': post.imageUrls,
      'hName': post.hName,
      'oName': post.oName,
      'isFeatured': post.isFeatured,
      'isMine': post.isMine ?? false,
      "location": post.location,
//      "geFirePoint": post.geoFirePoint,
      'oImage': post.oImage,
      'hDesc': post.hDesc,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }

  //  static Future<bool> createPublicPosts2(Post2 post) async {
  //    var tt = true;
  //        Map<String, dynamic> sd = {
  //      'lat': 12.0,
  //      'long': 12.9,
  //    };
  //    publicpostsRef.add({
  //      'imagesUrls': post.imageUrls,
  //      'hName': post.hName,
  //      'oName': post.oName,
  //      'isFeatured': post.isFeatured,
  //      'isMine': post.isMine ?? false,
  //      'location': post.location?? UserLocation.fromMapt(sd),
  //      'oImage': post.oImage,
  //      'hDesc': post.hDesc,
  //      'authorId': post.authorId,
  //      'timestamp': post.timestamp,
  //    });
  //    return tt;
  //  }

  static void editPublicPosts(HebaModel post) {
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

  /// Profile Page ===============================================================================
  static Future<List<HebaModel>> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnapshot = await postsRef.document(userId)
        .collection('userPosts').orderBy('timestamp', descending: true)
        .getDocuments();
    List<HebaModel> posts = userPostsSnapshot.documents.map((doc) =>
        HebaModel.fromFirestore(doc)).toList();
    return posts;
  }

  static Future<User> getUserWithId(String userId) async {
    DocumentSnapshot userDocSnapshot = await usersRef.document(userId).get();
    if (userDocSnapshot.exists) {
      return User.fromFirestore(userDocSnapshot);
    }
    return User();
  }

  /// Chat  ==================================================
  static Future<Message> CreateFakeMessageFuture(
      {String senderID, String channelName, String reciverID}) async {
    var ts = Timestamp.fromDate(DateTime.now());

    CHATS.document(senderID).collection('userChats')
        .document(channelName)
        .collection("messages");

    Message message = Message(
        chatId: channelName,
        message: "TEST FROM CreateFakeMessageFuture",
        senderName: "",
        receiverId: reciverID,
        createdAt: DateTime.now().toIso8601String().toString(),
        seen: false,
        timestamp: ts,
        senderId: senderID);
    var mapFromMessage = message.toMap();
    CHATS.add(mapFromMessage);

    return message;
  }

  ///  as a List future
  static Future<List<Message>> GetMessagesFutureAsList(
      {String senderID, String reciverID, String channelName}) async {
    QuerySnapshot messagesSnapshots = await CHATS.document(senderID).collection(
        'userChats').document(channelName).collection("messages").orderBy(
        'timestamp', descending: true).getDocuments();

    if (messagesSnapshots.documents.length > 0) {
      print("U Have  ${messagesSnapshots.documents.length} Messages");
    } else if (messagesSnapshots.documents.length <= 0) {
      print(
          "Error U Dont Have   ${messagesSnapshots.documents.length} Messages");
    }
    List<Message> messages = messagesSnapshots.documents.map((doc) =>
        Message.fromFirestore(doc)).toList();
    return messages;
  }

  /// Chats Page ==================================================
  static Future<List<String>> getUserChats(String userId, String chatId) async {
    Chat chat;
    print("${chat.chatId}");

    DocumentSnapshot userPostsSnapshot = await usersRef.document(userId).get();

    Map data = userPostsSnapshot.data;

    var list = userPostsSnapshot['chatIds'] as List;
    List<String> chatIds = list.map<String>((i) => chat.chatId).toList();
    print("${chatIds}");

    return chatIds;
  }

  /// check if changed
  static void checkForChange(String id) {
    print("checkForChange Called");

    CHATS.document(id).collection(USERCHATS).snapshots().listen((
        querySnapshot) {
      for (var docChange in querySnapshot.documentChanges) {
        if (docChange.type == DocumentChangeType.added) {
          print("DATA CHANGED ${docChange.document.data}");
        }
      }
    });
  }

  /// Create new Chat
  static void CreateFakeChat({
    String currentUserId,
    String channelName,
  }) async {
    print("_CreateChat Called");

    CHATS.document(currentUserId).collection(USERCHATS)
        .document(channelName)
        .collection(channelName);

    Chat mChat = Chat(
      chatId: "@@@@",
      messages: [],
    );

    /// database
    //    createFakeChat(mChat, _collectionReference);
    Map map = mChat.ToMap();

    CHATS.add(map);
  }

  static void CreateFakeMessage(
      {String senderID, String channelId, String reciverID}) {
    var ts = Timestamp.fromDate(DateTime.now());

    CollectionReference messagesSnapshots = CHATS.document(senderID).collection(
        USERCHATS).document(channelId).collection(USERMESSAGES);

    Message message = Message(
        chatId: channelId,
        message: "TEST FROM createMesageForUser",
        senderName: "",
        receiverId: reciverID,
        createdAt: DateTime.now().toIso8601String().toString(),
        seen: false,
        timestamp: ts,
        senderId: senderID);
    var mapFromMessage = message.toMap();
    messagesSnapshots.add(mapFromMessage);

    var Fakemessages = [];
    Fakemessages.add(message);
  }

  static Stream<QuerySnapshot> getStreamOfMessagesFromDocument(String senderID,
      String channelId) {
    print("${channelId}");

    var chatsSnapshotStream = CHATS.document(senderID).collection("userChats")
        .document(channelId).collection("messages")
        .snapshots();

    chatsSnapshotStream.map((QuerySnapshot msg) {
      msg.documents.map((DocumentSnapshot e) {
        return Message.fromFirestore(e);
      });
    });
  }

  static List<String> createChatIdsForUser(
      {String currentUserId, String userId}) {
    CollectionReference messagesSnapshots = contacts.document(currentUserId)
        .collection('userContacts').document(userId).collection("chats")
        .orderBy('timestamp', descending: true);

    Chat message = Chat(chatId: "test");
    messagesSnapshots.add({"": ""});
    var messages = [];
    messages.add(message);
    return messages;
  }
}
