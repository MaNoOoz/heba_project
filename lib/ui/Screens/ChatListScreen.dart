/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/service/DatabaseService.dart';
import 'package:heba_project/ui/Screens/ChatScreen.dart';
import 'package:heba_project/ui/shared/utili/Constants.dart';
import 'package:logger/logger.dart';

import 'file:///H:/Android%20Projects/Projects/Flutter%20Projects/Mine/heba_project/lib/ui/shared/widgets/CustomAppBar.dart';

class ChatListScreen extends StatefulWidget {
  static final String id = 'ChatListScreen';
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String currentUserId;
  final String userID;

  ChatListScreen({Key key, this.currentUserId, this.scaffoldKey, this.userID}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with AfterLayoutMixin {
  /// vars ==================================================

  var _searchController = new TextEditingController();
  List<Text> texts;
  Chat mChat;
  String chatId;
  String chatId2;
  String cu;
  User toUser;
  QuerySnapshot empty;
  Stream<QuerySnapshot> chatListStream;
  Stream<QuerySnapshot> chatRooms;
  Stream<QuerySnapshot> usersStream;

  // String currentUserId;
  FirebaseUser fUser;
  StreamController<User> streamController;
  List<User> usersList = [];
  List<User> duplicateItems = [];
  String _ReciverName;

  /// Log ===================================================
  Logger logger = Logger();

  @override
  void initState() {
    init();

    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // });
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    // await getUserInfogetChats();
  }

  // getUserInfogetChats() async {
  //   cu = widget.currentUserId;
  //   // var s = await getUserFrom(widget.currentUserId);
  //   // print("getUserInfogetChats $s");
  //   DatabaseService.getUserChats(cu).then((snapshots) {
  //     setState(() {
  //       chatRooms = snapshots;
  //       print("we got the data + ${chatRooms.toString()} this is name  ${cu}");
  //     });
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    streamController?.close();
    streamController = null;
  }

  init() async {
    logger.d("init Called ${widget.currentUserId.length} ===== ${widget.currentUserId}");

    cu = widget.currentUserId;

    DatabaseService.getUserChats(cu).then((snapshots) {
      logger.d("DatabaseService.getUserChats");

      setState(() {
        chatRooms = snapshots;
        logger.d("we got the data chatRooms  ${chatRooms.toString()} this is name  ${cu}");
      });
    });

    _ReciverName = getUserNameFromUid2(cu).then((snapshot) {
      logger.d("getUserNameFromUid2");

      setState(() {
        usersStream = snapshot;
        logger.d("we got the data usersStream ${usersStream.toString()} this is name  ${cu}");
      });
    });

    chatListStream = getCurrentUserChats(widget.currentUserId).asStream();

    streamController = StreamController.broadcast();

    streamController.stream.listen((event) {
      setState(() {
        usersList.add(event);
      });
    });

    duplicateItems = await load(streamController);

    setState(() {
      usersList = duplicateItems;
    });

    return usersList;
  }

  // Widget chatRoomsList() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: chatRooms,
  //     builder: (context, snapshot) {
  //       return snapshot.hasData
  //           ? ListView.builder(
  //               itemCount: snapshot.data.documents.length,
  //               shrinkWrap: true,
  //               itemBuilder: (context, index) {
  //                 return ChatRoomsTile(
  //                   userName: snapshot.data.documents[index].data['chatRoomId'].toString().replaceAll("_", "").replaceAll(cu, ""),
  //                   chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
  //                 );
  //               })
  //           : Container();
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // currentUserId = Provider.of<UserData>(context).currentUserId;
    logger.d("duplicateItems: ${duplicateItems.length}");
    logger.d("usersList.map : ${usersList.map((e) => e.email)}");

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: "المحادثات",
              IsBack: false,
              isImageVisble: true,
              color: Colors.blueGrey,
            ),
            Container(height: 40, child: SearchCard(context)),
          ],
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: chatRooms,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1) {
          if (snapshot1.data == null) return Center(child: CircularProgressIndicator());

          return snapshot1.hasData
              ? ListView.builder(
                  itemCount: snapshot1.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var reciverName2 = snapshot1.data.documents[index].data['chatRoomId'].toString().replaceAll("_", "").replaceAll(cu, "");
                    var chatRoomId = snapshot1.data.documents[index].data['chatRoomId'].toString();
                    // var name = snapshot1.data.documents.map((e) => e.data['name']).toString();

                    return FutureBuilder<QuerySnapshot>(
                        future: usersRef.getDocuments(),
                        builder: (context, snapshot) {
                          var reciverName = snapshot.data.documents[index].data['name'];
                          var reciverPic = snapshot.data.documents[index].data['profileImageUrl'];

                          var realName = _ReciverName;

                          // return ListTile(
                          //   title: Text("${snapshot.data.documents[index].data['name']}"),
                          //   leading: Text(reciverName2),
                          // );
                          //
                          return ChatItem(i: index, reciverName: reciverName, chatRoomId: chatRoomId, reciverPic: reciverPic);
                        });
                  })
              : Container(
                  child: Text("aa"),
                );
        },
      ),

      // body: chatRoomList2(toUser: toUser,chatId: chatId,chatListStream: chatListStream,currentUserId: currentUserId,),
      /// SearchBar
    );
  }

  /// ======================================= METHODS ================================================
  getStreamOfUsers() async {
    List<User> users = [];
    var qn = usersRef.snapshots();
    await for (var userSnapshot in qn) {
      for (var doc in userSnapshot.documents) {
        User user = new User.fromFirestore(doc);
        users.add(user);
        logger.d("getStreamOfUsers  : ${users.length} ");
      }
    }
    return qn;
//    var documents = qn.map((event) => event.documents).listen((event) {
//      var docs = event;
//
//      docs.forEach((DocumentSnapshot doc) {
//
//
//      });
//    });
  }

  getUsersIds() async {
    List<String> userIds = [];
    var qn = usersRef.snapshots();
    await for (var userSnapshot in qn) {
      var docs = userSnapshot.documents;
      for (var doc in docs) {
        List<Map> ids = doc.data['uid'];
        logger.d("getUsersIds  : ${ids.length} ");

//        User sender = User(uid: );
//        User reviver = User();
//        User user = new User.fromFirestore(doc);
//        userIds.add(uid);
//        logger.d("getStreamOfUsers  : ${users.length} ");
      }
    }
//    var documents = qn.map((event) => event.documents).listen((event) {
//      var docs = event;
//
//      docs.forEach((DocumentSnapshot doc) {
//
//
//      });
//    });
  }

