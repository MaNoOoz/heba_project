/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/ui/Views/FeedView.dart';
import 'package:heba_project/ui/Views/post_view.dart';
import 'package:heba_project/ui/shared/Constants.dart';
import 'package:heba_project/ui/shared/UI_Helpers.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
//  todo 1 - change firebase schema to add posts to public wall "check"
//  todo 2 - get  posts from public wall
  static final String id = 'feed_screen';
  final String currentUserId;

  FeedScreen({this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  List<Post2> _hebatList = [];
  int _displayPosts = 0; // 0 - grid, 1 - column
  User _profileUser;

  _setupProfileUser() async {
    final String currentUserId = Provider
        .of<UserData>(context)
        .currentUserId;

    User profileUser = await DatabaseService.getUserWithId(currentUserId);
    log("current profileUser id :  ${profileUser.id}");
    log("current profileUser id :  ${profileUser.email}");
    setState(() {
      _profileUser = profileUser;
    });
  }

//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
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
//              'هـبــة',
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
////          _setupProfileUser(),
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
////            child:Padding(
////              padding: const EdgeInsets.all(14.0),
////              child: CircleAvatar(
////                radius: 50.0,
////                backgroundColor: Colors.grey,
////                backgroundImage: _profileUser.profileImageUrl.isEmpty
////                    ? AssetImage('assets/images/user_placeholder.jpg')
////                    : CachedNetworkImage(imageUrl: _profileUser.profileImageUrl,),
////              ),
////            ),
//
////           child: CircleAvatar(
////              radius: 50.0,
////              backgroundColor: Colors.grey,
////              backgroundImage: _profileUser.profileImageUrl.isEmpty
////                  ? AssetImage('assets/images/myIcon.png')
////                  : CachedNetworkImageProvider(_profileUser.profileImageUrl),
////            ),
//          ),
//        ],
//      ),
//
//      body: RefreshIndicator(
//        onRefresh: () => _setupFeed(),
//        child: ListView.builder(
//            itemCount: _hebatList.length,
//            itemBuilder: (BuildContext context, int index) {
//              print("${_hebatList.length}");
//              _setupProfileUser();
//
//              Post2 post = _hebatList[index];
//
//              return FutureBuilder(
//                future: DatabaseService.getUserWithId(post.authorId),
//                builder: (BuildContext context, AsyncSnapshot snapshot) {
//                  if (snapshot.hasData) {
////                    print(" currentUserId : ${snapshot.data}");
//
//                    return Text("sss");
//                  }
//                  User author = snapshot.data;
//
////            Post2 post2 = Post2(
////                imageUrls: [],
////                hName: "_name",
////                hDesc: "_desc",
////                hLocation: "_location",
////                authorId: Provider.of<UserData>(context).currentUserId,
////                timestamp: Timestamp.fromDate(DateTime.now()));
//
//                  return PostView(
//                    currentUserId: widget.currentUserId,
//                    post: post,
//                    author: author,
//                  );
//                },
//              );
//            }),
//      ),
//
////            return Column(
////              children: <Widget>[
////
////
////              ],
//    );
//  }

  @override
  void initState() {
    super.initState();
    _setupFeed();
  }

  _setupFeed() async {
    List<Post2> posts = await DatabaseService.getAllPosts2();

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

  void printData() {
    publicpostsRef.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = Provider
        .of<UserData>(context)
        .currentUserId;
//    String postID = Provider.of<Post2>(context).authorId;

    return Scaffold(
      backgroundColor: Colors.white,
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
              'هبــة',
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
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          print("_hebatList Size : ${_hebatList.length}");
          print("${widget.currentUserId}");
          printData();

          return _setupFeed();
        },
        child: ListView(
          children: <Widget>[

            _buildDisplayPosts(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: _hebatList.length,
                itemBuilder: (BuildContext context, int index) {
                  Post2 post = _hebatList[index];
                  return FutureBuilder(
                    future: DatabaseService.getAllPosts(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox.shrink();
                      }
                      User author = snapshot.data;
                      return FeedView(
                        post: post,
                        author: author,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// getImagesUrls
  List<dynamic> _getListOfImagesFromUser(Post2 post2) {
    dynamic list = post2.imageUrls;
    return list;
  }

  _buildTilePost2(Post2 post) {
    var listFromFirebase = _getListOfImagesFromUser(post);
    return GridTile(
      child: ListView.builder(
          itemCount: listFromFirebase == null ? 0 : listFromFirebase.length,
          padding: EdgeInsets.all(14.0),
          itemBuilder: (BuildContext context, int postion) {
            return ListTile(
              title: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.grey,
                backgroundImage: post.imageUrls.isEmpty
                    ? AssetImage('assets/images/user_placeholder.jpg')
                    : CachedNetworkImageProvider(post.imageUrls.toString()),
              ),
//              leading: Text("${post.imageUrls}"),
//              subtitle: Text("${post.hName}"),
            );
          }),
//
//      child: Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Image(
//          image: post.imageUrls.isEmpty
//              ? AssetImage('assets/images/user_placeholder.jpg')
////          todo fix image Url
//              : CachedNetworkImageProvider(post.imageUrls.toString()),
//        ),
//      ),
    );
  }

  _buildDisplayPosts() {
    if (_displayPosts == 0) {
      // Grid
      List<GridTile> tiles = [];
      _hebatList.forEach(
            (post) => tiles.add(_buildTilePost2(post)),
      );
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      // Column
      List<PostView> postViews = [];
      _hebatList.forEach((post) {
        postViews.add(
          PostView(
            currentUserId: widget.currentUserId,
            post: post,
            author: _profileUser,
          ),
        );
      });
      return Column(children: postViews);
    }
  }

}
