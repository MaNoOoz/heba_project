/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/ui/shared/utili/Constants.dart';

class DatabaseService {
  /// Feed Page ==================================================

  /// as A Stream

  static Future<List<HebaModel>> getPosts() async {
    QuerySnapshot userPostsSnapshot = await publicpostsRef
        .orderBy('timestamp', descending: true)
        .getDocuments();

    List<HebaModel> posts = userPostsSnapshot.documents
        .map((doc) => HebaModel.fromFirestore(doc))
        .toList();
    return posts;
  }

  static Stream<List<HebaModel>> initPostsStream() {
    log("_initPostsStream Called : ");
    var posts = DatabaseService.getPosts().asStream();
//    setState(() {
//      staticHebatListFromUser.addAll(posts);
//      duplicateItems.addAll(staticHebatListFromUser);
//    });
//

    return posts;
  }

//  mStreamOfHeba(HebaModel postModel) async {
//    List<HebaModel> posts = [];
//    QuerySnapshot qn = await publicpostsRef.getDocuments();
//    Stream<HebaModel> stream;
//    List<DocumentSnapshot> documents = qn.documents;
//    documents.map((DocumentSnapshot msg) {
//      var heba = HebaModel.fromFirestore(msg);
//      controller.add(heba);
//      return heba;
//    });
//
//    documents.forEach((DocumentSnapshot doc) {
//      postModel = new HebaModel.fromFirestore(doc);
//      posts.add(postModel);
//    });
//
//    /// Logs
//    documents.map((e) => e.data.forEach((key, value) {
//          print("HebaPostsFromDb : Key : $key, Value : $value");
//        }));
//
//    /// Logs
//
//    return posts;
//  }

  static void updateUser(User user) {
    usersRef.document(user.documentId).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
    });
  }

  static Future<QuerySnapshot> searchUsers(String keyword) {
    Future<QuerySnapshot> users =
        usersRef.where('name', isGreaterThanOrEqualTo: keyword).getDocuments();
    return users;
  }

  static Future<QuerySnapshot> searchUsers2(String keyword) {
    Future<QuerySnapshot> users = usersRef
        .where('name', isEqualTo: keyword.substring(0, 1))
        .getDocuments();
    return users;
  }

  /// todo Fix
  static Future<QuerySnapshot> searchChats(
      String keyword, User user, Chat chat) {
    Future<QuerySnapshot> chats = contacts
        .document(user.uid)
        .collection('userChats')
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
      'reference': post.reference,
    });
  }

  static Future<DocumentReference> createPublicPosts(HebaModel post) async {
    DocumentReference ref = publicpostsRef.document();
    var docId2 = ref.documentID;

    var map = {
      'id': docId2,
      'geoPoint': post.geoPoint,
      'imagesUrls': post.imageUrls,
      'hName': post.hName,
      'oName': post.oName,
      'hCity': post.hCity,
      'oContact': post.oContact,
      'isFeatured': post.isFeatured,
      'isMine': post.isMine ?? false,
      "location": post.location,
      'oImage': post.oImage,
      'hDesc': post.hDesc,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    };
    ref.setData(map, merge: true);
    return ref;

//    return publicpostsRef.add({
//      'geoPoint': post.geoPoint,
//      'imagesUrls': post.imageUrls,
//      'hName': post.hName,
//      'oName': post.oName,
//      'hCity': post.hCity,
//      'isFeatured': post.isFeatured,
//      'isMine': post.isMine ?? false,
//      "location": post.location,
//      'oImage': post.oImage,
//      'hDesc': post.hDesc,
//      'authorId': post.authorId,
//      'timestamp': post.timestamp,
//    });
  }

