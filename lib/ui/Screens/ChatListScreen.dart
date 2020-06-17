/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/models/Chat.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/ui/Screens/ChatScreen.dart';
import 'package:heba_project/ui/shared/Assets.dart';
import 'package:heba_project/ui/shared/Constants.dart';
import 'package:heba_project/ui/shared/helperFuncs.dart';
import 'package:heba_project/ui/shared/mAppbar.dart';
import 'package:heba_project/ui/widgets/mWidgets.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  static final String id = 'ChatListScreen';
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String currentUserId;
  final String userID;

  ChatListScreen({Key key, this.currentUserId, this.scaffoldKey, this.userID})
      : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  /// vars ==================================================

  var _searchController = new TextEditingController();
  List<Text> texts;
  Chat mChat;
  String chatId;
  User toUser;
  QuerySnapshot empty;
  Stream<QuerySnapshot> chatListStream;
  String currentUserId;
  FirebaseUser fUser;
  StreamController<User> streamController;
  List<User> users = [];

  /// vars ===================================================

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    streamController?.close();
    streamController = null;
  }

  init() async {
    print("init Called");
    print("init : ${widget.currentUserId.length} ");
    print("init : ${widget.currentUserId} ");
    var status = await helperFunctions.checkNetwork();
    if (status == true) {
      print("NetWork is  :$status");
    } else {
      print("NetWork is  :$status");
    }
    chatListStream = getCurrentUserChats(widget.currentUserId).asStream();
    streamController = StreamController.broadcast();
    streamController.stream.listen((event) {
      setState(() {
        users.add(event);
      });
    });
    var users3 = await load(streamController);
    setState(() {
      users = users3;
    });

    print("init : ${users.length}");
  }

  Future<List<User>> load(StreamController<User> streamController) async {
    return await chatListStream
        .expand((element) => element.documents)
        .map((event) => User.fromFirestore(event))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    currentUserId = Provider.of<UserData>(context).currentUserId;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: "المحادثات",
              IsBack: false,
              color: Colors.white,
              isImageVisble: true,
              flexColor: Colors.black12,
            ),
            Divider(
              height: 10,
              thickness: 12,
              color: Colors.green.withAlpha(32),
            ),
//            searchFun3(),
          ],
        ),
      ),
//      body: chatRoomList2(toUser: toUser,chatId: chatId,chatListStream: chatListStream,currentUserId: currentUserId,),
      body: chatRoomList(),
//

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
        print("getStreamOfUsers  : ${users.length} ");
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

  getUsersIds() async {
    List<String> userIds = [];
    var qn = usersRef.snapshots();
    await for (var userSnapshot in qn) {
      var docs = userSnapshot.documents;
      for (var doc in docs) {
        List<Map> ids = doc.data['uid'];
        print("getUsersIds  : ${ids.length} ");

//        User sender = User(uid: );
//        User reviver = User();
//        User user = new User.fromFirestore(doc);
//        userIds.add(uid);
//        print("getStreamOfUsers  : ${users.length} ");
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

  getStreamOfChats() async {
//    List<User> users = [];
    var qn = CHATS.document(currentUserId).collection(USERCHATS).snapshots();
    await for (var userSnapshot in qn) {
      for (var doc in userSnapshot.documents) {
//        User user = new User.fromFirestore(doc);
//        users.add(user);
        print("getStreamOfChats  : ${userSnapshot.documents.length} ");
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


  Future<QuerySnapshot> getCurrentUserChats(String chattingFromId) {
    return CHATS.where("users", arrayContains: chattingFromId).getDocuments();
  }

  User getUserFromUid(String uid) {
    print("getUserFromUid Called ");

    Query query;
    query = usersRef.where("uid", isEqualTo: uid);
    var s = query.snapshots();
//    var users = [];
    s.forEach((element) {
      var docs = element.documents;
      for (var doc in docs) {
        print("docs in user ref: ${docs.length}");

        toUser = User.fromFirestore(doc);
//        users.add(chattingWithUser);
//        print("users ${users.length}");
      }
    });

    return toUser;
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

  List<User> getUserFrom(String uid) {
    print("getUserFromUid Called ");

    Query query;
    query = usersRef.where("uid", isEqualTo: uid);
    var s = query.snapshots();
    List<User> users = [];
    s.forEach((element) {
      var docs = element.documents;
      for (var doc in docs) {
        print("docs in user ref: ${docs.length}");

        toUser = User.fromFirestore(doc);
        users.add(toUser);
        print("usersss ${users.length}");
      }
    });

    return users;
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

  String getChattingWith(String chatRoomId) {
    print("getChattingWith Called ");

    var chattinWith = chatRoomId
        .toString()
        .replaceAll("_", "")
        .replaceAll(widget.currentUserId.toString(), "");
    print("chatting From : ${widget.currentUserId}");
    print("chatting With : $chattinWith");
    return chattinWith;
  }

  /// ========================================= WIDGETS ============================================

  Widget buildFutureBuilder() {
    var screenSize = MediaQuery
        .of(context)
        .size;
//    var chat = Provider.of<Chat>(context).chatId;
    QuerySnapshot empty;
    return StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
          if (!userSnapshot.hasData) {
            return Container(
              color: Colors.amber,
            );
          }

          return StreamBuilder<QuerySnapshot>(
            initialData: empty,
            stream:
            CHATS.document(currentUserId).collection(USERCHATS).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              print("stream value : ${snapshot.data.documents.length} ");
//        print("chatId Id's  from chats : ${snapshot.data.documents.map((e) => e.data['chatId'])} ");

              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      mStatlessWidgets().mLoading(),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                print('u have error in future');
              } else if (snapshot.data.documents.length == 0) {
                return Center(
                  child: Text('No Chats'),
                );
              }
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  var txt = snapshot.data.documents
                      .map((e) => e.documentID)
                      .toString();

                  texts = [];
                  String tx = txt;
                  Text text = Text(tx);
//                  Text text2 = Text("${chat}");
                  texts.add(text);
                  return Column(children: texts);
//                  return chatRow(screenSize);
//
//                  final messagedUsers = userSnapshot.data.documents;
//                  List<Container> listOfViewHolder = [];
//                  for (var userDoc in messagedUsers) {
//                    final String userUid = userDoc.data['uid'];
//                    var listOfDocuments = snapshot.data.documents;
//                    for (var dc in listOfDocuments) {
//                      if (dc["uid"] == userUid) {
//                        downloadUrlFinal = dc["imageDownloadUrl"];
//                        bioOfUser = dc["bio"];
//                        receiverToken = dc['token'];
//                      }
//                    }
//
//                  }
//                  users.add(user);
//                  print("getStreamOfUsers  : ${users.length} ");m
//                  return Column(children: listOfViewHolder);
                },
              );
            },
          );
        });
  }

  Widget chatRoomList() {
    return FutureBuilder<List<User>>(
      future: load(streamController),
      builder: (context, snapshot) {
        print("FutureBuilder  : ${users.length} ");
        print("FutureBuilder  : ${users.map((e) => e.name)} ");


        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: users.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            print("itemBuilder  : ${users[i].name} ");

            return Card(
              child: ListTile(
                subtitle: Text("${i.toString()}"),
                leading: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    color: Colors.white,
                    child: CircleAvatar(
                      radius: 15.0,
                      backgroundColor: Colors.cyan,
                    ),
//                                                ),
                  ),
                ),
                title: Text("${users[i].name ?? "SS"}"),
              ),
            );
          },
        );
      },

    );
  }

  Widget searchFun3() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: CustomColors.unselectedCardColor,
      ),
      child: TextField(
        onChanged: (input) {
          if (input.isNotEmpty) {
            setState(() {
//              _users = DatabaseService.searchUsers(input);
            });
          }
        },
//        onSubmitted: (input) {
//          if (input.isNotEmpty) {
//            setState(() {
//              _users = DatabaseService.searchUsers(input);
//            });
//          }
//        },
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search for name",
          hintStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey.withOpacity(0.6),
          ),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              CupertinoIcons.clear,
              size: 30.0,
            ),
