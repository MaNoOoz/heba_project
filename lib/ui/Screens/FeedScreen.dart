/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/ui/shared/Constants.dart';
import 'package:heba_project/ui/shared/mAppbar.dart';

class FeedScreen extends StatefulWidget {
  /// todo  FIX HEBA LIST EMPTY

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

  StreamBuilder<QuerySnapshot> CardView(BuildContext context, Post2 post2) {
    return StreamBuilder<QuerySnapshot>(
      stream: publicpostsRef.snapshots(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return mLoading();
        }
        return ListView(
          children: <Widget>[
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  "    الهبات    ${_hebatList.length}",
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 24,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Divider(),
            new ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              padding: EdgeInsets.only(top: 15.0),
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                post2 = Post2.fromDoc(ds);
                _hebatList.add(post2);
                return rowView(post2);
              },
            ),
          ],
        );
      },
    );
  }

  Center mLoading() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          Text("Loading ... ")
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot> mPostViewPublicData(BuildContext context,
      Post2 post) {
    return StreamBuilder(
      stream: postsRef.snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                new ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    padding: const EdgeInsets.only(top: 15.0),
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.documents[index];
                      Post2 post2 = Post2.fromDoc(ds);
                      return rowView(post2);
                    }),
              ],
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget rowView(Post2 post) {
//    var profileImageUrl = post2.imageUrls[0] ?? [];
    /// fetch the list
    var listFromFirebase =
    _getListOfImagesFromUser(post).cast<String>().toList();
    int _current = 0;

    return Column(
      children: <Widget>[
        FutureBuilder(
          future: usersRef.document(widget.currentUserId).get(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            User user = User.fromDoc(snapshot.data);
            return Card(
              color: Colors.white,
              elevation: 4,
              child: Column(
                children: <Widget>[
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text("   من   ${user.name}")),
                  Divider(
                    color: Colors.black26,
                  ),
                  Row(
                    children: <Widget>[

                      /// Left Side
                      Container(
                        child: Container(
                          height: 150,
                          width: 150,
                          child: listFromFirebase.isEmpty
                              ? Center(child: Text("No Image Bro"))
                              : ImagesSlider(
                            items:
                            map<Widget>(listFromFirebase, (index, i) {
                              print(
                                  "listFromFirebase ${listFromFirebase
                                      .length}");
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
                                    post.hName,
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
                                    post.hDesc,
                                    style: new TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    post.hLocation,
                                    style: new TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _profileInfo(User user) {
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

  @override
  Widget build(BuildContext context) {
    Post2 post;
    User user;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "heba",
        isHome: true,
        color: Colors.white,
        isImageVisble: true,
      ),
      body: CardView(context, post),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget EmptyView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image(
        image: AssetImage('assets/images/user_placeholder.jpg'),
      ),
    );
  }
}

//  Widget _buildDisplayPosts() {
//    print("${_hebatList.length}");
//    if (_displayPosts == 0) {
//      // Grid
//      List<GridTile> tiles = [];
//      _hebatList.forEach(
//        (post) => tiles.add(_buildTilePost2(post)),
//      );
//      return GridView.count(
//        crossAxisCount: 3,
//        childAspectRatio: 1.0,
//        mainAxisSpacing: 2.0,
//        crossAxisSpacing: 2.0,
//        shrinkWrap: true,
//        physics: NeverScrollableScrollPhysics(),
//        children: tiles,
//      );
//    } else {
//      // Column
//      List<PostView> postViews = [];
//      _hebatList.forEach((post) {
//        postViews.add(
//          PostView(
//            currentUserId: widget.currentUserId,
//            post: post,
//            author: _profileUser,
//          ),
//        );
//      });
//      return Column(children: postViews);
//    }
//  }

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
//  Widget mPostView2() {
//    var user = Provider.of<FirebaseUser>(context);
//    return StreamBuilder<QuerySnapshot>(
//      stream: publicpostsRef.snapshots(),
//      builder: (BuildContext context, snapshot) {
//        if (!snapshot.hasData == null) {
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
//          print('mPostView : ${user.email} + U Have Error');
//        }
//
////        Post2 post2 = Post2.fromDoc();
////just add this line
//        return CarouselSlider(
//          enlargeCenterPage: true,
//          height: MediaQuery.of(context).size.height,
//          items: getItems(context, snapshot.data.documents),
//        );
//        print('mPostView : ${user.email}');
//      },
//    );
//  }
//  Widget mPostViewWithUserData() {
//    return FutureBuilder(
//      future: DatabaseService.getUserPosts(widget.currentUserId),
//      builder: (BuildContext context, AsyncSnapshot snapshot) {
//        if (snapshot.hasData) {
//          return SingleChildScrollView(
//            physics: ScrollPhysics(),
//            child: Column(
//              children: <Widget>[
//                new ListView.builder(
//                    physics: NeverScrollableScrollPhysics(),
//                    shrinkWrap: true,
//                    itemCount: snapshot.data.documents.length,
//                    padding: const EdgeInsets.only(top: 15.0),
//                    itemBuilder: (context, index) {
//                      DocumentSnapshot ds = snapshot.data.documents[index];
//                      Post2 post2 = Post2.fromDoc(ds);
//                      User user = User.fromDoc(snapshot.data);
//                      return Column(
//                        children: <Widget>[
////                          _buildDisplayPosts2(),
//                          _profileInfo(user),
////                          rowView(post2),
//                        ],
//                      );
//                    }),
//              ],
//            ),
//          );
//        } else {
//          return CircularProgressIndicator();
//        }
//      },
//    );
//  }
//  List<Widget> getItems(BuildContext context, List<DocumentSnapshot> docs) {
////    Post2 post2 = Post2.fromDoc();
//
//    return docs.map((doc) {
//      String content = doc.data["hName"];
//      return Column(
//        children: <Widget>[
//          Text(content),
////          rowView(content),
//        ],
//      );
//    }).toList();
//  }
//  _buildDisplayPosts2() {
//    if (_displayPosts == 0) {
//      // Grid
//      List<GridTile> tiles = [];
//      _hebatList.forEach(
//        (post) => tiles.add(_gridView(post)),
//      );
//      return GridView.count(
//        crossAxisCount: 2,
//        childAspectRatio: 1.0,
//        mainAxisSpacing: 2.0,
//        crossAxisSpacing: 2.0,
//        shrinkWrap: true,
//        physics: NeverScrollableScrollPhysics(),
//        children: tiles,
//      );
//    } else {
//      // Column
//      List<FeedView> postViews = [];
//      _hebatList.forEach((post) {
//        postViews.add(
//          FeedView(
//            post: post,
//            author: _profileUser,
//          ),
//        );
//      });
//      return Column(children: postViews);
//    }
//  }
//  Widget _gridView(Post2 post) {
//    /// fetch the list
//    var listFromFirebase =
//        _getListOfImagesFromUser(post).cast<String>().toList();
////    var listFromFirebase = _getListOfImagesFromUser(post);
//    int _current = 0;
//
//    return GridTile(
//      child: Stack(
//        children: [
//          Padding(
//            padding: EdgeInsets.symmetric(vertical: 10.0),
//            child: listFromFirebase.isEmpty
//                ? Center(child: Text("No Image Bro"))
//                : ImagesSlider(
//                    items: map<Widget>(listFromFirebase, (index, i) {
//                      print("listFromFirebase ${listFromFirebase.length}");
//                      return Container(
//                        decoration: BoxDecoration(
//                          image: DecorationImage(
//                              image: post.imageUrls.isEmpty
//                                  ? Image.asset(
//                                      'assets/images/user_placeholder.jpg')
//                                  : NetworkImage(i),
//                              fit: BoxFit.cover),
//                        ),
//                      );
//                    }),
//                    autoPlay: false,
//                    viewportFraction: 1.0,
//                    aspectRatio: 2.0,
//                    distortion: false,
//                    align: IndicatorAlign.bottom,
//                    indicatorWidth: 5,
//                    updateCallback: (index) {
//                      setState(
//                        () {
//                          _current = index;
//                        },
//                      );
//                    },
//                  ),
//          ),
//
////          Padding(
////            padding: const EdgeInsets.all(8.0),
////            child: Card(
////              child: ListView(
////                children: <Widget>[
////                  Padding(
////                    padding: const EdgeInsets.all(8.0),
////                    child: Text(post.hName),
////                  ),
////                  Padding(
////                    padding: const EdgeInsets.all(8.0),
////                    child: Text(post.hLocation),
////                  ),
////                  Padding(
////                    padding: const EdgeInsets.all(8.0),
////                    child: Text(post.hDesc),
////                  ),
////                  Padding(
////                    padding: const EdgeInsets.all(8.0),
////                    child: CachedNetworkImage(
////                      imageUrl: post.imageUrls[0],
////                    ),
////                  ),
////                ],
////              ),
////            ),
////          )
//        ],
//      ),
//    );
//  }
//  Widget _buildTilePost2(Post2 post) {
//    var listFromFirebase = _getListOfImagesFromUser(post);
//    return GridTile(
//      child: ListView.builder(
//          itemCount: listFromFirebase == null ? 0 : listFromFirebase.length,
//          padding: EdgeInsets.all(14.0),
//          itemBuilder: (BuildContext context, int postion) {
//            return ListTile(
//              title: CircleAvatar(
//                radius: 25.0,
//                backgroundColor: Colors.grey,
//                backgroundImage: post.imageUrls.isEmpty
//                    ? AssetImage('assets/images/user_placeholder.jpg')
//                    : CachedNetworkImageProvider(post.imageUrls[0]),
//              ),
////              leading: Text("${post.imageUrls}"),
////              subtitle: Text("${post.hName}"),
//            );
//          }),
////
////      child: Padding(
////        padding: const EdgeInsets.all(8.0),
////        child: Image(
////          image: post.imageUrls.isEmpty
////              ? AssetImage('assets/images/user_placeholder.jpg')
//////          todo fix image Url
////              : CachedNetworkImageProvider(post.imageUrls.toString()),
////        ),
////      ),
//    );
//  }
