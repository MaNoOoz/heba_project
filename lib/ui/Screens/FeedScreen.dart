/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/post_model.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/service/LocationService.dart';
import 'package:heba_project/ui/shared/Constants.dart';
import 'package:heba_project/ui/shared/mAppbar.dart';
import 'package:heba_project/ui/widgets/mWidgets.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'HebaDetails.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';
  final String currentUserId;
  Post2 post;
  Post post1;

  FeedScreen({this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  /// ==============================================================
  List<Post2> _docsList = [];

//  List<Post> _docsList1 = [];
  Post2 postFromFuture;
  Post postFromFuture1;
  var _displayPosts = 0; // 0 - grid, 1 - column
  var _ViewModeCode = 0;

  var stream;
  var isMine = false;
  var featured = false;

  /// Map
  GoogleMapController mapController;

//  Location location = new Location();
  UserLocation userLocation = UserLocation();
  List<Marker> markers = <Marker>[];
  List<UserLocation> places;
  Stream<QuerySnapshot> _iceCreamStores;

  Completer<GoogleMapController> _controller = Completer();

  /// Bottom Sheet
//  var _selectedItemBtnSheet;
  TabController _tabController;

  /// Filtering Values :  0 = Filter [showBtnSheetForFiltiring] , 1 = Sort  [showBtnSheetForSorting]
  var mBottomSheetForFiltiring;

  /// Sorting Database based on This [_selected]  :  Sorting Values : 0 =  popular "Default" , 1 = low to high , 2 = high to low
  int _selected = 0;
  QuerySnapshot qn;

  /// Query DATABASE Based On [_selected]

  Stream querDbWith({String tag}) {
    Query query = publicpostsRef.where(tag);
    query.snapshots();
//    slids = query.snapshots().map((docsList) {
//      docsList.documents.map((doc) {
//        return doc.data;
//      });
//    }).toList();
//    return slids;
  }

  /// test
  Stream<QuerySnapshot> queryLocations({String tag}) {
    _iceCreamStores =
        Firestore.instance.collection('locations').orderBy('name').snapshots();
  }

//  Stream convertQuerySnapshotToStream() async* {
//    Stream stream;
//    var q = await _getQueryPosts(postFromFuture).then((s) {
//      print("convertQuerySnapshotToStream  ${s.documents.toList().length}");
//
//      return s;
//    });
////    stream = q.asStream();
//    yield stream;
//  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);

//    _HebaPostsFromDb(widget.post);
    _HebaPostsFromDb3(widget.post);
//    _HebaPostsFromDb2(widget.post1);
//    queryLocations();

//    _HebaPostsFromDb2(widget.post);

//    _getQueryPosts(widget.post2);
//    convertQuerySnapshotToStream();
  }

  List<dynamic> _getListOfImagesFromUser(Post2 post2) {
    dynamic list = postFromFuture.imageUrls;
    return list;
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  _HebaPostsFromDb(Post2 postModel) async {
//    List<Post2> posts = await DatabaseService.getAllPosts2();
    var ll = await LocationService().getLocation();
    print("_HebaPostsFromDb : ${ll.address}");

    List<Post2> posts = [];
    QuerySnapshot qn = await publicpostsRef.getDocuments();

    List<DocumentSnapshot> documents = qn.documents;
    documents.forEach((DocumentSnapshot doc) {
      postFromFuture = new Post2.fromFirestore(doc);
      var p = postFromFuture.location;
      print("JJJJJJJJJ ${p}");
      postModel = postFromFuture;
      posts.add(postModel);
    });
    // logs
    var mMap = documents.map((e) =>
        e.data.forEach((key, value) {
          print("$key,$value");
        }));
    print("$mMap");

    ///todo
    setState(() {
      _docsList = posts;
    });
    print("_setupPosts  ${_docsList[0].hName}");
    print("_setupPosts  ${postModel.hName}");
    print("_setupPosts  ${_docsList.length}");
    print("_setupPosts  ${postModel.location}");
  }

  _HebaPostsFromDb3(Post2 postModel) async {
    List<Post2> posts = [];
    QuerySnapshot qn = await publicpostsRef.getDocuments();

    var ll = await LocationService().getLocation().then((value) {
      print("_HebaPostsFromDb : ${value.address}");
      List<DocumentSnapshot> documents = qn.documents;
      documents.forEach((DocumentSnapshot doc) {
        postFromFuture = new Post2.fromFirestore(doc);
        var p = postFromFuture.location;
        print("JJJJJJJJJ ${p}");
        postModel = postFromFuture;
        posts.add(postModel);
      });
      // logs
      var mMap = documents.map((e) =>
          e.data.forEach((key, value) {
            print("$key,$value");
          }));
      print("$mMap");

      ///todo
      setState(() {
        _docsList = posts;
      });
      print("_setupPosts  ${_docsList[0].hName}");
      print("_setupPosts  ${postModel.hName}");
      print("_setupPosts  ${_docsList.length}");
      print("_setupPosts  ${postModel.location}");
    });
    return ll;
  }

//  _HebaPostsFromDb2(Post postModel) async {
////    List<Post2> posts = await DatabaseService.getAllPosts2();
//    List<Post> posts = [];
//    QuerySnapshot qn = await publicpostsRef.getDocuments();
//
//    List<DocumentSnapshot> documents = qn.documents;
////    documents.map((Map<String, dynamic> doc) {
//    var mMap = documents.map((e) => e.data.forEach((key, value) {
//          print("$key,$value");
//        }));
//    print("$mMap");
//
////      postFromFuture1 = new Post.fromJson(mMap);
////      var p = postFromFuture1.location;
////      print("JJJJJJJJJ ${p}");
////      postModel = postFromFuture1;
////      posts.add(postModel);
////    });
//
//    ///todo
//    setState(() {
//      _docsList1 = posts;
//    });
//    print("_setupPosts  ${_docsList1[0].hName}");
//    print("_setupPosts  ${postModel.hName}");
//    print("_setupPosts  ${_docsList1.length}");
//    print("_setupPosts  ${postModel.location}");
//  }

//  Future<QuerySnapshot> _getQueryPosts(Post2 postModel) async {
////    List<Post2> posts = await DatabaseService.getAllPosts2();
//    List<Post2> posts = [];
//    switch (_selected) {
//      case 0:
//        qn = await publicpostsRef
//            .where("${postFromFuture.isFeatured.toString()}", isEqualTo: false)
//            .getDocuments();
//        return qn;
//
//        break;
//      case 1:
//        qn = await publicpostsRef
//            .where("${postFromFuture.timestamp.toString()}")
//            .orderBy(postFromFuture.timestamp.toString(), descending: false)
//            .getDocuments();
//        return qn;
//
//        break;
//      case 2:
//        qn = await publicpostsRef
//            .where("${postFromFuture.timestamp.toString()}")
//            .orderBy(postFromFuture.timestamp.toString(), descending: true)
//            .getDocuments();
//        return qn;
//        break;
//    }
//
//    List<DocumentSnapshot> documents = qn.documents;
//    documents.forEach((DocumentSnapshot doc) {
//      postFromFuture = new Post2.fromSnapshot(doc);
//      postModel = postFromFuture;
//      posts.add(postModel);
//    });
//
//    ///todo
//    setState(() {
//      _docsList = posts;
//    });
//    print("_getQueryPosts  ${_docsList[0].hName}");
//    print("_getQueryPosts  ${postModel.hName}");
//    print("_getQueryPosts  ${_docsList.length}");
//    return qn;
//  }

//  _getQueryPosts(Post2 postModel) async {
////    List<Post2> posts = await DatabaseService.getAllPosts2();
//    List<Post2> posts = [];
//    switch (_selected) {
//      case 0:
//        qn = await publicpostsRef
//            .where("${postFromFuture.isFeatured.toString()}", isEqualTo: false)
//            .getDocuments();
//        break;
//      case 1:
//        qn = await publicpostsRef
//            .where("${postFromFuture.timestamp.toString()}")
//            .orderBy(postFromFuture.timestamp.toString(), descending: false)
//            .getDocuments();
//        break;
//      case 2:
//        qn = await publicpostsRef
//            .where("${postFromFuture.timestamp.toString()}")
//            .orderBy(postFromFuture.timestamp.toString(), descending: true)
//            .getDocuments();
//        break;
//    }
//
//    List<DocumentSnapshot> documents = qn.documents;
//    documents.forEach((DocumentSnapshot doc) {
//      postFromFuture = new Post2.fromDoc(doc);
//      postModel = postFromFuture;
//      posts.add(postModel);
//    });
//
//    ///todo
//    setState(() {
//      _docsList = posts;
//    });
//    print("_setupPosts  ${_docsList[0].hName}");
//    print("_setupPosts  ${postModel.hName}");
//    print("_setupPosts  ${_docsList.length}");
//  }

  /// Bottom Sheet
//  void _selectItem(String name) {
//    Navigator.pop(context);
//    setState(() {
//      _selectedItemBtnSheet = name;
//    });
//  }

  _selctedMethod(int selected) {
    Navigator.of(context).pop();
    setState(() {
      _selected = selected;
      print("$_selected");
    });
  }

  /// rowView Content ================================================

//  Widget viewType(Post2 post, User user) {
//    if (_displayPosts == 0) {
//      // Grid
//      List<GridTile> tiles = [];
//      _docsList.forEach(
//        (post) => tiles.add(gridView(post)),
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
//      return rowView(post);
//    }
//  }
  Widget viewType(Post2 post, int index) {
    if (_displayPosts == 0) {
      // Grid
      return gridView(post);
    } else {
      return rowView(post, index);
    }
  }

  Widget rowView(Post2 post, int index) {
    var fUser = Provider
        .of<FirebaseUser>(context)
        .displayName;
    var fImage = Provider
        .of<FirebaseUser>(context)
        .photoUrl;

    /// fetch the list
    var listFromFirebase =
    _getListOfImagesFromUser(post).cast<String>().toList();
    int _current = 0;

    return contentRow(fUser, fImage, listFromFirebase, post, _current, index);
  }

  Widget gridView(Post2 post) {
//    var fUser = Provider.of<FirebaseUser>(context).displayName;
//    var fImage = Provider.of<FirebaseUser>(context).photoUrl;
    /// fetch the list
    var listFromFirebase =
    _getListOfImagesFromUser(post).cast<String>().toList();
    int _current = 0;
    return Container(
        height: 200, child: contentGrid(listFromFirebase, post, _current));
  }

  Widget contentGrid(List<String> listFromFirebase, Post2 post, int _current) {
//    todo
  }

  Widget editIcon(Post2 post) {
    featured = post.isFeatured;
    isMine = post.authorId == widget.currentUserId;
    print(
        "contentRow ${widget
            .currentUserId}  ${isMine}"); // true, contain the same characters
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
                  color: Colors.black38,
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

  Widget contentRow(String fUserName, String fImage,
      List<String> listFromFirebase, Post2 post, int _current, int index) {
    featured = post.isFeatured;
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
            color: Colors.white30,
            height: 200,
            margin: EdgeInsets.all(0),
            child: Padding(
              padding: EdgeInsets.all(1),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                color: Colors.white,
                elevation: 4,
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: AlignmentDirectional.topCenter,
                        child:
                        rowBody(listFromFirebase, post, _current, index)),
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

  Widget rowBody(List<String> listFromFirebase, Post2 post, int _current,
      int index) {
    return Container(
      height: 150,
//      color: Colors.blueAccent,
      child: InkWell(
        focusColor: Colors.green,
        splashColor: Colors.black54,
        onTap: () {
          print("${index} ");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HebaDetails(_docsList[index]),
            ),
          );
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

  Widget rowFooter(String fUser, String fImage, Post2 post) {
    return Container(
      height: 60,
      child: Column(
        children: <Widget>[
          Divider(
            thickness: 0.4,
            color: Colors.grey,
          ),
          Row(
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
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 10),
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: post.oImage.isEmpty
                              ? Image.asset(
                              'assets/images/user_placeholder.jpg')
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

  Widget rowImageSide(List<String> listFromFirebase, Post2 post, int _current) {
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
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.zero,
                bottomRight: Radius.circular(0),
                topLeft: Radius.zero,
                topRight: Radius.circular(0),
              ),
              image: DecorationImage(
                  image: post.imageUrls.isEmpty
                      ? Image.asset('assets/images/user_placeholder.jpg')
                      : NetworkImage(i),
                  fit: BoxFit.cover),
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

  Widget rowContentSide(Post2 post) {
    return Container(
      height: 100,
      width: MediaQuery
          .of(context)
          .size
          .width - 130,
//      color: Colors.cyan,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            post.hName,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            post.hDesc,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),

          /// todo
//          Text(
//            userLocation.address,
//            overflow: TextOverflow.ellipsis,
//            style: new TextStyle(
//              color: Colors.blueAccent,
//              fontSize: 14,
//              fontWeight: FontWeight.normal,
//            ),
//          ),
        ],
      ),
    );
  }

  Widget EmptyView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image(
        image: AssetImage('assets/images/uph.jpg'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  ViewMode() {
    User user;
    if (_ViewModeCode == 0) {
      return mListData(context, postFromFuture, user);
    } else {
      return mMapView(context, postFromFuture, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    User user;
    var currentLocation = Provider.of<UserLocation>(context);
    print(currentLocation.latitude);
    print(currentLocation.longitude);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: _ViewModeCode == 0
            ? Icon(FontAwesomeIcons.map)
            : Icon(FontAwesomeIcons.list),
        onPressed: () {
          if (_ViewModeCode == 1) {
            setState(() {
              _ViewModeCode = 0;
            });
          } else {
            setState(() {
              _ViewModeCode = 1;
            });
          }

//          showBtnSheetForFiltiring(context, _tabController);
        },
      ),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: "heba $_selected",
              IsBack: false,
              color: Colors.white,
              isImageVisble: true,
              flexSpace: 50,
              flexColor: Colors.black12,
            ),
            Divider(),
            FilterCard(context),
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          _ViewModeCode == 0
              ? Center(
            child: Visibility(

              /// todo
              visible: true,
              child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text("النتائج")),
                          Text("  ${_docsList.length}"),
                        ],
                      ),
                    ),
                  ),
                  height: 40,
                  color: Colors.white),
            ),
          )
              : Container(),
          _ViewModeCode == 0
              ? mListData(context, postFromFuture, user)
              : Container(child: mMapView(context, postFromFuture, user)),
        ],
      ),
    );
  }

  Widget mListData(BuildContext context, Post2 post, User user) {
    return StreamBuilder<QuerySnapshot>(
      stream: publicpostsRef.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> map) {
        if (map.hasData) {
          return mHebatList(context, map, user);
//          final names = map.data.documents;
//          List<Text> messagesWidgets = [];
//          for (var name in names) {
//            final txt = name.data['hName'];
//            final from = name.data['oName'];
//            final uiTxt = Text("$txt from $from");
////            List<DocumentSnapshot> documents = map.data.documents;
//            names.forEach((docObject) {
//              postFromFuture = new Post2.fromDoc(docObject);
////              post = postFromFuture;
////              _docsList.clear();
//
////              print("${_docsList[index].hName}  + ${postFromFuture.oName}+ ${postFromFuture.hLocation}");
////             final uiTxt =   Text("${_docsList[0].hName} + ${postFromFuture.hLocation}");
////              messagesWidgets.add(uiTxt);
//            }
//            );
//          }

        } else {
          return Center(
            child: mStatlessWidgets().mLoading(),
          );
        }
      },
    );
  }

  Widget mHebatList(BuildContext context, AsyncSnapshot<QuerySnapshot> map,
      User user) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /// todo Fix GridView
          new ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