//   getStreamOfChats() async {
// //    List<User> users = [];
//     var qn = CHATS.document(currentUserId).collection(USERCHATS).snapshots();
//     await for (var userSnapshot in qn) {
//       for (var doc in userSnapshot.documents) {
// //        User user = new User.fromFirestore(doc);
// //        users.add(user);
//         logger.d("getStreamOfChats  : ${userSnapshot.documents.length} ");
//       }
//     }
// //    var documents = qn.map((event) => event.documents).listen((event) {
// //      var docs = event;
// //
// //      docs.forEach((DocumentSnapshot doc) {
// //
// //
// //      });
// //    });
//   }

  Future<QuerySnapshot> getCurrentUserChats(String chattingFromId) {
    return CHATS.where("users", arrayContains: chattingFromId).getDocuments();
  }

//   User getUserFromUid(String uid) {
//     logger.d("getUserFromUid Called ");
//
//     Query query;
//     query = usersRef.where("uid", isEqualTo: uid);
//     var s = query.snapshots();
// //    var users = [];
//     s.forEach((element) {
//       var docs = element.documents;
//       for (var doc in docs) {
//         logger.d("docs in user ref: ${docs.length}");
//
//         toUser = User.fromFirestore(doc);
// //        users.add(chattingWithUser);
// //        logger.d("users ${users.length}");
//       }
//     });
//
//     return toUser;
// //
// //  var q = await usersRef.where("uid", isEqualTo: uid).getDocuments();
// //    var docs = q.documents;
// //    for (var doc in docs) {
// //      chattingWithUser = User.fromFirestore(doc);
// //    }
// ////    setState(() {
// ////      chattingWithUser = user;
// ////    });
// ////    return chattingWithUser;
// //    return chattingWithUser;
//   }

