/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_model.dart';

class FeedView extends StatefulWidget {
  final HebaModel post;
  final User author;

  FeedView({
    this.post,
    this.author,
  });

  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Image.asset('assets/images/user_placeholder.jpg'),
                  ),
                ),
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: widget.post.imageUrls.isEmpty
                      ? AssetImage('assets/images/user_placeholder.jpg')
                      : AssetImage('assets/images/appicon.png'),
                ),
                SizedBox(width: 8.0),
                Text(
                  widget.post.hName,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
//          onDoubleTap: _likePost,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                /// todo fix

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            iconSize: 30.0,
//                    onPressed: _likePost,
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.comment),
                            iconSize: 30.0,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          widget.post.hDesc,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              left: 12.0,
                              right: 6.0,
                            ),
                            child: Text(
                              widget.post.location.address,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.post.hDesc,
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.0),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
