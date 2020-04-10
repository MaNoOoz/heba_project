/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/ui/shared/mAppbar.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  static final String id = 'chats_screen';

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  var _searchController = new TextEditingController();
  Future<QuerySnapshot> _chats;

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _chats = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;
    var user = Provider.of<FirebaseUser>(context);

    var _searchController = TextEditingController;
    return Scaffold(
      appBar: CustomAppBar(
        currentUserName: user.displayName,
        title: "المحادثات",
        IsBack: true,
        color: Colors.white,
        isImageVisble: true,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            searchFun2(),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return chatRow(screenSize);
              },
            ),
          ],
        ),
      ),

      /// SearchBar
    );
  }

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
                      _chats = DatabaseService.searchUsers(input);
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

  Widget searchFun2() {
    return Container(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                                                  fUser.displayName,
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
