/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/ui/Screens/HebaDetails.dart';
import 'package:heba_project/ui/shared/Assets.dart';
import 'package:heba_project/ui/tester/imageSliderExample.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'CustomWidgets.dart';

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

  List<dynamic> _getListOfImagesFromUser(HebaModel post2) {
    dynamic list = post2.imageUrls;
    return list;
  }

  Widget rowView(HebaModel post) {
    var fUser = Provider.of<FirebaseUser>(context).displayName;
    var fImage = Provider.of<FirebaseUser>(context).photoUrl;

    /// fetch the list
    var listFromFirebase =
        _getListOfImagesFromUser(post).cast<String>().toList() ?? [];
    int _current = 0;

    return contentRow(fUser, fImage, listFromFirebase, post, _current);
  }

  Widget contentRow(String fUserName, String fImage,
      List<String> listFromFirebase, HebaModel post, int _current) {
    var featured = post.isFeatured;
    var isFeaturedWidget;
    if (featured == true) {
      isFeaturedWidget = Align(
        alignment: AlignmentDirectional.topStart,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: mLables(
            mColor: Colors.green,
            mStyle: TextStyle(
                color: Colors.white,
                wordSpacing: 1,
                fontWeight: FontWeight.bold),
            mTitle: "new",
            mWidth: 40,
          ),
        ),
      );
    } else {
      isFeaturedWidget = Container(
        color: Colors.yellow,
      );
    }
    return Stack(
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.topCenter,
          child: Container(
            color: Colors.blueGrey,
            height: 200,
            margin: EdgeInsets.all(0),
            child: Padding(
              padding: EdgeInsets.all(1),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                color: Colors.white,
                elevation: 4,
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: rowBody(listFromFirebase, post, _current)),
                    Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: rowFooter(fUserName, fImage, post)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: isFeaturedWidget,
        ),
      ],
    );
  }

  Widget rowBody(List<String> listFromFirebase, HebaModel post, int _current) {
    return Container(
      height: 150,
//      color: Colors.blue,
      child: InkWell(
        focusColor: Colors.blueGrey,
        splashColor: Colors.blueGrey,
        onTap: () async {
//          print("${index} ");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HebaDetails(
                  heba: widget.post,
                  isMe: false,
                  currentUserId: widget.currentUserId),
            ),
          );
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) => HebaDetails(
//                  post2: _docsList[index], isMe: isMine, userId: widget.userId),
//            ),
//          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            /// Content Side
            rowContentSide(post),

            /// Image Side
            rowImageSide(listFromFirebase, post, _current),
          ],
        ),
      ),
    );
  }

  Widget editIcon(HebaModel post) {
    var featured = post.isFeatured;
    var isMine = post.authorId == widget.currentUserId;
//    print("isMine :${isMine.toString()} ${widget.currentUserId}  "); // true, contain the same characters
    var isMineWidget;
    if (isMine == true) {
      isMineWidget = Expanded(
        flex: 1,
        child: GestureDetector(
          child: Align(
            alignment: Alignment.center,
            child: Center(
              child: Container(
                height: 30.0,
                color: Colors.white,
                child: Icon(
                  FontAwesomeIcons.edit,
                  color: Colors.blueAccent,
                  size: 16,
                ),
              ),
            ),
          ),
          onTap: () {
            print("Add edit Function");
          },
        ),
      );
    } else {
      isMineWidget = Container(
        width: 10,
//        color: Colors.red,
      );
    }

    return Container(
      child: isMineWidget,
    );
  }

  Widget rowFooter(String fUser, String fImage, HebaModel post) {
//    var isMe = post.authorId == widget.currentUserId;
    return Container(
      height: 60,
      child: Column(
        children: <Widget>[
          Divider(
            thickness: 0.4,
            color: Colors.grey,
          ),
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        color: Colors.white,
                        height: 30.0,
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.bookmark,
                            color: Colors.black38,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: Container(
                        height: 30.0,
                        color: Colors.white,
                        child: Icon(
                          FontAwesomeIcons.share,
                          color: Colors.black38,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              editIcon(post),
              Expanded(
                  flex: 4,
                  child: Divider(
                    color: Colors.white,
                  )),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "${timeago.format(post.timestamp.toDate())}",
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8),
                child: Icon(FontAwesomeIcons.clock,
                    size: 14, color: Colors.black38),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (_) => ProfileScreen(
//                            currentUserId: widget.currentUserId,
//                            userId: post.authorId,
//                          ),
//                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: post.oImage.isEmpty
                              ? Image.asset(AvailableImages.appIcon)
                              : NetworkImage(post.oImage),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
//            child: Image.network(_googleSignIn.currentUser.photoUrl),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget rowImageSide(
      List<String> listFromFirebase, HebaModel post, int _current) {
    return Container(
      height: 100,
      width: 100,
      child: listFromFirebase.isEmpty
          ? Center(
              child: Image.asset(
              'assets/images/appicon.png',
              color: Colors.grey.withOpacity(0.4),
            ))
          : ImagesSlider(
              items: map<Widget>(listFromFirebase, (index, i) {
//                print("listFromFirebase ${listFromFirebase.length}");
                return Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      image: DecorationImage(
                          image: post.imageUrls.isEmpty
                              ? Image.asset(
                                  'assets/images/user_placeholder.jpg')
                              : NetworkImage(i),
                          fit: BoxFit.cover),
                    ),
                  ),
                );
              }),
              autoPlay: false,
              viewportFraction: 1.0,
              indicatorColor: Colors.grey,
              aspectRatio: 1.0,
              distortion: true,
              align: IndicatorAlign.bottom,
              indicatorWidth: 1,
              indicatorBackColor: Colors.black38,
              updateCallback: (index) {
                setState(
                  () {
                    _current = index;
                  },
                );
              },
            ),
    );
  }

  Widget rowContentSide(HebaModel post) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width - 130,
//      color: Colors.cyan,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(post.hName,
                maxLines: 1,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                    textStyle: Theme.of(context).textTheme.subtitle1,
                    fontSize: 16)),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              post.hDesc,
              maxLines: 1,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(
                textStyle: Theme.of(context).textTheme.caption,
                fontSize: 14,
              ),
            ),
          ),

          Row(
            textDirection: TextDirection.rtl,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.city,
                    size: 14, color: Colors.black38),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  post.hCity,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.location_on, size: 14, color: Colors.black38),
              ),
//              todo calculate distance
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  post.geoPoint.longitude.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          // todo change
//          Text(
//            post.hCity ?? "SSS",
//            overflow: TextOverflow.ellipsis,
//            style: new TextStyle(
//              color: Colors.blue,
//              fontSize: 14,
//              fontWeight: FontWeight.normal,
//            ),
//          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        rowView(widget.post),
      ],
    );
  }
}
