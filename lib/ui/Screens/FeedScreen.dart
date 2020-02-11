/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/ui/Views/post_view.dart';
import 'package:heba_project/ui/shared/UI_Helpers.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';
  final String currentUserId;

  FeedScreen({this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  List<Post2> _hebatList = [];

  User _profileUser;

  _setupProfileUser() async {
    final String currentUserId = Provider
        .of<UserData>(context)
        .currentUserId;

    User profileUser =
    await DatabaseService.getUserWithId(currentUserId);
    log("current profileUser id :  ${profileUser.id}");
    log("current profileUser id :  ${profileUser.email}");
    setState(() {
      _profileUser = profileUser;
    });
  }

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            padding: EdgeInsets.only(left: 30.0),
            onPressed: () => print('Menu'),
            icon: Icon(Icons.menu),
            iconSize: 30.0,
            color: Colors.black45),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/appicon.png',
              width: 32,
              height: 32,
              fit: BoxFit.scaleDown,
              scale: 3.0,
            ),
            UIHelper.horizontalSpace(10),
            Text(
              'هـبــة',
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.black45,
                  fontFamily: ArabicFonts.Cairo),
            ),
          ],
        ),
        actions: <Widget>[
//          IconButton(
//            padding: EdgeInsets.only(right: 10.0),
//            onPressed: () => print('Search'),
//            icon: Icon(Icons.more_vert),
//            iconSize: 30.0,
//            color: Colors.black,
//          ),
//          _setupProfileUser(),
          GestureDetector(
            onTap: () {
              print('object');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/myIcon.png',
                scale: 2.0,
              ),
            ),
//            child:Padding(
//              padding: const EdgeInsets.all(14.0),
//              child: CircleAvatar(
//                radius: 50.0,
//                backgroundColor: Colors.grey,
//                backgroundImage: _profileUser.profileImageUrl.isEmpty
//                    ? AssetImage('assets/images/user_placeholder.jpg')
//                    : CachedNetworkImage(imageUrl: _profileUser.profileImageUrl,),
//              ),
//            ),

//           child: CircleAvatar(
//              radius: 50.0,
//              backgroundColor: Colors.grey,
//              backgroundImage: _profileUser.profileImageUrl.isEmpty
//                  ? AssetImage('assets/images/myIcon.png')
//                  : CachedNetworkImageProvider(_profileUser.profileImageUrl),
//            ),
          ),
        ],
      ),

      // TODO: implement build
      body: ListView.builder(
        itemCount: _hebatList.length,
        itemBuilder: (BuildContext context, int index) {
          Post2 post = _hebatList[index];

          return Column(
            children: <Widget>[
              FutureBuilder(
                future: DatabaseService.getUserWithId(post.authorId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Text("sss");
                  }
                  User author = snapshot.data;

//            Post2 post2 = Post2(
//                imageUrls: [],
//                hName: "_name",
//                hDesc: "_desc",
//                hLocation: "_location",
//                authorId: Provider.of<UserData>(context).currentUserId,
//                timestamp: Timestamp.fromDate(DateTime.now()));

                  return PostView(
                    currentUserId: widget.currentUserId,
                    post: post,
                    author: author,
                  );
                },
              ),
              FutureBuilder(
                future: DatabaseService.getUserPosts(post.authorId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Text("sss");
                  }
                  User author = snapshot.data;

//            Post2 post2 = Post2(
//                imageUrls: [],
//                hName: "_name",
//                hDesc: "_desc",
//                hLocation: "_location",
//                authorId: Provider.of<UserData>(context).currentUserId,
//                timestamp: Timestamp.fromDate(DateTime.now()));

                  return PostView(
                    currentUserId: widget.currentUserId,
                    post: post,
                    author: author,
                  );
                },
              ),
              Text("Hi "),
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
//    _setupFeed();
//    _setupProfileUser();

  }

  _setupFeed() async {
    List<Post2> posts =
    await DatabaseService.getFeedPosts2(widget.currentUserId);
    setState(() {
      _hebatList = posts;
    });
  }

  _bulidPost(Post2 post2, User user) {
    return Container(
      height: 50,
      width: 50,
      margin: EdgeInsets.all(10),
      color: Colors.red,
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    String currentUserId = Provider.of<UserData>(context).currentUserId;
//    String postID = Provider.of<Post2>(context).authorId;
//
//    return Scaffold(
//      backgroundColor: Colors.amber,
//      appBar: AppBar(
//        leading: IconButton(
//            padding: EdgeInsets.only(left: 30.0),
//            onPressed: () => print('Menu'),
//            icon: Icon(Icons.menu),
//            iconSize: 30.0,
//            color: Colors.black45),
//        centerTitle: true,
//        backgroundColor: Colors.white,
//        title: Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Image.asset(
//              'assets/images/appicon.png',
//              width: 32,
//              height: 32,
//              fit: BoxFit.scaleDown,
//              scale: 3.0,
//            ),
//            UIHelper.horizontalSpace(10),
//            Text(
//              'هبــة',
//              style: TextStyle(
//                  fontSize: 32,
//                  color: Colors.black45,
//                  fontFamily: ArabicFonts.Cairo),
//            ),
//          ],
//        ),
//        actions: <Widget>[
////          IconButton(
////            padding: EdgeInsets.only(right: 10.0),
////            onPressed: () => print('Search'),
////            icon: Icon(Icons.more_vert),
////            iconSize: 30.0,
////            color: Colors.black,
////          ),
//          GestureDetector(
//            onTap: () {
//              print('object');
//            },
//            child: Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Image.asset(
//                'assets/images/myIcon.png',
//                scale: 2.0,
//              ),
//            ),
//          ),
//        ],
//      ),
//      body: RefreshIndicator(
//        backgroundColor: Colors.amber,
//        color: Colors.blueAccent,
//        onRefresh: () {
//          print("${_posts.length}");
//
//          return _setupFeed();
//        },
//        child: ListView.builder(
//          itemCount: _posts.length,
//          itemBuilder: (BuildContext context, int index) {
//            Post2 post = _posts[index];
//            return FutureBuilder(
//              future: DatabaseService.getUserWithId(postID),
//              builder: (BuildContext context, AsyncSnapshot snapshot) {
//                if (!snapshot.hasData) {
//                  return SizedBox.shrink();
//                }
//                User author = snapshot.data;
//                return PostView(
//                  currentUserId: postID,
//                  post: post,
//                  author: author,
//                );
//              },
//            );
//          },
//        ),
//      ),
//    );
//  }
}
//class _FeedScreenState extends State<FeedScreen> {
//  List<Post2> _posts = [];
//
//  @override
//  void initState() {
//    super.initState();
//    _setupFeed();
//  }
//
//  _setupFeed() async {
//    List<Post2> posts = await DatabaseService.getFeedPosts2(widget.currentUserId);
//    setState(() {
//      _posts = posts;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.white,
//        title: Text(
//          'Instagram',
//          style: TextStyle(
//            color: Colors.black,
//            fontFamily: 'Billabong',
//            fontSize: 35.0,
//          ),
//        ),
//      ),
//      body: RefreshIndicator(
//        onRefresh: () => _setupFeed(),
//        child: ListView.builder(
//          itemCount: _posts.length,
//          itemBuilder: (BuildContext context, int index) {
//            Post post = _posts[index];
//            return FutureBuilder(
//              future: DatabaseService.getUserWithId(post.authorId),
//              builder: (BuildContext context, AsyncSnapshot snapshot) {
//                if (!snapshot.hasData) {
//                  return SizedBox.shrink();
//                }
//                User author = snapshot.data;
//                return PostView(
//                  currentUserId: widget.currentUserId,
//                  post: post,
//                  author: author,
//                );
//              },
//            );
//          },
//        ),
//      ),
//    );
//  }
//}