//  static Future<HebaModel> CreatNote(HebaModel heba) async {
//    final TransactionHandler createTransaction = (Transaction tx) async {
//      final DocumentSnapshot ds = await tx.get(publicpostsRef.document());
//
//      var dataMap = heba.toMapAsJson();
//
//      await tx.set(ds.reference, dataMap);
//      print('reference: ${ds.reference.path}');
//
//      return dataMap;
//    };
//
//    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
//      return HebaModel.fromMap(mapData);
//    }).catchError((error) {
//      print('error: $error');
//      return null;
//    });
//  }

  /// Edit Post Page ===============================================================================

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

// static Future<dynamic> updateUsingTransaction(HebaModel heba) async {
//    final DocumentReference postRef = publicpostsRef.document("${heba.id}");
//
//    final TransactionHandler updateTransaction = (Transaction tx) async {
//      final DocumentSnapshot ds = await tx.get(postRef);
//
//      await tx.update(ds.reference, heba.toMapAsJson());
//      print('await tx.update: ${ds.reference}');
//      return {'updated': true};
//    };
//
//    return Firestore.instance
//        .runTransaction(updateTransaction)
//        .then((result) => result['updated'])
//        .catchError((error) {
//      print('error: $error');
//      return false;
//    });
//  }

//  Future<HebaModel> CreatNote(HebaModel note) async {
//    final TransactionHandler createTransaction = (Transaction tx) async {
//      final DocumentSnapshot ds = await tx.get(publicpostsRef.document());
//
//      var dataMap = new Map<String, dynamic>();
//      dataMap = note.toMapAsJson();
//
//      await tx.set(ds.reference, dataMap);
//      print('error: ${ds.reference.path}');
//
//      return dataMap;
//    };
//
//    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
//      return HebaModel.fromMap(mapData);
//    }).catchError((error) {
//      print('error: $error');
//      return null;
//    });
//  }