//   List<User> getUserFrom(String uid) {
//     logger.d("getUserFromUid Called ");
//
//     Query query;
//     query = usersRef.where("uid", isEqualTo: uid);
//     var s = query.snapshots();
//     List<User> users = [];
//     s.forEach((element) {
//       var docs = element.documents;
//       for (var doc in docs) {
//         logger.d("docs in user ref: ${docs.length}");
//
//         toUser = User.fromFirestore(doc);
//         users.add(toUser);
//         logger.d("usersss ${users.length}");
//       }
//     });
//
//     return users;
// //
// //  var q = await usersRef.where("uid", isEqualTo: uid).getDocuments();
// //    var docs = q.documents;
// //    for (var doc in docs) {
// //      chattingWithUser = User.fromFirestore(doc);
// //    }
// ////    setState(() {
// ////      chattingWithUser = user;
// ////    });
// ////    return chattingWithUser;
// //    return chattingWithUser;
//   }
//   getUserNameFromUid(String chattingWith) {
//     logger.d("getUserFrom Called ");
//     var name;
//     Query query;
//     query = usersRef.where("uid", isEqualTo: chattingWith);
//     var s = query.snapshots();
//     List<String> users = [];
//     s.forEach((element) {
//       var docs = element.documents;
//       for (var doc in docs) {
//         logger.d("docs in user ref: ${docs.length}");
//
//         toUser = User.fromFirestore(doc);
//         name = toUser.name;
//
//         users.add(name);
//         logger.d("usersss ${name}");
//       }
//     });
//
//     return name;
// //
// //  var q = await usersRef.where("uid", isEqualTo: uid).getDocuments();
// //    var docs = q.documents;
// //    for (var doc in docs) {
// //      chattingWithUser = User.fromFirestore(doc);
// //    }
// ////    setState(() {
// ////      chattingWithUser = user;
// ////    });
// ////    return chattingWithUser;
// //    return chattingWithUser;
//   }

  getUserNameFromUid2(String chatRoomID) {
    logger.d("getUserFrom Called ");
    Query query;
    query = usersRef.where("uid", isEqualTo: chatRoomID);
    var s = query.snapshots();
    List<String> users = [];
    s.forEach((element) {
      var docs = element.documents;
      for (var doc in docs) {
        logger.d("docs in user ref: ${docs.length}");

        toUser = User.fromFirestore(doc);
        _ReciverName = toUser.name;

        users.add(_ReciverName);
      }
    });
    logger.d("USERNAME ${users[0]}");

    return _ReciverName;
//
//  var q = await usersRef.where("uid", isEqualTo: uid).getDocuments();
//    var docs = q.documents;
//    for (var doc in docs) {
//      chattingWithUser = User.fromFirestore(doc);
//    }
////    setState(() {
////      chattingWithUser = user;
////    });
////    return chattingWithUser;
//    return chattingWithUser;
  }

  String getChattingWithFromChatRoomId(String chatRoomId) {
    logger.d("getChattingWithFromChatRoomId Called ");

    var chattinWith = chatRoomId.toString().replaceAll("_", "").replaceAll(widget.currentUserId.toString(), "");
    logger.d("chatting From : ${widget.currentUserId}");
    // logger.d("chatting With : $chattinWith");
    logger.d("chatting With : ${widget.userID}");
    return chattinWith;
  }

  Future<List<User>> load(StreamController<User> streamController) async {
    return await chatListStream.expand((element) => element.documents).map((event) => User.fromFirestore(event)).toList();
  }

  Future<QuerySnapshot> load2() async {
    return usersRef.getDocuments();
  }

  /// ========================================= WIDGETS ============================================

//   Widget buildFutureBuilder() {
//     var screenSize = MediaQuery.of(context).size;
// //    var chat = Provider.of<Chat>(context).chatId;
//     QuerySnapshot empty;
//     return StreamBuilder<QuerySnapshot>(
//         stream: usersRef.snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
//           if (!userSnapshot.hasData) {
//             return Container(
//               color: Colors.amber,
//             );
//           }
//
//           return StreamBuilder<QuerySnapshot>(
//             initialData: empty,
//             stream: CHATS.document(currentUserId).collection(USERCHATS).snapshots(),
//             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               logger.d("stream value : ${snapshot.data.documents.length} ");
// //        logger.d("chatId Id's  from chats : ${snapshot.data.documents.map((e) => e.data['chatId'])} ");
//
//               if (!snapshot.hasData) {
//                 return Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       mStatlessWidgets().mLoading(),
//                     ],
//                   ),
//                 );
//               } else if (snapshot.hasError) {
//                 logger.d('u have error in future');
//               } else if (snapshot.data.documents.length == 0) {
//                 return Center(
//                   child: Text('No Chats'),
//                 );
//               }
//               return ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: snapshot.data.documents.length,
//                 shrinkWrap: true,
//                 itemBuilder: (context, i) {
//                   var txt = snapshot.data.documents.map((e) => e.documentID).toString();
//
//                   texts = [];
//                   String tx = txt;
//                   Text text = Text(tx);
// //                  Text text2 = Text("${chat}");
//                   texts.add(text);
//                   return Column(children: texts);
// //                  return chatRow(screenSize);
// //
// //                  final messagedUsers = userSnapshot.data.documents;
// //                  List<Container> listOfViewHolder = [];
// //                  for (var userDoc in messagedUsers) {
// //                    final String userUid = userDoc.data['uid'];
// //                    var listOfDocuments = snapshot.data.documents;
// //                    for (var dc in listOfDocuments) {
// //                      if (dc["uid"] == userUid) {
// //                        downloadUrlFinal = dc["imageDownloadUrl"];
// //                        bioOfUser = dc["bio"];
// //                        receiverToken = dc['token'];
// //                      }
// //                    }
// //
// //                  }
// //                  users.add(user);
// //                  logger.d("getStreamOfUsers  : ${users.length} ");m
// //                  return Column(children: listOfViewHolder);
//                 },
//               );
//             },
//           );
//         });
//   }

  Widget chatRoomList(AsyncSnapshot<QuerySnapshot> chatrooms, String rn) {
    return FutureBuilder<List<User>>(
      future: load(streamController),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        logger.d("FutureBuilder  : usersList: ${usersList.length} user names : ${usersList.map((e) => e.name)}");
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: usersList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var reciverName = chatrooms.data.documents[index].data['chatRoomId'].toString().replaceAll("_", "").replaceAll(cu, "");
            var chatRoomId = chatrooms.data.documents[index].data["chatRoomId"];
            // getChattingWithFromChatRoomId(chatrooms.data.documents[index].data['chatRoomId'].toString());
            return ChatItem(
              i: index,
              reciverName: rn,
              chatRoomId: chatRoomId,
            );
          },
        );
      },
    );
  }

  Widget ChatItem({int i, String reciverName, String chatRoomId, var reciverPic}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatScreen(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Card(
        child: ListTile(
          subtitle: Text("${i.toString()}"), // lastMessage
          leading: Container(
            color: Colors.white,
            child: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.transparent,
              child: Image.network(
                reciverPic,
                scale: 1,
                fit: BoxFit.contain,
              ),
            ),
//                                                ),
          ),
          title: Text("$reciverName"), // userName
        ),
      ),
    );
  }

