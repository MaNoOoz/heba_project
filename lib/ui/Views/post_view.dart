/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/ui/shared/Assets.dart';

class PostView extends StatefulWidget {
  final String currentUserId;
  final HebaModel post;
  final User author;

  PostView({this.currentUserId, this.post, this.author});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  int _likeCount = 0;
  bool _isLiked = false;
  bool _heartAnim = false;

  @override
  void initState() {
    super.initState();
//    _likeCount = widget.post.;
//    _initPostLiked();
  }

//  @override
//  void didUpdateWidget(PostView oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (oldWidget.post.likes != widget.post.likes) {
//      _likeCount = widget.post.likes;
//    }
//  }

//  _initPostLiked() async {
//    bool isLiked = await DatabaseService.didLikePost(
//      currentUserId: widget.currentUserId,
//      post: widget.post,
//    );
//    if (mounted) {
//      setState(() {
//        _isLiked = isLiked;
//      });
//    }
//  }

//  _likePost() {
//    if (_isLiked) {
//      // Unlike Post
//      DatabaseService.unlikePost(
//          currentUserId: widget.currentUserId, post: widget.post);
//      setState(() {
//        _isLiked = false;
//        _likeCount = _likeCount - 1;
//      });
//    } else {
//      // Like Post
////      DatabaseService.likePost(
////          currentUserId: widget.currentUserId, post: widget.post);
//      setState(() {
//        _heartAnim = true;
//        _isLiked = true;
//        _likeCount = _likeCount + 1;
//      });
//      Timer(Duration(milliseconds: 350), () {
//        setState(() {
//          _heartAnim = false;
//        });
//      });
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            print("WTF U WANT !!!! ");
            print("STOP BUG  ME !! :) ");
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Row(
              children: <Widget>[
//
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: widget.author.profileImageUrl.isEmpty
                      ? AssetImage(AvailableImages.appIcon)
                      : CachedNetworkImageProvider(
                      widget.author.profileImageUrl),
                ),
                SizedBox(width: 8.0),
                Text(
                  widget.author.name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
//          onDoubleTap: _likePost,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              /// todo fix
              Container(
                height: 100,
                child: Image.asset(AvailableImages.appIcon),
              ),

//              Container(
//                height: 100,
//                decoration: BoxDecoration(
//                  image: DecorationImage(
//                    image: CachedNetworkImageProvider(
////                      widget.post.oImage,
//                      AvailableImages.appIcon,
//                      scale: 2,
//                    ),
////                    image: CachedNetworkImageProvider() ,
//                    fit: BoxFit.contain,
//                  ),
//                ),
//              ),
              _heartAnim
                  ? Animator(
                duration: Duration(milliseconds: 300),
                tween: Tween(begin: 0.5, end: 1.4),
                curve: Curves.elasticOut,
                builder: (anim) =>
                    Transform.scale(
                      scale: anim.value,
                      child: Icon(
                        Icons.favorite,
                        size: 100.0,
                        color: Colors.red[400],
                      ),
                    ),
              )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: _isLiked
                        ? Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                        : Icon(Icons.favorite_border),
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
                  '${_likeCount.toString()} likes',
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
                      widget.author.name,
                      style: TextStyle(
                        fontSize: 16.0,
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
    );
  }
}
