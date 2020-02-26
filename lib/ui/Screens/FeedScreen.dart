/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/ui/Views/FeedView.dart';
import 'package:heba_project/ui/Views/post_view.dart';
import 'package:heba_project/ui/shared/Constants.dart';
import 'package:heba_project/ui/shared/mAppbar.dart';
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
  /// =========================================================
  var _hebatList = [];
  int _displayPosts = 0; // 0 - grid, 1 - column
  User _profileUser;
  var _profileImage;

  /// Methods =========================================================

  void printData() {
    publicpostsRef.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  /// getImagesUrls
  List<dynamic> _getListOfImagesFromUser(Post2 post2) {
    dynamic list = post2.imageUrls;
    return list;
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  /// Widgets =========================================================
  Widget _buildDisplayPosts() {
    print("${_hebatList.length}");
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

//  Widget mPostView() {
//    return FutureBuilder(
//      future: postsRef.document(widget.currentUserId).get(),
//      builder: (BuildContext context, AsyncSnapshot snapshot) {
//        if (!snapshot.hasData) {
//          print(
//              "snapshot : ${postsRef.getDocuments().then((QuerySnapshot snapshot) {
//            snapshot.documents.forEach((f) => print('${f.exists}}'));
//          })}");
//
//          return Center(
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Center(child: CircularProgressIndicator()),
//                ),
//                Text("Loading ...")
//              ],
//            ),
//          );
//        } else if (snapshot.hasError) {
//          print('u have error in future');
//        }
//        User user = User.fromDoc(snapshot.data);
//        return Padding(
//          padding: const EdgeInsets.all(8.0),
//          child: Card(
//            child: ListView(
//              scrollDirection: Axis.vertical,
//              shrinkWrap: true,
//              children: <Widget>[
//                _userData(user),
//                Divider(),
//                Column(
//                  children: <Widget>[
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        /// Left Side
//                        Container(
//                          child: Column(
//                            children: <Widget>[
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: SizedBox(
//                                  height: 100.0,
//                                  width: 100.0,
//
//                                  /// todo
//                                  child: Image.asset(
//                                    "assets/images/building.gif",
//                                    fit: BoxFit.cover,
//                                  ),
//                                ),
//                              ),
//                              Row(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                children: <Widget>[
//                                  new GestureDetector(
//                                    child: new Padding(
//                                      padding: new EdgeInsets.all(5.0),
//                                      child: buildButtonColumn(Icons.bookmark),
//                                    ),
//                                    onTap: () {},
//                                  ),
//                                  new GestureDetector(
//                                    child: new Padding(
//                                        padding: new EdgeInsets.symmetric(
//                                            vertical: 10.0, horizontal: 5.0),
//                                        child: buildButtonColumn(Icons.share)),
//                                    onTap: () {},
//                                  ),
//                                ],
//                              ),
//                            ],
//                          ),
//                        ),
//
//                        /// Right Side
//                        Expanded(
//                          flex: 2,
//                          child: Container(
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                              children: <Widget>[
//                                Container(
//                                  child: Padding(
//                                    padding: const EdgeInsets.all(8.0),
//                                    child: Text(
//                                      "assets/imagesassets/.gif",
//                                      style: new TextStyle(
//                                        fontWeight: FontWeight.bold,
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                                Container(
//                                  child: Padding(
//                                    padding: const EdgeInsets.all(8.0),
//                                    child: Text(
//                                      "assets/imagesassets/.gif",
//                                      style: new TextStyle(
//                                        fontWeight: FontWeight.normal,
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
////                Text("${_posts.length}"),
//              ],
//            ),
//          ),
//        );
//      },
//    );
//  }

  Widget mPostView() {
    var user = Provider.of<FirebaseUser>(context);
    return StreamBuilder(
      stream: DatabaseService.getAllPosts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                Text("Loading ...")
              ],
            ),
          );
        } else if (snapshot.hasError) {
          print('mPostView : ${user.email}');
        }

        Post2 post2 = Post2.fromDoc(snapshot.data);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                Divider(),
                rowView(post2),
              ],
            ),
          ),
        );
      },
    );
  }

  Column rowView(Post2 post2) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            /// Left Side
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 100.0,
                      width: 100.0,

                      /// todo
                      child: Image.asset(
                        "assets/images/building.gif",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new GestureDetector(
                        child: new Padding(
                          padding: new EdgeInsets.all(5.0),
                          child: buildButtonColumn(Icons.bookmark),
                        ),
                        onTap: () {},
                      ),
                      new GestureDetector(
                        child: new Padding(
                            padding: new EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 5.0),
                            child: buildButtonColumn(Icons.share)),
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Right Side
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          post2.hName,
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "assets/imagesassets/.gif",
                          style: new TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column buildButtonColumn(IconData icon) {
    Color color = Theme
        .of(context)
        .primaryColor;
    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        new Icon(icon, color: color),
      ],
    );
  }

  _buildDisplayPosts2() {
    if (_displayPosts == 0) {
      // Grid
      List<GridTile> tiles = [];
      _hebatList.forEach(
            (post) => tiles.add(_gridView(post)),
      );
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      // Column
      List<FeedView> postViews = [];
      _hebatList.forEach((post) {
        postViews.add(
          FeedView(
            post: post,
            author: _profileUser,
          ),
        );
      });
      return Column(children: postViews);
    }
  }

  Widget _gridView(Post2 post) {
    /// fetch the list
    var listFromFirebase =
    _getListOfImagesFromUser(post).cast<String>().toList();
//    var listFromFirebase = _getListOfImagesFromUser(post);
    int _current = 0;

    return GridTile(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: listFromFirebase.isEmpty
                ? Center(child: Text("No Image Bro"))
                : ImagesSlider(
              items: map<Widget>(listFromFirebase, (index, i) {
                print("listFromFirebase ${listFromFirebase.length}");
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: post.imageUrls.isEmpty
                            ? Image.asset(
                            'assets/images/user_placeholder.jpg')
                            : NetworkImage(i),
                        fit: BoxFit.cover),
                  ),
                );
              }),
              autoPlay: false,
              viewportFraction: 1.0,
              aspectRatio: 2.0,
              distortion: false,
              align: IndicatorAlign.bottom,
              indicatorWidth: 5,
              updateCallback: (index) {
                setState(
                      () {
                    _current = index;
                  },
                );
              },
            ),
          ),