//  todo
  searchList(String keyword) async {
    var cityFilter;
    List<User> filterdHebat = [];
    filterdHebat.addAll(usersList);
    if (keyword.isNotEmpty) {
      var resultList = filterdHebat.where((i) {
        cityFilter = i.name.toLowerCase().contains(keyword.toLowerCase());
//        logger.d("cityFilter :${cityFilter}");
        return cityFilter;
      }).toList();
      setState(() {
        logger.d("keyword :${keyword}  is ${cityFilter}");
        usersList = resultList;
      });
      return usersList;
    } else {
      setState(() {
        usersList = duplicateItems;
      });
    }
  }

  Widget SearchCard(BuildContext context) {
    var txtFeild2 = TextFormField(
      style: TextStyle(
        color: Colors.blueGrey,
      ),
      textAlign: TextAlign.start,
//      textDirection: TextDirection.rtl,
      onChanged: (input) {
        searchList(input);
      },
      onSaved: (input) {
        searchList(input);
      },

      cursorColor: Colors.blueGrey,
      controller: _searchController,
      decoration: InputDecoration(
        hintText: "بحث",
        hintStyle: TextStyle(
          decorationColor: Colors.blueGrey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey.withOpacity(0.5),
        ),
        border: InputBorder.none,
      ),
    );

    return Card(
      elevation: 10,
      color: Colors.white,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 10,
          ),
          GestureDetector(
//              todo search query
            onTap: () async {
              FocusScope.of(context).unfocus();
              _searchController.clear();
            },

            child: const Icon(
              CupertinoIcons.search,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: txtFeild2,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () async {
              FocusScope.of(context).unfocus();
              _searchController.clear();
            },
            child: const Icon(
              CupertinoIcons.clear_thick_circled,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget chatRow(User user) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Visibility(
                visible: true,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(2.0),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[

                                          /// Icons
                                          Container(
                                            width: 30,
                                            child: IconButton(
                                              icon: Icon(
                                                CupertinoIcons.left_chevron,
                                                color: Colors.black54,
                                                size: 16,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ),

//                                            Container(
//                                              child: Align(
//                                                alignment:
//                                                    AlignmentDirectional.center,
//                                                child: Padding(
//                                                  padding: const EdgeInsets
//                                                          .symmetric(
//                                                      vertical: 8.0,
//                                                      horizontal: 8.0),
//                                                  child: Container(
//                                                    width: 20,
//                                                    child: IconButton(
//                                                      icon: Icon(
//                                                        FontAwesomeIcons.flag,
//                                                        color: Colors.black54,
//                                                        size: 16,
//                                                      ),
//                                                      onPressed: () {},
//                                                    ),
//                                                  ),
//                                                ),
//                                              ),
//                                            ),
                                        ],
                                      ),

                                      /// Space
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Container(
                                          child: SizedBox(
                                            width: 10,
                                          ),
                                        ),
                                      ),

                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Align(
                                              alignment: AlignmentDirectional.center,
                                              child: Container(
                                                child: Text(
                                                  user.name ?? "SS",
                                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Align(
                                              alignment: AlignmentDirectional.center,
                                              child: Container(
                                                child: CircleAvatar(
                                                  radius: 15.0,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: user.profileImageUrl.isEmpty ? AssetImage('assets/images/user_placeholder.jpg') : CachedNetworkImageProvider(user.profileImageUrl),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatRow2({var screenSize, List<User> user, int i}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatScreen(
                      chatRoomId: chatId,
                      loggedInUserUid: widget.currentUserId,
                    )));
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Container(
//                width: screenSize.width,
                child: Visibility(
                  visible: true,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(2.0),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: AlignmentDirectional.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[

                                            /// Icons
                                            Container(
                                              width: 30,
                                              child: IconButton(
                                                icon: Icon(
                                                  CupertinoIcons.left_chevron,
                                                  color: Colors.black54,
                                                  size: 16,
                                                ),
                                                onPressed: () {},
                                              ),
                                            ),

//                                            Container(
//                                              child: Align(
//                                                alignment:
//                                                    AlignmentDirectional.center,
//                                                child: Padding(
//                                                  padding: const EdgeInsets
//                                                          .symmetric(
//                                                      vertical: 8.0,
//                                                      horizontal: 8.0),
//                                                  child: Container(
//                                                    width: 20,
//                                                    child: IconButton(
//                                                      icon: Icon(
//                                                        FontAwesomeIcons.flag,
//                                                        color: Colors.black54,
//                                                        size: 16,
//                                                      ),
//                                                      onPressed: () {},
//                                                    ),
//                                                  ),
//                                                ),
//                                              ),
//                                            ),
                                          ],
                                        ),

                                        /// Space
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                            child: SizedBox(
                                              width: 10,
                                            ),
                                          ),
                                        ),

                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(1.0),
                                              child: Align(
                                                alignment: AlignmentDirectional.center,
                                                child: Container(
                                                  child: Text(
                                                    user[i].name ?? "SS",
                                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(1.0),
                                              child: Align(
                                                alignment: AlignmentDirectional.center,
                                                child: Container(
                                                  color: Colors.white,
                                                  child: CircleAvatar(
                                                    radius: 15.0,
                                                    backgroundColor: Colors.white,
                                                    backgroundImage:
                                                    user[i].profileImageUrl.isEmpty ? AssetImage('assets/images/user_placeholder.jpg') : CachedNetworkImageProvider(user[i].profileImageUrl),
//                                                ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//  Widget buildFutureBuilder() {
//    var screenSize = MediaQuery.of(context).size;
//    QuerySnapshot empty;
//    return StreamBuilder<QuerySnapshot>(
//      initialData: empty,
//      stream: CHATS
//          .document(currentUserId)
//          .collection(USERCHATS)
//          .document(channelName)
//          .collection(channelName)
//          .snapshots(),
//      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//        logger.d("stream value : ${snapshot.data.documents.length} ");
////        logger.d("chatId Id's  from chats : ${snapshot.data.documents.map((e) => e.data['chatId'])} ");
//
//        if (!snapshot.hasData) {
//          return Center(
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                mStatlessWidgets().mLoading(),
//              ],
//            ),
//          );
//        } else if (snapshot.hasError) {
//          logger.d('u have error in future');
//        } else if (snapshot.data.documents.length == 0) {
//          return Center(
//            child: Text('No Chats'),
//          );
//        }
//        return ListView.builder(
//          physics: NeverScrollableScrollPhysics(),
//          itemCount: snapshot.data.documents.length,
//          shrinkWrap: true,
//          itemBuilder: (context, i) {
//            var txt =
//                snapshot.data.documents.map((e) => e.documentID).toString();
//
//            texts = [];
//            String tx = txt;
//            Text text = Text(tx);
//            texts.add(text);
//            return Column(children: texts);
//            return chatRow(screenSize);
//          },
//        );
//      },
//    );
//  }

//  Widget mListData(BuildContext context, Post2 post, User user) {
//    return StreamBuilder<QuerySnapshot>(
//      stream: publicpostsRef.snapshots(),
//      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> map) {
//        if (map.hasData) {
//          return mHebatList(context, map, user);
////          final names = map.data.documents;
////          List<Text> messagesWidgets = [];
////          for (var name in names) {
////            final txt = name.data['hName'];
////            final from = name.data['oName'];
////            final uiTxt = Text("$txt from $from");
//////            List<DocumentSnapshot> documents = map.data.documents;
////            names.forEach((docObject) {
////              postFromFuture = new Post2.fromDoc(docObject);
//////              post = postFromFuture;
//////              _docsList.clear();
////
//////              logger.d("${_docsList[index].hName}  + ${postFromFuture.oName}+ ${postFromFuture.hLocation}");
//////             final uiTxt =   Text("${_docsList[0].hName} + ${postFromFuture.hLocation}");
//////              messagesWidgets.add(uiTxt);
////            }
////            );
////          }
//
//        } else {
//          return Center(
//            child: mStatlessWidgets().mLoading(),
//          );
//        }
//      },
//    );
//  }

/// ======================================= BACKUP ================================================

//  Widget chatRow(BuildContext context, txt, {DocumentSnapshot document}) {
//    var fUser = Provider.of<FirebaseUser>(context);
//
////    var fUser = Provider.of<FirebaseUser>(context);
////    if (fUser.uid == widget.currentUserId) {
////      return Container(
////        height: 400,
////        color: Colors.yellow,
////      );
////    } else {
//
//    return Container(
//      child: Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Column(
//          children: <Widget>[
//            Container(
//              width: double.infinity,
//              child: Visibility(
//                visible: true,
//                child: Card(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: new BorderRadius.circular(2.0),
//                  ),
//                  child: Stack(
//                    children: <Widget>[
//                      Align(
//                        alignment: AlignmentDirectional.center,
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Align(
//                              child: Padding(
//                                padding: const EdgeInsets.only(right: 8.0),
//                                child: Container(
//                                  child: Row(
//                                    mainAxisAlignment:
//                                        MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      Row(
//                                        mainAxisAlignment:
//                                            MainAxisAlignment.center,
//                                        children: <Widget>[
//                                          /// Icons
//                                          Container(
//                                            child: IconButton(
//                                              icon: Icon(
//                                                CupertinoIcons.left_chevron,
//                                                color: Colors.black54,
//                                                size: 16,
//                                              ),
//                                              onPressed: () {},
//                                            ),
//                                          ),
//
////                                            Container(
////                                              child: Align(
////                                                alignment:
////                                                    AlignmentDirectional.center,
////                                                child: Padding(
////                                                  padding: const EdgeInsets
////                                                          .symmetric(
////                                                      vertical: 8.0,
////                                                      horizontal: 8.0),
////                                                  child: Container(
////                                                    width: 20,
////                                                    child: IconButton(
////                                                      icon: Icon(
////                                                        FontAwesomeIcons.flag,
////                                                        color: Colors.black54,
////                                                        size: 16,
////                                                      ),
////                                                      onPressed: () {},
////                                                    ),
////                                                  ),
////                                                ),
////                                              ),
////                                            ),
//                                        ],
//                                      ),
//
//                                      /// Space
//                                      Padding(
//                                        padding: const EdgeInsets.all(1.0),
//                                        child: Container(
//                                          child: SizedBox(
//                                            width: 10,
//                                          ),
//                                        ),
//                                      ),
//
//                                      Row(
//                                        children: <Widget>[
//                                          Padding(
//                                            padding: const EdgeInsets.all(1.0),
//                                            child: Align(
//                                              alignment:
//                                                  AlignmentDirectional.center,
//                                              child: Container(
//                                                child: Text(
//                                                  txt,
//                                                  maxLines: 1,
//                                                  style: TextStyle(
//                                                      fontSize: 11,
//                                                      fontWeight:
//                                                          FontWeight.bold),
//                                                ),
//                                              ),
//                                            ),
//                                          ),
//                                          Padding(
//                                            padding: const EdgeInsets.all(1.0),
//                                            child: Align(
//                                              alignment:
//                                                  AlignmentDirectional.center,
//                                              child: Container(
//                                                child: CircleAvatar(
//                                                  radius: 15.0,
//                                                  backgroundColor: Colors.white,
//                                                  backgroundImage: fUser
//                                                          .photoUrl.isEmpty
//                                                      ? AssetImage(
//                                                          'assets/images/user_placeholder.jpg')
//                                                      : CachedNetworkImageProvider(
//                                                          fUser.photoUrl),
//                                                ),
//                                              ),
//                                            ),
//                                          ),
//                                        ],
//                                      )
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//class ChatList extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder(
//      stream: activeUsersRef.document(loggedInUserID).collection('messagedUsers').orderBy('timestamp', descending: true).snapshots(),
//      builder: (context, snapshot){
//
//        if(!snapshot.hasData || gotAsyncInfo == false || gotContactsInfo == false || getSharedPrefInfo == false){
//          return Container();
//        }
//
//        return StreamBuilder(
//          stream: Firestore.instance.collection('users').snapshots(),
//          builder: (context, snapshot2){
//            if(!snapshot2.hasData || gotAsyncInfo == false || gotContactsInfo == false || getSharedPrefInfo == false){
//              return Container(
//                color: Colors.transparent,
//              );
//            }
//
//            final messagedUsers = snapshot.data.documents;
//            List<MessagedContactsWidget> listOfMessagedContactsWidget = [];
//            for(var users in messagedUsers){
//              final String userPhoneNumber = users.data['phoneNumber'];
//              var listOfDocuments = snapshot2.data.documents;
//              for(var dc in listOfDocuments){
//                if(dc["phoneNumber"]==userPhoneNumber)
//                {
//                  downloadUrlFinal = dc["imageDownloadUrl"];
//                  bioOfUser = dc["bio"];
//                  receiverToken = dc['token'];
//                }
//              }
//              final String receiverID = users.data['receiverID'];
//
//              String mostRecentText = users.data['mostRecentMessage'];
//              if(mostRecentText.length>42){
//                mostRecentText = mostRecentText.substring(0,42);
//              }
//              for(int index = 0; index < contactsList.length; index++){
//                phoneNumberAtIndex = (contactsList[index].phones.isEmpty) ? ' ' : contactsList[index].phones.firstWhere((anElement) => anElement.value != null).value;
//                String trimmedPhoneNumber = phoneNumberAtIndex.split(" ").join("");
//                trimmedPhoneNumber = trimmedPhoneNumber.split("-").join("");
//                if(userPhoneNumber == trimmedPhoneNumber || userPhoneNumber.substring(3) == trimmedPhoneNumber){
//                  userName = contactsList[index].displayName;
//                  if(contactedUserNames.length!=0){
//                    counter = 0;
//                    for(int i=0;i<contactedUserNames.length;i++){
//                      if(contactedUserNames[i]==userName){
//                        counter++;
//                        break;
//                      }
//                    }
//                    if(counter==0){
//                      contactedUserNames.add(userName);
//                      userInfoForSearch[userName] = [trimmedPhoneNumber.toString(), downloadUrlFinal, receiverID, mostRecentText, bioOfUser, receiverToken];
//                    }
//                  }
//                  else{
//                    contactedUserNames.add(userName);
//                    userInfoForSearch[userName] = [trimmedPhoneNumber.toString(), downloadUrlFinal, receiverID, mostRecentText, bioOfUser, receiverToken];
//                  }
//                  break;
//                }
//                else{
//                  userName = userPhoneNumber;
//                }
//              }
//
//              isUserNameActuallyNumber = isNumeric(userName);
//              var messagedContact;
//              if(isUserNameActuallyNumber == true){
//                messagedContact = MessagedContactsWidget(phoneNumber: userPhoneNumber, userID: receiverID, downloadUrl: downloadUrlFinal,mostRecentMessage: mostRecentText, bio: bioOfUser, token: receiverToken,);
//              }
//              else{
//                messagedContact = MessagedContactsWidget(contactName: userName, phoneNumber: userPhoneNumber, userID: receiverID, downloadUrl: downloadUrlFinal, mostRecentMessage: mostRecentText, bio: bioOfUser, token: receiverToken,);
//              }
//
//
//
//              listOfMessagedContactsWidget.add(messagedContact);
//            }
//
//            return Expanded(
//              child: SingleChildScrollView(
//                child: Column(
//                  children: listOfMessagedContactsWidget,
//                ),
//              ),
//            );
//
//
//          },
//        );
//
//
//
//      },
//
//    );
//  }
//}
//
//class MessagedContactsWidget extends StatelessWidget {
//  final String contactName;
//  final String phoneNumber;
//  final String userID;
//  final String downloadUrl;
//  final String mostRecentMessage;
//  final String bio;
//  final String token;
//
//  MessagedContactsWidget({this.contactName = 'defaultName', this.phoneNumber, this.userID, this.downloadUrl, this.mostRecentMessage, this.bio, this.token});
//
//  @override
//  Widget build(BuildContext context) {
//    return GestureDetector(
//      onTap: ()=> openChatScreen(contactName, phoneNumber, userID, context, this.downloadUrl, this.bio, this.token),
//      child: Column(
//        children: <Widget>[
//          ListTile(
//            leading: (this.downloadUrl == 'NoImage' || this.downloadUrl == null)
//                ? CircleAvatar(child: Image.asset('images/blah.png'), radius: 23,)
//                :   CircleAvatar(
//              backgroundColor: Theme.of(context).accentColor,
//              radius: 23,
//              child: ClipOval(
//                child: CachedNetworkImage(
//                  fadeInCurve: Curves.easeIn,
//                  fadeOutCurve: Curves.easeOut,
//                  imageUrl: this.downloadUrl,
//                  placeholder: (context, url) => spinkit(),
//                  errorWidget: (context, url, error) => new Icon(Icons.error),
//                ),
//              ),
//            ),
//
//            title: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                (contactName == 'defaultName') ? Text(phoneNumber, style: TextStyle(fontSize: 20), textAlign: TextAlign.start,) : Text(contactName, style: TextStyle(fontSize: 20),),
//                SizedBox(
//                  height: 3,
//                ),
//                Text(mostRecentMessage,
//                  style: TextStyle(fontSize: 15, color: Colors.black54,),
//                  textAlign: TextAlign.start,
//                ),
//              ],
//            ),
//          ),
//          Container(
//            width: MediaQuery.of(context).size.width*0.9,
//            child: Divider(
//              height: 13,
//              thickness: 0.4,
//              indent: MediaQuery.of(context).size.width*0.14,
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
//  Widget chatRoomList() {
//    return StreamBuilder<QuerySnapshot>(
//        stream: usersRef.snapshots(),
//        builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
//          if (!userSnapshot.hasData) {
//            return mStatlessWidgets().mLoading();
//
//          }
//
//          return StreamBuilder<QuerySnapshot>(
//            initialData: empty,
//            stream: chatListStream,
//            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//              logger.d("stream value : ${snapshot.data.documents.length} ");
//
//              if (snapshot.connectionState == ConnectionState.waiting) {
//                return mStatlessWidgets().mLoading();
//              }
//              if (!snapshot.hasData) {
//                return Center(
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      mStatlessWidgets().mLoading(),
//                    ],
//                  ),
//                );
//              } else if (snapshot.hasError) {
//                logger.d('u have error in future');
//              } else if (snapshot.data.documents.length == 0) {
//                return Center(
//                  child: Text('No Chats'),
//                );
//              }
//
//
//              return ListView.builder(
//                physics: NeverScrollableScrollPhysics(),
////                itemCount: snapshot.data.documents.length,
//                itemCount: users.length,
//                shrinkWrap: true,
//                itemBuilder: (context, i) {
//                  return Card(
//                    child: ListTile(
//                      subtitle: Text("${i.toString()}"),
//                      leading: Padding(
//                        padding: const EdgeInsets.all(1.0),
//                        child: Container(
//                          color: Colors.white,
//                          child: CircleAvatar(
//                            radius: 15.0,
//                            backgroundColor: Colors.cyan,
//                          ),
////                                                ),
//                        ),
//                      ),
//                      title: Text("${users[i].name ?? "SS"}"),
//                    ),
//                  );
//
////                  final docs = snapshot.data.documents;
////                  final List<String> chatRoomIDS = [];
////                  List<User> users = [];
////                  final List<Widget> rows = [];
////                  Widget row2;
////                  docs.forEach((element) {
////                    chatId = element.data['chatRoomId'];
////                    final uid = getChattingWith(chatId);
////                    var chattingWith = getUserFromUid(uid);
////                    chatRoomIDS.add(chatId);
////                    logger.d(' chatRoomIDS : ${chatRoomIDS.length}');
////
////                    users.add(chattingWith);
////                    logger.d(' USERS : ${users.length}');
////                    row2 = chatRow2(user: users, i: i);
////                  });
////                  logger.d("chatRoomIDS:  ${chatRoomIDS.length}");
////                  rows.add(row2);
////
////                  return row2;
//                },
//              );
////              return ListView(
////                physics: NeverScrollableScrollPhysics(),
//////                itemCount: snapshot.data.documents.length,
////                shrinkWrap: true,
////                children: rows,
////              );
////            },
//
////                  var userInfo = getUserFromUid(chattingWith);
////                  var u = getUsersIds2(chattingWith);
////                  logger.d("u:  ${u.length}");
////
////                  users.add(userInfo);
//
////                  var txt = snapshot.data.documents
////                      .map((e) => e.documentID)
////                      .toString();
////
////                  texts = [];
////                  String tx = txt;
////                  Text text = Text(tx);
//////                  Text text2 = Text("${chat}");
////                  texts.add(text);
////                  return Column(children: texts);
//
////
////                  final messagedUsers = userSnapshot.data.documents;
////                  List<Container> listOfViewHolder = [];
////                  for (var userDoc in messagedUsers) {
////                    final String userUid = userDoc.data['uid'];
////                    var listOfDocuments = snapshot.data.documents;
////                    for (var dc in listOfDocuments) {
////                      if (dc["uid"] == userUid) {
////                        downloadUrlFinal = dc["imageDownloadUrl"];
////                        bioOfUser = dc["bio"];
////                        receiverToken = dc['token'];
////                      }
////                    }
////
////                  }
////                  users.add(user);
////                  logger.d("getStreamOfUsers  : ${users.length} ");m
////                  return Column(children: listOfViewHolder);
//            },
//          );
//        });
//  }
//  usersFromUid() async* {
//    var users1 = [];
//    chatListStream.forEach((element) {
//      var docss = element.documents;
//      docss.forEach((element) {
//        chatId = element.data['chatRoomId'];
//        var uid = getChattingWith(chatId);
//        var chattingWith = getUserFromUid(uid);
//        users1.add(chattingWith);
//        logger.d(' USERS : ${users.length}');
//        setState(() {
//          users = users1;
//        });
//      });
//    });
//    yield users;
//  }

/// ======================================== END ============================================

}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatScreen(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'OverpassRegular', fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName, textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'OverpassRegular', fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
