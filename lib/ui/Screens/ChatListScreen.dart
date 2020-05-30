/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

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
  /// search
  var _searchController = new TextEditingController();

//  Future<QuerySnapshot> _chats;
  List<Text> texts;

//  CollectionReference _collectionReference;
//  DocumentReference _documentReference;
//  List<Chat> _chats;

  Chat mChat;

  String chatId;

  Stream<QuerySnapshot> chatListStream;

  String currentUserId;
  User chattingWithUser;

  FirebaseUser fUser;

//  _clearSearch() {
//    WidgetsBinding.instance
//        .addPostFrameCallback((_) => _searchController.clear());
//    setState(() {
////      _chats = null; // Future<QuerySnapshot> _chats;
////      _chats = null;
//    });
//  }

//  mChatsFromDb() async {
//    print("mChatsFromDb Called");
//
//    userChatsRefrance = contacts.document(widget.currentUserId).collection(chatId);
//
//    List<Chat> chats = [];
//    QuerySnapshot qn = await userChatsRefrance.getDocuments();
//
//    List<DocumentSnapshot> documents = qn.documents;
//    documents.forEach((DocumentSnapshot doc) {
//      mChat = new Chat.fromFiresore(doc);
//
////      print("DOC ${mChat.chatId}");
////      print("DOC ${chats.length_channelName      chats.add(mChat);
//    });
//
////    print("_setupPosts  ${mChat.chatId}");
//    print("mChatsFromDb  ${documents.length}");
//
////    setState(() {
////      _chats = chats;
////    });
//    return chats;
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();

//    mChatsFromDb();
  }

  init() async {
    print("init Called");
    print("init : ${widget.currentUserId.length} ");
    print("init : ${widget.currentUserId} ");
//    getStreamOfUsers();
//    getStreamOfChats();
    var s = getCurrentUserChats(widget.currentUserId).asStream();
    setState(() {
      chatListStream = s;
    });

//    await getUserFromUid(uid);

//    DatabaseService.checkForChange(widget.currentUserId);
//    var s = DatabaseService().chatsStream;
//    print("${s.map((event) => event.chatId ?? "SSS")}");
    print("getStreamOfChats3 : ${widget.currentUserId} ");

//   DatabaseService.ChatsFromStream(widget.currentUserId);
//    _collectionReference = CHATS.document(widget.currentUserId).collection(USERCHATS);
//    chatListStream = _collectionReference.snapshots();
  }

  var channelName = "123123123";

  String senderUserId = "";
  String reviverUserId = "";

  @override
  Widget build(BuildContext context) {
    currentUserId = Provider.of<UserData>(context).currentUserId;
    print("currentUserId value : $currentUserId ");

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
//          await DatabaseService.CreateFakeChatFuture(
//            channelName: channelName,
//            currentUserId: currentUserId,
////            reciver: reviver,
////            sender: sender,
//          );
        },
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
      body: chatRoomList(),
//

      /// SearchBar
    );
  }

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

  getStreamOfChats2() {
//    var pos =  DatabaseService().chatsStream;
//    pos.listen((event) {event.})
  }

  Future<QuerySnapshot> getCurrentUserChats(String chattingFromId) {
    return CHATS.where("users", arrayContains: chattingFromId).getDocuments();
  }

  Widget buildFutureBuilder() {
    var screenSize = MediaQuery.of(context).size;
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
            stream: CHATS
                .document(currentUserId)
                .collection(USERCHATS)
//
//                .document(channelName)
//                .collection(channelName)
                .snapshots(),
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

  List<User> getUsersIds2(String uid) {
    List<User> users = [];
    User user = getUserFromUid(uid);
    users.add(user);
    for (User u in users) {
      var name = u.name;
      print(name);
    }
    return users;
  }

  User getUserFromUid(String uid) {
//    User user;
    Query query;
    query = usersRef.where("uid", isEqualTo: uid);
    var s = query.snapshots();
    var users = [];
    s.forEach((element) {
      var docs = element.documents;
      for (var doc in docs) {
        print("query snapshots ${docs.length}");

        chattingWithUser = User.fromFirestore(doc);
        users.add(chattingWithUser);
        print("users ${users.length}");
      }
    });
    return chattingWithUser;
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

  Widget chatRoomList() {
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
            stream: chatListStream,
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
                  List<User> users = [];
                  var snapshots = [];
                  snapshots = snapshot.data.documents;
                  List<String> chatRoomIDS = [];

                  chatId = snapshot.data.documents[i].data['chatRoomId'];

                  chatRoomIDS.add(chatId);
//

                  var chattingWith = getChattingWith(chatId);
                  print("chatRoomIDS:  ${chatRoomIDS.length}");
                  var userInfo;
                  for (var snap in snapshots) {
                    userInfo = getUserFromUid(chattingWith);

                    print("userInfo:   ${userInfo}");
                  }
                  userInfo = getUserFromUid(chattingWith);

//                  var userInfo = getUserFromUid(chattingWith);
//                  var u = getUsersIds2(chattingWith);
//                  print("u:  ${u.length}");
//
//                  users.add(userInfo);

                  return chatRow2(screenSize, chattingWith);

//                  var txt = snapshot.data.documents
//                      .map((e) => e.documentID)
//                      .toString();
//
//                  texts = [];
//                  String tx = txt;
//                  Text text = Text(tx);
////                  Text text2 = Text("${chat}");
//                  texts.add(text);
//                  return Column(children: texts);

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
  String getChattingWith(String chatRoomId) {
    var chattinWith = chatRoomId
        .toString()
        .replaceAll("_", "")
        .replaceAll(widget.currentUserId.toString(), "");
    print("chatting From : ${widget.currentUserId}");
    print("chatting With : $chattinWith");
    return chattinWith;
  }

  Container chatRow(var screenSize, User user) {
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

  Widget chatRow2(var screenSize, String user) {
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
                                              padding: const EdgeInsets.all(
                                                  1.0),
                                              child: Align(
                                                alignment:
                                                AlignmentDirectional.center,
                                                child: Container(
                                                  child: Text(
                                                    user ?? "SS",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                  1.0),
                                              child: Align(
                                                alignment:
                                                AlignmentDirectional.center,
                                                child: Container(
                                                  color: Colors.amber,
//                                                child: CircleAvatar(
//                                                  radius: 15.0,
//                                                  backgroundColor: Colors.white,
//                                                  backgroundImage: user
//                                                          .profileImageUrl
//                                                          .isEmpty
//                                                      ? AssetImage(
//                                                          'assets/images/user_placeholder.jpg')
//                                                      : CachedNetworkImageProvider(
//                                                          user.profileImageUrl),
//                                                ),
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
}

///// todo
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