//  static updatePublicPosts(Map<String, dynamic> map) async {
//    HebaModel resultObject;
//    final TransactionHandler createTransaction = (Transaction tx) async {
//      final DocumentSnapshot ds =
//          await tx.get(publicpostsRef.document(map['id']));
//      if (ds.exists) {
//        await tx.update(ds.reference, map);
//      } else {
//        print(' result 1 : ${ds.exists}');
//        return null;
//      }
//
////      await tx.set(ds.reference, map);
////      print('error: ${ds.reference.path}');
//
//      return map;
//    };
//
//    var result = Firestore.instance.runTransaction(createTransaction);
//    print(' result 2: ${result}');
//
//    result.whenComplete(() {
//      log('Transaction success!');
//      resultObject = HebaModel.fromMap(map);
//      log('heba ${resultObject.hName} success!');
//    });
//
//    return resultObject;
//
////    final DocumentReference postRef = publicpostsRef.document("${heba.id}");
////    print("${postRef.path}");
////
////    Firestore.instance.runTransaction((Transaction transaction) async {
////      final DocumentSnapshot postSnapshot = await transaction.get(postRef);
////      await transaction.set(postSnapshot.reference, map);
////
////      if (postSnapshot.exists) {
////        await transaction.update(postRef, map);
////      }
////    }).whenComplete(() {
////      log('Transaction success!');
////      log('heba ${heba.hName} success!');
//////      heba = HebaModel.fromMap(map);
//////      print("heba ${heba.hName}");
//////      return heba;
////    }).catchError((err) {
////      log("Transaction failure: ', $err");
////    });
//  }

  static Future updatePublicPosts2({HebaModel updatedPost}) async {
    var map = updatedPost.toMapAsJson();

//    var map = {
//      'id': updatedPost.id,
//      'geoPoint': updatedPost.geoPoint,
//      'imagesUrls': updatedPost.imageUrls,
//      'hName': updatedPost.hName,
//      'oName': updatedPost.oName,
//      'hCity': updatedPost.hCity,
//      'isFeatured': updatedPost.isFeatured,
//      'isMine': updatedPost.isMine ?? false,
//      "location": updatedPost.location,
//      'oImage': updatedPost.oImage,
//      'hDesc': updatedPost.hDesc,
//      'authorId': updatedPost.authorId,
//      'timestamp': updatedPost.timestamp,
//    };

    return await publicpostsRef.document(updatedPost.id).setData(map);
//    var docId2 = ref.documentID;

//    todo ?? images paths ??

//    return  ref.setData(map);

//     var ss = await  publicpostsRef.document(passedPost.id).get();
//    HebaModel result = HebaModel.fromFirestore(ss);
//    return result;
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
//  static Future<List<HebaModel>> getUserPosts(String userId) async {
//    QuerySnapshot userPostsSnapshot = await postsRef
//        .document(userId)
//        .collection('userPosts')
//        .orderBy('timestamp', descending: true)
//        .getDocuments();
//
//    List<HebaModel> posts = userPostsSnapshot.documents
//        .map((doc) => HebaModel.fromFirestore(doc))
//        .toList();
//    return posts;
//  }
  static Future<List<HebaModel>> getUserPosts2(String userId) async {
    QuerySnapshot userPostsSnapshot = await publicpostsRef
        .orderBy('timestamp', descending: true)
        .where("authorId", isEqualTo: userId)
        .getDocuments();

    List<HebaModel> posts = userPostsSnapshot.documents
        .map((doc) => HebaModel.fromFirestore(doc))
        .toList();
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

    CHATS
        .document(senderID)
        .collection(USERCHATS)
        .document(channelName)
        .collection(channelName);

    Message message = Message(
        chatId: channelName,
        message: "TEST FROM CreateFakeMessageFuture",
        senderName: "",
        idFrom: senderID,
        createdAt: DateTime.now().toIso8601String().toString(),
        seen: false,
        timestamp: ts,
        idTo: reciverID);
    var mapFromMessage = message.toMap();
    CHATS.add(mapFromMessage);

    return message;
  }

  ///  as a List future
  static Future<List<Message>> GetMessagesFutureAsList(
      String senderID, String reciverID, String channelName) async {
    QuerySnapshot messagesSnapshots = await CHATS
        .document(senderID)
        .collection(USERCHATS)
        .document(channelName)
        .collection(channelName)
        .orderBy('timestamp', descending: true)
        .getDocuments();

    if (messagesSnapshots.documents.length > 0) {
      print("U Have  ${messagesSnapshots.documents.length} Messages");
    } else if (messagesSnapshots.documents.length <= 0) {
      print(
          "Error U Dont Have   ${messagesSnapshots.documents.length} Messages");
    }
    List<Message> messages = messagesSnapshots.documents
        .map((doc) => Message.fromFirestore(doc))
        .toList();
    return messages;
  }

  static Future<String> CreateChatRoomWithMap(String chatRoomId,
      Map<String, dynamic> chatRoomMap) async {
    await CHATS.document(chatRoomId).setData(chatRoomMap).catchError((onError) {
      print(onError.toString());
    });
    return chatRoomId;
  }

  static CreateChatRoomWithObject(String chatRoomId, Map chatRoomMap) {
    CHATS.document(chatRoomId).setData(chatRoomMap).catchError((onError) {
      print(onError.toString());
    });
  }

  /// todo
  static Future<Message> CreateFakeMessageFuture2(
      {String senderID, String charRoomId, String reciverID}) async {
    print("CreateFakeMessageFuture Called ${charRoomId}");

    var ts = Timestamp.fromDate(DateTime.now());

    var ref = CHATS.document(charRoomId).collection(CHAT);

    Message message = Message(
        chatId: charRoomId,
        message: "TEST FROM CreateFakeMessageFuture2",
        senderName: "",
        idFrom: senderID,
        createdAt: DateTime.now().toIso8601String().toString(),
        seen: false,
        timestamp: ts,
        idTo: reciverID);
    var mapFromMessage = message.toMap();
    ref.add(mapFromMessage);

    return message;
  }

  /// Chats Page ==================================================


  Future<void> addUserInfo(userData) async {
    Firestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  static searchByName(String searchField) {
    return Firestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .getDocuments();
  }

  static Future<bool> addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  static getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  static getChats(String chatRoomId) async {
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  static Future<void> addMessage(String chatRoomId, chatMessageData) {
    Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e) {
      print(e.toString());
    });
  }

  // static Future<List<String>> getUserChats(String userId, String chatId) async {
  //   Chat chat;
  //   print("${chat.chatId}");
  //
  //   DocumentSnapshot userPostsSnapshot = await usersRef.document(userId).get();
  //
  //   Map data = userPostsSnapshot.data;
  //
  //   var list = userPostsSnapshot['chatIds'] as List;
  //   List<String> chatIds = list.map<String>((i) => chat.chatId).toList();
  //   print("${chatIds}");
  //
  //   return chatIds;
  // }

  static String getDocId() {
    String docID;
//    var curentChats = CHATS.document(currentUserId).collection(USERCHATS).snapshots();
    var snapshots = publicpostsRef.snapshots();
    var docId = snapshots.forEach((documentSnapshot) {
      var docs = documentSnapshot.documents;
      for (var doc in docs) {
        docID = doc.documentID;
        print("getDocId $docID");
      }
    });
    return docID;
  }

  static Future<QuerySnapshot> ChatsFromFuture(currentUserId) async {
    var curentChats = await CHATS
        .document(currentUserId)
        .collection(USERCHATS)
        .getDocuments();
    return curentChats;
  }

  static Stream<QuerySnapshot> ChatsFromStream(currentUserId) {
    var curentChats =
    CHATS.document(currentUserId).collection(USERCHATS).snapshots();
    return curentChats;
  }

  /// TEST
  /// as A Stream
  StreamController<Chat> _chatsController = StreamController<Chat>();

  Stream<Chat> get chatsStream => _chatsController.stream;

  Stream<Chat> ChatsFromStreamTest(currentUserId) {
    CHATS
        .document(currentUserId)
        .collection(USERCHATS)
        .snapshots()
        .listen((querySnapshot) {
      var docs = querySnapshot.documents;
      for (var doc in docs) {
        var docID = doc.documentID;
        print("getDocId $docID");
        Chat chat = Chat.fromFiresore(doc);
        print("chat ${chat.chatId}");

        _chatsController.add(chat);
      }
    });
  }

//  static changes(QuerySnapshot querySnapshot, String currentUserId) {
////    var chatStream =  ChatsFromStream(currentUserId);
////    var docId = getDocId(currentUserId: currentUserId);
//
////    todo
//    for (var docChange in querySnapshot.documentChanges) {
//      if (docChange.type == DocumentChangeType.added) {
//        var channelName = "";
//        docId = docId
//            .substring(0, 5)
//            .compareTo(currentUserId.substring(0, 5))
//            .toString();
//        channelName = docId;
//        print("channelName  ${channelName}");
//
//        if (currentUserId == docId) {}
//        print("DATA CHANGED ${docChange.document.data}");
//      }
//    }
//  }

  /// check if changed ==================================== Listener ======================
  static checkForChange(String currentUserId) {
    print("checkForChange Called");
    var chatStream = ChatsFromStream(currentUserId);
//    todo
//    chatStream.
//
//    chatStream.listen((event) {
//      var result = changes(event, currentUserId);
//      print("result :  ${result}");
//      return result;
//    });
  }
}