//            onPressed: _clearSearch,
          ),
          filled: true,
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: Colors.black,
            size: 30.0,
          ),
        ),
      ),
    );
  }

  Widget chatRow(var screenSize, User user) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              width: screenSize.width,
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
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
                                              alignment:
                                              AlignmentDirectional.center,
                                              child: Container(
                                                child: Text(
                                                  user.name ?? "SS",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Align(
                                              alignment:
                                              AlignmentDirectional.center,
                                              child: Container(
                                                child: CircleAvatar(
                                                  radius: 15.0,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: user
                                                      .profileImageUrl
                                                      .isEmpty
                                                      ? AssetImage(
                                                      'assets/images/user_placeholder.jpg')
                                                      : CachedNetworkImageProvider(
                                                      user.profileImageUrl),
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
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              padding:
                                              const EdgeInsets.all(1.0),
                                              child: Align(
                                                alignment:
                                                AlignmentDirectional.center,
                                                child: Container(
                                                  child: Text(
                                                    user[i].name ?? "SS",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(1.0),
                                              child: Align(
                                                alignment:
                                                AlignmentDirectional.center,
                                                child: Container(
                                                  color: Colors.white,
                                                  child: CircleAvatar(
                                                    radius: 15.0,
                                                    backgroundColor:
                                                    Colors.white,
                                                    backgroundImage: user[i]
                                                        .profileImageUrl
                                                        .isEmpty
                                                        ? AssetImage(
                                                        'assets/images/user_placeholder.jpg')
                                                        : CachedNetworkImageProvider(
                                                        user[i]
                                                            .profileImageUrl),
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
//        print("stream value : ${snapshot.data.documents.length} ");
////        print("chatId Id's  from chats : ${snapshot.data.documents.map((e) => e.data['chatId'])} ");
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
//          print('u have error in future');
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
//////              print("${_docsList[index].hName}  + ${postFromFuture.oName}+ ${postFromFuture.hLocation}");
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
//              print("stream value : ${snapshot.data.documents.length} ");
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
//                print('u have error in future');
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
////                    print(' chatRoomIDS : ${chatRoomIDS.length}');
////
////                    users.add(chattingWith);
////                    print(' USERS : ${users.length}');
////                    row2 = chatRow2(user: users, i: i);
////                  });
////                  print("chatRoomIDS:  ${chatRoomIDS.length}");
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
////                  print("u:  ${u.length}");
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
////                  print("getStreamOfUsers  : ${users.length} ");m
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
//        print(' USERS : ${users.length}');
//        setState(() {
//          users = users1;
//        });
//      });
//    });
//    yield users;
//  }

/// ======================================== END ============================================

}