//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Card(
//              child: ListView(
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text(post.hName),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text(post.hLocation),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text(post.hDesc),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: CachedNetworkImage(
//                      imageUrl: post.imageUrls[0],
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          )
        ],
      ),
    );
  }

//  Widget mainView() {
//    Post2 post2 = Post2(
//        imageUrls: [],
//        hName: '_name',
//        hDesc: "_desc",
//        hLocation: "location",
//        authorId: "",
//        timestamp: Timestamp.fromDate(DateTime.now()));
//
//    _hebatList.add(post2);
//
//    return FutureBuilder(
//      future: usersRef.document(widget.currentUserId).get(),
//      builder: (BuildContext context, AsyncSnapshot snapshot) {
//        if (!snapshot.hasData) {
//          print(
//              "snapshot : ${usersRef.getDocuments().then((QuerySnapshot snapshot) {
//            snapshot.documents.forEach((f) => print('${f.exists}}'));
//          })}");
//          return Center(
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Center(child: CircularProgressIndicator()),
//                ),
//                Text("Loading ...")
//              ],
//            ),
//          );
//        } else if (snapshot.hasError) {
//          print('u have error in future');
//        }
//        User user = User.fromDoc(snapshot.data);
//        print("_hebatList ${_hebatList.length}");
//        return ListView(
//          children: <Widget>[
//            _userData(user),
////              _buildImageSlider(post);
////              _buildToggleButtons(),
//            Divider(),
//            _hebatList.isEmpty
//                ? Padding(
//                    padding: const EdgeInsets.all(32.0),
//                    child: Center(
//                      child: Image.asset("assets/images/building.gif"),
//                    ),
//                  )
//                : _buildDisplayPosts2(),
////              Text("${_posts.length}"),
//          ],
//        );
//      },
//    );
//  }
  Widget mainView() {
    Post2 post2 = Post2(
        imageUrls: [],
        hName: '_name',
        hDesc: "_desc",
        hLocation: "location",
        authorId: "",
        timestamp: Timestamp.fromDate(DateTime.now()));

    _hebatList.add(post2);

    return FutureBuilder(
      future: usersRef.document(widget.currentUserId).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          print(
              "snapshot : ${usersRef.getDocuments().then((
                  QuerySnapshot snapshot) {
                snapshot.documents.forEach((f) => print('${f.exists}}'));
              })}");
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                Text("Loading ...")
              ],
            ),
          );
        } else if (snapshot.hasError) {
          print('u have error in future');
        }
        User user = User.fromDoc(snapshot.data);
        print("_hebatList ${_hebatList.length}");
        return ListView(
          children: <Widget>[
            _userData(user),
//              _buildImageSlider(post);
//              _buildToggleButtons(),
            Divider(),
            _hebatList.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Image.asset("assets/images/building.gif"),
              ),
            )
                : mPostView(),
//              Text("${_posts.length}"),
          ],
        );
      },
    );
  }

  Widget _buildTilePost2(Post2 post) {
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
                    : CachedNetworkImageProvider(post.imageUrls[0]),
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

  Widget _userData(User user) {
    print("_userData Called");
    var profileImageUrl = user.profileImageUrl;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.white,
                backgroundImage: user.profileImageUrl.isEmpty
                    ? AssetImage('assets/images/user_placeholder.jpg')
                    : CachedNetworkImageProvider(profileImageUrl),
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  "${user.name}",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  "${user.email}",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "heba",
        isHome: true,
        color: Colors.white,
        isImageVisble: true,
      ),
      body: mainView(),
    );
  }

  @override
  void initState() {
    super.initState();
  }
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