//  /// Create new Chat
//  static void CreateFakeChat({
//    String currentUserId,
//    String channelName,
//  }) async {
//    print("_CreateChat Called");
//
//    CHATS
//        .document(currentUserId)
//        .collection(USERCHATS)
//        .document(channelName)
//        .collection(channelName);
//
//    Chat mChat = Chat(
//      chatId: "@@@@",
//      messages: [],
//    );
//
//    /// database
//    //    createFakeChat(mChat, _collectionReference);
//    Map map = mChat.ToMap();
//
//    CHATS.add(map);
//  }
//
//  static Future<List<Chat>> CreateFakeChatFuture({
//    String currentUserId,
//    String channelName,
//    User sender,
//    User reciver,
//  }) async {
//    print("_CreateChat Called");
//    List<Chat> chats;
//
//    var ref = CHATS.document(currentUserId).collection(USERCHATS);
////        .document(channelName)
////        .collection(channelName);
//
//    Chat mChat = Chat(
//      chatId: "@@@@",
//      messages: [],
//      chatingFrom: User(),
//      chatingWith: User(),
//    );
//
//    /// database
//    //    createFakeChat(mChat, _collectionReference);
//    Map map = mChat.ToMap();
//
//    ref.add(map);
//    return chats;
//  }

//  static void CreateFakeMessage({String senderID, String channelId, String reciverID}) {
//    var ts = Timestamp.fromDate(DateTime.now());
//
//    CollectionReference messagesSnapshots = CHATS.document(senderID).collection(
//        USERCHATS).document(channelId).collection(USERMESSAGES);
//
//    Message message = Message(
//        chatId: channelId,
//        message: "TEST FROM createMesageForUser",
//        senderName: "",
//        receiverId: reciverID,
//        createdAt: DateTime.now().toIso8601String().toString(),
//        seen: false,
//        timestamp: ts,
//        senderId: senderID);
//    var mapFromMessage = message.toMap();
//    messagesSnapshots.add(mapFromMessage);
//
//    var Fakemessages = [];
//    Fakemessages.add(message);
//  }
//  static void CreateChatAndFakeMessage(
//      {String senderID, String channelId, String reciverID}) async {
//    var ts = Timestamp.fromDate(DateTime.now());
//
//    /// todo loop on messages in firestore
//    CollectionReference chatSnapshot = CHATS
//        .document(senderID)
//        .collection(USERCHATS)
//        .document(channelId)
//        .collection(channelId);
//    var messagesSnapshots = await chatSnapshot.getDocuments();
//    var msgs =
//    messagesSnapshots.documents.map((e) =>
//        e.data.forEach((key, value) {
//          var mMap = {key, value};
//          print(" SSSSSSS $mMap");
//        }));
//    print(msgs);
//
//    Message message = Message(
//        chatId: channelId,
//        message: "TEST FROM createMesageForUser",
//        senderName: "",
//        receiverId: reciverID,
//        createdAt: DateTime.now().toIso8601String().toString(),
//        seen: false,
//        timestamp: ts,
//        senderId: senderID);
//    var mapFromMessage = message.toMap();
//    chatSnapshot.add(mapFromMessage);
//
////    var Fakemessages = msgs;
////    msgs.add(message);
//
//  }
//
//  static Stream<QuerySnapshot> getStreamOfMessagesFromDocument(String senderID,
//      String channelId, String reciverID) {
//    print("${channelId}");
//
//    var chatsSnapshotStream = CHATS
//        .document(senderID)
//        .collection(USERCHATS)
//        .document(channelId)
//        .collection(channelId)
//        .snapshots();
//
//    chatsSnapshotStream.map((QuerySnapshot msg) {
//      msg.documents.map((DocumentSnapshot e) {
//        return Message.fromFirestore(e);
//      });
//    });
//    return chatsSnapshotStream;
//  }

//
//  static List<String> createChatIdsForUser(
//      {String currentUserId, String userId}) {
//    CollectionReference messagesSnapshots = contacts
//        .document(currentUserId)
//        .collection('userContacts')
//        .document(userId)
//        .collection("chats")
//        .orderBy('timestamp', descending: true);
//
//    Chat message = Chat(chatId: "test");
//    messagesSnapshots.add({"": ""});
//    var messages = [];
//    messages.add(message);
//    return messages;
//  }
