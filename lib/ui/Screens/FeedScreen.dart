/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:heba_project/models/post_model.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/ui/Views/post_view.dart';
import 'package:heba_project/ui/shared/ui_helpers.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';
  final String currentUserId;

  FeedScreen({this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _setupFeed();
  }

  _setupFeed() async {
    List<Post> posts = await DatabaseService.getFeedPosts(widget.currentUserId);
    setState(() {
      _posts = posts;
    });
  }

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
              'assets/images/myIcon.png',
              fit: BoxFit.scaleDown,
              scale: 3.0,
            ),
            UIHelper.horizontalSpace(10),
            Text(
              'HEBA-Project',
              style: TextStyle(
                  color: Colors.black45, fontFamily: ArabicFonts.Cairo),
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
        onRefresh: () => _setupFeed(),
        child: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (BuildContext context, int index) {
            Post post = _posts[index];
            return FutureBuilder(
              future: DatabaseService.getUserWithId(post.authorId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                }
                User author = snapshot.data;
                return PostView(
                  currentUserId: widget.currentUserId,
                  post: post,
                  author: author,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
