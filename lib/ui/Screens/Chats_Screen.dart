/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/models/Chat.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/ui/shared/Assets.dart';
import 'package:heba_project/ui/shared/Constants.dart';
import 'package:heba_project/ui/shared/mAppbar.dart';
import 'package:heba_project/ui/widgets/mWidgets.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  static final String id = 'chats_screen';
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String currentUserId;

//  List<User> users;

//  const ChatsScreen({Key key, this.scaffoldKey}) : super(key: key);
  ChatsScreen({Key key, this.currentUserId, this.scaffoldKey})
      : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  /// search
  var _searchController = new TextEditingController();

//  Future<QuerySnapshot> _chats;
  List<Text> texts;

  CollectionReference _collectionReference;
  DocumentReference _documentReference;

  List<ChatModel> _chats;
  ChatModel mChat;

  String chatId;

  _clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _searchController.clear());
    setState(() {
//      _chats = null; // Future<QuerySnapshot> _chats;
      _chats = null;
    });
  }

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

  void init() async {
    print("init Called");
    print("init : ${widget.currentUserId.length} ");

    _collectionReference =
        CHATS.document(widget.currentUserId).collection("userChats");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
//          await DatabaseService.CreateFakeChatFuture(
//              _collectionReference, widget.currentUserId,);
          DatabaseService.checkForChange(widget.currentUserId);
        },
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: "المحادثات ",
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
            searchFun3(),
          ],
        ),
      ),
      body: buildFutureBuilder(),
//

      /// SearchBar
    );
  }

  Widget buildFutureBuilder() {
    var screenSize = MediaQuery
        .of(context)
        .size;

    return StreamBuilder<QuerySnapshot>(
      stream: _collectionReference.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        print("Future value : ${snapshot.data.documents.length} ");
        print("chatId Id's  from chats : ${snapshot.data.documents.map((e) => e
            .data['chatId'])} ");

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
            var txt = snapshot.data.documents.map((e) => e.documentID)
                .toString();

            texts = [];
            String tx = txt;
            Text text = Text(tx);
            texts.add(text);
            return chatRow(screenSize);
          },
        );
      },
    );
  }

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

  Widget searchFun() {
    return Container(
      height: 60,
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              autofocus: false,
              textDirection: TextDirection.rtl,
              onSubmitted: (input) {
                if (input.isNotEmpty) {
                  setState(
                        () {
//                      _chats = DatabaseService.searchUsers(input);
                    },
                  );
                }
              },
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: Icon(CupertinoIcons.search),
                hintText: "إبحث",
                hintStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
//                  color: Colors.grey.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ),
      ),
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
            onPressed: _clearSearch,
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

  Widget searchFun2() {
    return Container(
//      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 1.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: new TextFormField(
            autofocus: false,
            textDirection: TextDirection.rtl,
            decoration: new InputDecoration(
              labelText: "إبحث",

              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(5.0),
                borderSide: new BorderSide(),
              ),
              //fillColor: Colors.green
            ),
            validator: (val) {
              if (val.length == 0) {
                return "Email cannot be empty";
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.emailAddress,
            style: new TextStyle(
              fontFamily: "Poppins",
            ),
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
  Widget chatRow(var screenSize,) {
    var fUser = Provider.of<FirebaseUser>(context);

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
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
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
                                              alignment: AlignmentDirectional
                                                  .center,
                                              child: Container(
                                                child: Text(
                                                  fUser.displayName,
                                                  style: TextStyle(fontSize: 11,
                                                      fontWeight: FontWeight
                                                          .bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Align(
                                              alignment: AlignmentDirectional
                                                  .center,
                                              child: Container(
                                                child: CircleAvatar(
                                                  radius: 15.0,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: fUser
                                                      .photoUrl.isEmpty
                                                      ? AssetImage(
                                                      'assets/images/user_placeholder.jpg')
                                                      : CachedNetworkImageProvider(
                                                      fUser.photoUrl),
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
}