//              itemCount: map.data.documents.length,
              itemCount: _docsList.length,
              padding: const EdgeInsets.only(top: 15.0),
              itemBuilder: (context, index) {
//                DocumentSnapshot ds = map.data.documents[index];
//                DocumentSnapshot ds = map.data.documents[index];
//                      Post2 post2 = Post2.fromDoc(ds);
//                postFromFuture = Post2.fromFirestore(ds);
//                _HebaPostsFromDb(widget.post);
                return rowView(_docsList[index], index);
//                return GestureDetector(
//                    onTap: () {
//                      print("${index} ");
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => HebaDetails(_docsList[index]),
//                        ),
//                      );
//                    },
//                    child: viewType(postFromFuture));
              }),
        ],
      ),
    );
  }

  Widget FilterCard(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Card(
        elevation: 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /// Filter
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: GestureDetector(
                onTap: () async {
                  print("object");
                  return showBtnSheetForFiltiring(context, _tabController);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              "تصفية",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Icon(
                              FontAwesomeIcons.filter,
                              size: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// Sort
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
//                  todo
//                  return showBtnSheetForSorting(context, _tabController);
                },
                child: Container(
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          " ترتيب",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.sort,
                            size: 14,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// View
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        "عرض",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        child: Center(
                            child: _displayPosts == 0
                                ? IconButton(
                              icon: Icon(
                                FontAwesomeIcons.thLarge,
                                size: 14,
                                color: _displayPosts == 0
                                    ? Colors.blueAccent
                                    : Colors.grey[400],
                              ),
                              onPressed: () {
                                print("${_displayPosts}");
                                setState(() {
                                  _displayPosts = 1;
                                });
                              },
                            )
                                : IconButton(
                              icon: Icon(
                                FontAwesomeIcons.list,
                                size: 14,
                                color: _displayPosts == 1
                                    ? Colors.blueAccent
                                    : Colors.grey[400],
                              ),
                              onPressed: () {
                                print("${_displayPosts}");
                                setState(() {
                                  _displayPosts = 0;
                                });
                              },
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showBtnSheetForFiltiring(BuildContext context, TabController _tabController) {
    var w = MediaQuery
        .of(context)
        .size
        .width * 0.1;
    var h = MediaQuery
        .of(context)
        .size
        .height * 0.2;
    mBottomSheetForFiltiring = showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          /// close icon
          return Stack(
            children: <Widget>[
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  height: h + 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: Container(
                            height: h,
                            child: Container(
                              child: Column(
                                children: <Widget>[

                                  /// my
                                  Flexible(
                                    child: RadioListTile(
                                      value: 0,
                                      groupValue: _selected,
                                      onChanged: _selctedMethod,
                                      title: Directionality(
                                        child: Text(
                                          "هباتي",
                                          style: TextStyle(
                                              fontWeight: _selected == 0
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ),

                                  ///old to  new
                                  Flexible(
                                    child: RadioListTile(
                                      value: 1,
                                      groupValue: _selected,
                                      onChanged: _selctedMethod,
                                      title: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          'الأقدم',
                                          style: TextStyle(
                                              fontWeight: _selected == 1
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// new to old
                                  Flexible(
                                    child: RadioListTile(
                                      value: 2,
                                      groupValue: _selected,
                                      onChanged: _selctedMethod,
                                      title: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          'الأحدث',
                                          style: TextStyle(
                                              fontWeight: _selected == 2
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 10,
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.clear,
                    color: Colors.black38,
                    size: 26.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 0.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
            ],
          );
        });

    return mBottomSheetForFiltiring;
  }

  Widget mMapView(BuildContext context,
      Post2 postFromFuture,
      User user,) {
    var h = MediaQuery
        .of(context)
        .size
        .height / 1.5;
    return Container(
      height: h,
      child: Stack(
        children: [
          GoogleMap(
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                      () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
              initialCameraPosition:
              CameraPosition(target: LatLng(24.72, 46.7), zoom: 10),
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              // Add little blue dot for device location, requires permission from user
              mapType: MapType.hybrid,
              markers: Set<Marker>.of(markers),
              // todo

              myLocationButtonEnabled: true),
//      Text("sss"),

          Positioned(
            bottom: 50,
            left: 10,
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    getMarkers(userLocation.latitude, userLocation.longitude);
                  },
                  child: Icon(Icons.place),
                ),
//                RawMaterialButton(
//                  child: Icon(
//                    CupertinoIcons.location_solid,
//                    color: Colors.black38,
//                    size: 26.0,
//                  ),
//                  shape: CircleBorder(),
//                  elevation: 0.0,
//                  fillColor: Colors.white,
//                  padding: const EdgeInsets.all(8.0),
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                ),
//                RawMaterialButton(
//                  child: Icon(
//                    Icons.list,
//                    color: Colors.black38,
//                    size: 26.0,
//                  ),
//                  shape: CircleBorder(),
//                  elevation: 0.0,
//                  fillColor: Colors.white,
//                  padding: const EdgeInsets.all(8.0),
//                  onPressed: () {
////                  Navigator.of(context).pop();
////                  _animateToUser();
//                  },
//                ),
//                RawMaterialButton(
//                  child: Icon(
//                    Icons.list,
//                    color: Colors.black38,
//                    size: 26.0,
//                  ),
//                  shape: CircleBorder(),
//                  elevation: 0.0,
//                  fillColor: Colors.white,
//                  padding: const EdgeInsets.all(8.0),
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void editPost(DocumentSnapshot documentSnapshot) {
//    documentSnapshot.reference.updateData(data);
  }

  void getMarkers(latitude, longitude) {
    setState(() {
      markers.clear();
    });
    publicpostsRef.snapshots().listen((event) {
      event.documents.map((e) {
        e.data['hName'];
        print(e.data);
      });
    });
  }

//  Widget showBtnSheetForSorting(
//      BuildContext context, TabController _tabController) {
//    var w = MediaQuery.of(context).size.width * 0.1;
//    var h = MediaQuery.of(context).size.height * 0.2;
//    mBottomSheetForFiltiring = showModalBottomSheet(
//        context: context,
//        backgroundColor: Colors.transparent,
//        builder: (context) {
//          /// close icon
//          return Stack(
//            children: <Widget>[
//              Container(
//                color: Colors.transparent,
//                padding: EdgeInsets.only(top: 20),
//                child: Container(
//                  height: h + 50,
//                  decoration: BoxDecoration(
//                    color: Colors.white,
//                    borderRadius: BorderRadius.only(
//                        topLeft: Radius.circular(10),
//                        topRight: Radius.circular(10)),
//                  ),
//                  child: Stack(
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.only(top: 18.0),
//                        child: Align(
//                          alignment: AlignmentDirectional.bottomCenter,
//                          child: Container(
//                            height: h,
//                            child: Container(
//                              child: Column(
//                                children: <Widget>[
//                                  Flexible(
//                                    child: ListTile(
//                                      leading: Radio(
//                                          value: 1,
//                                          groupValue: _selected,
//                                          onChanged: (value) {
//                                            print(value);
//                                            setState(() {
//                                              _selected = value;
//                                            });
//                                          }),
//                                      title: Directionality(
//                                          textDirection: TextDirection.rtl,
//                                          child: Text(
//                                            'بالسعر: من الأقل إلى الأكثر',
//                                            style: TextStyle(
//                                                decoration:
//                                                    TextDecoration.lineThrough),
//                                          )),
//                                    ),
//                                  ),
//                                  Flexible(
//                                    child: ListTile(
//                                        leading: Radio(
//                                            value: 2,
//                                            groupValue: _selected,
//                                            onChanged: (value) {
//                                              print(value);
//                                              setState(() {
//                                                _selected = value;
//                                              });
//                                            }),
//                                        title: Directionality(
//                                            textDirection: TextDirection.rtl,
//                                            child: Text(
//                                                'بالسعر: من الأكثر إلى الأقل')),
//                                        onTap: () => {print("object")}),
//                                  ),
//                                  Flexible(
//                                    child: ListTile(
//                                        leading: Radio(
//                                            value: 3,
//                                            groupValue: _selected,
//                                            onChanged: (value) {
//                                              print(value);
//                                              setState(() {
//                                                _selected = value;
//                                              });
//                                            }),
//                                        title: Directionality(
//                                            textDirection: TextDirection.rtl,
//                                            child: Text(' الأكثر رواجا')),
//                                        onTap: () => {print("object")}),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              Positioned(
//                top: 0,
//                left: 10,
//                child: RawMaterialButton(
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                  child: Icon(
//                    Icons.clear,
//                    color: Colors.black38,
//                    size: 26.0,
//                  ),
//                  shape: CircleBorder(),
//                  elevation: 0.0,
//                  fillColor: Colors.white,
//                  padding: const EdgeInsets.all(8.0),
//                ),
//              ),
//            ],
//          );
//        });
//
//    return mBottomSheetForFiltiring;
//  }
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
//      builder: (BuildContext context, AsyncSnapshot map) {
//        if (!map.hasData) {
//          print(
//              "map : ${postsRef.getDocuments().then((QuerySnapshot map) {
//            map.documents.forEach((f) => print('${f.exists}}'));
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
//        } else if (map.hasError) {
//          print('u have error in future');
//        }
//        User user = User.fromDoc(map.data);
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
//      builder: (BuildContext context, map) {
//        if (!map.hasData == null) {
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
//        } else if (map.hasError) {
//          print('mPostView : ${user.email} + U Have Error');
//        }
//
////        Post2 post2 = Post2.fromDoc();
////just add this line
//        return CarouselSlider(
//          enlargeCenterPage: true,
//          height: MediaQuery.of(context).size.height,
//          items: getItems(context, map.data.documents),
//        );
//        print('mPostView : ${user.email}');
//      },
//    );
//  }
//  Widget mPostViewWithUserData() {
//    return FutureBuilder(
//      future: DatabaseService.getUserPosts(widget.currentUserId),
//      builder: (BuildContext context, AsyncSnapshot map) {
//        if (map.hasData) {
//          return SingleChildScrollView(
//            physics: ScrollPhysics(),
//            child: Column(
//              children: <Widget>[
//                new ListView.builder(
//                    physics: NeverScrollableScrollPhysics(),
//                    shrinkWrap: true,
//                    itemCount: map.data.documents.length,
//                    padding: const EdgeInsets.only(top: 15.0),
//                    itemBuilder: (context, index) {
//                      DocumentSnapshot ds = map.data.documents[index];
//                      Post2 post2 = Post2.fromDoc(ds);
//                      User user = User.fromDoc(map.data);
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
//Widget icons(IconData icon) {
//  Color color = Colors.black45;
//  return new Column(
//    mainAxisSize: MainAxisSize.min,
//    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//    children: [
//      new Icon(icon, color: color),
//    ],
//  );
//}

///  =====================   Widgets ========================

//  Widget mPostViewPublicData(BuildContext context, Post2 post) {
//    return StreamBuilder(
//      stream: postsRef.snapshots(),
//      builder: (BuildContext context, AsyncSnapshot map) {
//        if (map.hasData) {
//          return SingleChildScrollView(
//            physics: ScrollPhysics(),
//            child: Column(
//              children: <Widget>[
//                new ListView.builder(
//                    physics: NeverScrollableScrollPhysics(),
//                    scrollDirection: Axis.vertical,
//                    shrinkWrap: true,
//                    itemCount: map.data.documents.length,
//                    padding: const EdgeInsets.only(top: 15.0),
//                    itemBuilder: (context, index) {
//                      DocumentSnapshot ds = map.data.documents[index];
//                      Post2 post2 = Post2.fromDoc(ds);
//                      return rowView(post2);
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

//  Widget mPostViewPublicData2(BuildContext context, Post2 post) {
//    return StreamBuilder(
//      stream: slids,
//      initialData: [],
//      builder: (BuildContext context, AsyncSnapshot map) {
//        if (map.hasData) {
//          List slidList = map.data.toList();
//          print("${slidList.length}");
//          return SingleChildScrollView(
//            physics: ScrollPhysics(),
//            child: Column(
//              children: <Widget>[
//                new ListView.builder(
//                    physics: NeverScrollableScrollPhysics(),
//                    scrollDirection: Axis.vertical,
//                    shrinkWrap: true,
//                    itemCount: map.data.documents.length,
//                    padding: const EdgeInsets.only(top: 15.0),
//                    itemBuilder: (context, index) {
//                      DocumentSnapshot ds = map.data.documents[index];
//                      Post2 post2 = Post2.fromDoc(ds);
//                      return rowView(post2);
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

//
//
//Widget feedView(Post2 post, User user) {
////    var name = Provider.of<FirebaseUser>(context).displayName;
////    post = postFromFuture;
////    _docsList.add(post);
////    print("feedView ${name}");
////    return ListView.builder(
////      physics: NeverScrollableScrollPhysics(),
////      scrollDirection: Axis.vertical,
////      shrinkWrap: true,
////      itemCount: _docsList.length,
////      padding: EdgeInsets.only(top: 15.0),
////      itemBuilder: (context, index) {
////        return Container(
////          color: Colors.red,
////          height: 50,
////          width: 100,
//////          child: Text('${_docsList[index]}'),
////          child: Text('${post.hName}'),
////        );
////      },
////    );
//  post = postFromFuture;
//  return SingleChildScrollView(
//    child: StreamBuilder(
//      stream: publicpostsRef.snapshots(),
//      builder: (BuildContext context, map) {
//        print("${_docsList.length}");
//
//        if (!map.hasData) {
//          return mLoading();
////
//        }
//        return ListView.builder(
//          physics: NeverScrollableScrollPhysics(),
//          scrollDirection: Axis.vertical,
//          shrinkWrap: true,
//          itemCount: 10,
//          padding: EdgeInsets.only(top: 15.0),
//          itemBuilder: (context, index) {
//            _docsList.add(post);
//
//            print("${_docsList.length}");
//            return Container(
//                color: Colors.red,
//                height: 50,
//                width: 100,
//                child: RowView(
//                  post: _docsList[index],
//                  onSelected: () => print("sss"),
//                  postList: _docsList,
//                ));
//          },
//        );
//      },
//    ),
//  );
//}
