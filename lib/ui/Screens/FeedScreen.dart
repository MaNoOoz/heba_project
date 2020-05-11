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
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/ui/shared/Assets.dart';
import 'package:heba_project/ui/shared/Constants.dart';
import 'package:heba_project/ui/shared/mAppbar.dart';
import 'package:heba_project/ui/widgets/mWidgets.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'HebaDetails.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';
  final String currentUserId;
  final String userId;

  ///
  FeedScreen({this.currentUserId, this.userId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  /// VARS
  List<HebaModel> _HebatListFromUsers = [];
  HebaModel heba;

  /// ViewMode :  0-grid,1-row,2-map
  var mDataViewMode = 1;
  var isMine = false;
  var featured = false;

  var data;
  var v;
  StreamSubscription<HebaModel> sub;

  Position currentLocation;

  Geoflutterfire geo = Geoflutterfire();

  @override
  bool get wantKeepAlive => true;

  /// Map View
  Completer<GoogleMapController> mapController = Completer();
  List<Marker> markers = <Marker>[];
  Stream<QuerySnapshot> _PostsStream;
  bool clientsToggle = false;
  bool resetToggle = false;
  HebaModel currentHeba;
  double currentBearing;
  BitmapDescriptor ico;

  /// Bottom Sheet
  TabController _tabController;

  /// Filtering Values :
  /// 0 = Filter [showBtnSheetForFiltiring]
  /// , 1 = Sort  [showBtnSheetForSorting]
  var mBottomSheetForFiltiring;

  /// Sorting Database based on
  /// This [_selectedFilter]  :
  /// Sorting Values : 0 =  popular
  /// "Default" , 1 = low to high
  /// , 2 = high to low
  int _selectedFilter;
  int _selectedSort;

  QuerySnapshot qn;

  ///  Methods ==============================================================
  ///
  /// Query DATABASE Based On [_selectedFilter]
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

//  Stream queryNear({String tag}) {
//    Query query = publicpostsRef.where('geoPoint',whereIn: );
//    query.snapshots();
////    slids = query.snapshots().map((docsList) {
////      docsList.documents.map((doc) {
////        return doc.data;
////      });
////    }).toList();
////    return slids;
//
//  sub = publicpostsRef.w
//  }

//  Stream<QuerySnapshot> queryLocations({String tag}) {
//    _iceCreamStores = Firestore.instance.collection('locations').orderBy('name').snapshots();
//  }

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
    getHebatFromFirestore();
    setMarckerIcon();
    _getLocationAndGoToIt();
//    startQuery();

//    sub = DatabaseService().hebatStream.listen((event) {
//      v = event.hName;
//    });

//    DatabaseService.HebaPostsFromDb(heba);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CustomAppBar(
//              user: widget.user, /// todo  create method to override the image from google in [] in order to fix null
              title: "Heba ",
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
          Center(
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
                          Text("  ${_HebatListFromUsers.length}"),
                        ],
                      ),
                    ),
                  ),
                  height: 40,
                  color: Colors.white),
            ),
          ),
          mData(context, _HebatListFromUsers),
        ],
      ),
    );
  }

  List<dynamic> _getListOfImagesFromUser(HebaModel post2) {
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

  /// init methodes
  getHebatFromFirestore() async {
    print("getHebatFromFirestore Called:");

    List<HebaModel> hebat = [];
    QuerySnapshot qn = await publicpostsRef.getDocuments();

    List<DocumentSnapshot> documents = qn.documents;
    documents.forEach((DocumentSnapshot doc) {
      HebaModel postModel = new HebaModel.fromFirestore(doc);
      hebat.add(postModel);
    });

    var mMap = documents.map((e) =>
        e.data.forEach((key, value) {
//          print("Map From Firestore :$key,$value");
        }));
    print("Map:$mMap");

    setState(() {
      _HebatListFromUsers = hebat;
      _PostsStream = publicpostsRef.snapshots();
    });
    print("Map:${_HebatListFromUsers.length}");

    return hebat;
  }

  startQuery() async {
//    var lat =   currentLocation.latitude;
//    var long =   currentLocation.longitude;
//    var latlng =  LatLng(lat,long);
//    var g = geo.geoPoint;
//
//    var center = geo.distance(lat: lat,lng: long);
//

    _PostsStream = publicpostsRef.snapshots();
  }

  /// Marker Icon From Assets
  setMarckerIcon() async {
    await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), AvailableImages.appIconsmall2)
        .then((d) {
      ico = d;
    });
  }

  /// Filters
  _selctedFilterType(int selected) {
    if (selected == 0) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        List<HebaModel> filterdHebat = [];
        for (var Heba in _HebatListFromUsers) {
          if (Heba.isMine == true) {
            filterdHebat.add(Heba);
            print("filterdHebat :${filterdHebat.length}");

            setState(() {
              _selectedFilter = selected;
              print("filterdHebat :${selected}");
            });
          }
        }

        print("filterdHebat :${filterdHebat.length}");
      });
    }
    else if (selected == 1) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        List<HebaModel> filterdHebat = [];
        for (var Heba in _HebatListFromUsers) {
          if (Heba.isMine == true) {
            filterdHebat.add(Heba);
            print("filterdHebat :${filterdHebat.length}");

            setState(() {
              _selectedFilter = selected;
              print("filterdHebat :${selected}");
            });
          }
        }

        print("filterdHebat :${filterdHebat.length}");
      });
    }

    Navigator.of(context).pop();
    setState(() {
      _selectedFilter = selected;
      print("selected :${selected}");
      this._HebatListFromUsers = _HebatListFromUsers;
    });
//    setState(() {
//      _selected = selected;
//      print("$_selected");
//    });
  }

  _selctedSortingType(int selected) {
    if (selected == 0) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _HebatListFromUsers.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        setState(() {
          _selectedSort = selected;
        });
        print("selected :${_HebatListFromUsers.length}");
      });
    }
    if (selected == 1) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _HebatListFromUsers.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        setState(() {
          _selectedSort = selected;
        });
        print("selected :$selected");
      });
    }
    Navigator.of(context).pop();
    setState(() {
      _selectedSort = selected;
      this._HebatListFromUsers = _HebatListFromUsers;
    });
    print("selected :$selected");
  }

  ///  Widgets ==============================================================

  /// HEADER
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
                                  fontWeight: _selectedFilter == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal),
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
                  return showBtnSheetForSorting(context, _tabController);
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
                              fontWeight: _selectedFilter == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal),
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

            /// Near
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
//                  todo query the database

//                  return showBtnSheetForSorting(context, _tabController);
                },
                child: Container(
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          "  القريب",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.locationArrow,
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
            getIcon(),
          ],
        ),
      ),
    );
  }

  /// todo Still Not Work
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
                          alignment: AlignmentDirectional.center,
                          child: Container(
                            height: h,
                            child: Container(
                              child: Column(
                                children: <Widget>[

                                  /// my
                                  Flexible(
                                    child: RadioListTile(
                                      value: 0,
                                      groupValue: _selectedFilter,
                                      onChanged: _selctedFilterType,
                                      title: Directionality(
                                        child: Text(
                                          "هباتي",
                                          style: TextStyle(
                                              fontWeight: _selectedFilter == 0
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: RadioListTile(
                                      value: 1,
                                      groupValue: _selectedFilter,
                                      onChanged: _selctedFilterType,
                                      title: Directionality(
                                        child: Text(
                                          "هباتي",
                                          style: TextStyle(
                                              fontWeight: _selectedFilter == 1
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                        textDirection: TextDirection.rtl,
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

              /// close icon

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

  showBtnSheetForSorting(BuildContext context, TabController _tabController) {
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

                                  ///old to  new
                                  Flexible(
                                    child: RadioListTile(
                                      value: 0,
                                      groupValue: _selectedSort,
                                      onChanged: _selctedSortingType,
                                      title: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          'الأقدم',
                                          style: TextStyle(
                                              fontWeight: _selectedSort == 0
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// new to old
                                  Flexible(
                                    child: RadioListTile(
                                      value: 1,
                                      groupValue: _selectedSort,
                                      onChanged: _selctedSortingType,
                                      title: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          'الأحدث',
                                          style: TextStyle(
                                              fontWeight: _selectedSort == 1
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

              /// close icon

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

  /// LIST-ITEM

  Widget rowView(HebaModel post, int index) {
    var fUser = Provider
        .of<FirebaseUser>(context)
        .displayName;
    var fImage = Provider
        .of<FirebaseUser>(context)
        .photoUrl;

    /// fetch the list
    var listFromFirebase =
        _getListOfImagesFromUser(post).cast<String>().toList() ?? [];
    int _current = 0;

    return contentRow(fUser, fImage, listFromFirebase, post, _current, index);
  }

  Widget gridView(HebaModel post, int index) {
    /// fetch the list
    var listFromFirebase =
    _getListOfImagesFromUser(post).cast<String>().toList();
    int _current = 0;
    return Container(
        height: 200,
        child: contentGrid(listFromFirebase, post, _current, index));
  }

  Widget contentGrid(List<String> listFromFirebase, HebaModel post,
      int _current, index) {
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
    Stack(
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
                        child: rowFooter("fUserName", "fImage", post)),
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

  Widget editIcon(HebaModel post) {
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
      List<String> listFromFirebase, HebaModel post, int _current, int index) {
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

  Widget rowBody(List<String> listFromFirebase, HebaModel post, int _current,
      int index) {
    return Container(
      height: 150,
//      color: Colors.blueAccent,
      child: InkWell(
        focusColor: Colors.green,
        splashColor: Colors.black54,
        onTap: () {
          print("${index} ");

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

  Widget rowFooter(String fUser, String fImage, HebaModel post) {
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

  Widget rowImageSide(List<String> listFromFirebase, HebaModel post,
      int _current) {
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

  Widget rowContentSide(HebaModel post) {
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
          // todo change
          Text(
            post.geoPoint.longitude.toString() ?? "SSS",
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              color: Colors.blue,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// test ========================================================

  /// DATA ========================================================

  Widget mData(BuildContext context, List<HebaModel> hebatList) {
    QuerySnapshot emptyList;

    return StreamBuilder<QuerySnapshot>(
      initialData: emptyList,
      stream: _PostsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> map) {
        if (map.hasData && _HebatListFromUsers.length > 0) {
          return hebat(context);

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
            child: mStatlessWidgets().EmptyView(),
          );
        }
      },
    );
  }

  Widget mListViewMode() {
    if (mDataViewMode == 0) {
      return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(100, (index) {
          return Center(
            child: Text(
              'Item $index',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1,
            ),
          );
        }),
      );
    } else if (mDataViewMode == 1) {
      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          reverse: true,
          itemCount: _HebatListFromUsers.length,
          padding: const EdgeInsets.only(top: 15.0),
          itemBuilder: (context, index) {
//                DocumentSnapshot ds = map.data.documents[index];
//                DocumentSnapshot ds = map.data.documents[index];
//                      Post2 post2 = Post2.fromDoc(ds);
//                postFromFuture = Post2.fromFirestore(ds);
//                _HebaPostsFromDb(widget.post);
//                return rowView(_docsList[index], index);
            return GestureDetector(
              child: rowView(_HebatListFromUsers[index], index),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HebaDetails(
                            post: _HebatListFromUsers[index],
                            isMe: false,
                            userId: widget.userId),
                  ),
                );
              },
            );
          });
    } else if (mDataViewMode == 2) {
      return mMapView(context);
    }
  }

  Widget hebat(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        color: Colors.cyan,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            mListViewMode(),
          ],
        ),
      ),
    );
  }

  Widget getIcon() {
    return Builder(
      builder: (BuildContext context) {
        if (mDataViewMode == 0) {
          return Padding(
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
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.thLarge,
                            size: 14,
                            color: mDataViewMode == 0
                                ? Colors.blueAccent
                                : Colors.grey[400],
                          ),
                          onPressed: () {
                            print("${mDataViewMode}");
                            setState(() {
                              mDataViewMode = 1;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (mDataViewMode == 1) {
          return Padding(
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
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.list,
                            size: 14,
                            color: mDataViewMode == 1
                                ? Colors.blueAccent
                                : Colors.grey[400],
                          ),
                          onPressed: () {
                            print("${mDataViewMode}");
                            setState(() {
                              mDataViewMode = 2;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (mDataViewMode == 2) {
          return Padding(
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
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.map,
                            size: 14,
                            color: mDataViewMode == 2
                                ? Colors.blueAccent
                                : Colors.grey[400],
                          ),
                          onPressed: () {
                            print("${mDataViewMode}");
                            setState(() {
                              mDataViewMode = 0;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  /// MAP ====================================
  getMarkres() {
    print("getMarkres :Called");
    List<Marker> _markers = [];

    setState(() {
      markers.clear();
    });
    if (_HebatListFromUsers.isNotEmpty) {
      setState(() {
//        clientsToggle = true;
      });
    }

    for (var i in _HebatListFromUsers) {
      print(
          "getMarkersFromList2 :${i.geoPoint.latitude} - ${i.geoPoint
              .longitude}");

      _markers.add(Marker(
        markerId: MarkerId(i.id),
        infoWindow: InfoWindow(title: i.hName, snippet: i.hDesc),
        icon: ico,
        //            position: LatLng(doc.data['geoPoint']['Latitude'], doc.data['geoPoint']['Longitude']),
        position: LatLng(i.geoPoint.latitude, i.geoPoint.longitude),
      ));
    }

    setState(() {
      markers = _markers;
    });
    print("getMarkersFromList2 : _markers lenght${_markers.length.toString()}");

    return markers;
  }

  Widget mMapView(context) {
//    final docs = querySnapshot.data.documents;
//    final docslENGH = querySnapshot.data.documents.length;

    final GlobalKey<AnimatedListState> _listKey = GlobalKey();
    var h = MediaQuery
        .of(context)
        .size
        .height / 1.5;
    return Container(
      height: h,
      child: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                        () => new EagerGestureRecognizer(),
                  ),
                ].toSet(),
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                        currentLocation.latitude, currentLocation.longitude),
                    zoom: 1),
                onMapCreated: (controller) {
                  getMarkres();
                  this.mapController.complete(controller);
                },
                mapType: MapType.normal,
                myLocationEnabled: true,
                padding: EdgeInsets.all(10),

                // Add little blue dot for device location, requires permission from user
                //                    markers: Set<Marker>.of(markers),
                markers: markers.toSet(),
                myLocationButtonEnabled: true),
          ),
          Positioned(
            top: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "s",
                  mini: true,
                  onPressed: () async {
//                    getGeo(_HebatListFromUsers[0]);
//                    final _firestore = Firestore.instance;
//                    final ref = _firestore.collection('locations');
//                    GeoFirePoint myLocation = geo.point(latitude: 12.960632, longitude: 77.641603);
//                    GeoFirePoint myLocation2 = geo.point(latitude: currentLocation.latitude, longitude: currentLocation.longitude);
//                    double radius = 50;
//                    String field = 'position';
//                    Stream<List<DocumentSnapshot>> stream = geo.collection(collectionRef: ref).within(center: myLocation, radius: radius, field: field);
//                    Map<String,dynamic> s ={'hName': 'random name','position': myLocation.data,'hebaId':"heba.id"};
//                    _firestore.collection('locations').add(s);
                  },
                  child: Icon(Icons.add),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  heroTag: "ss",
                  mini: true,
                  onPressed: () async {
                    setState(() {
                      markers.clear();
                    });
                  },
                  child: Icon(Icons.clear),
                ),
              ],
            ),
          ),
          Positioned(
            left: 1,
            bottom: 22,
            child: SizedBox(
              height: 100,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: ListView.builder(
                  reverse: true,
//                  key: _listKey,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _HebatListFromUsers.length,
                  itemBuilder: (context, index) {
//    SchedulerBinding.instance.addPostFrameCallback((_) {
//                      _HebatListFromUsers.sort(
//                          (a, b) => a.timestamp.compareTo(b.timestamp));
//                    });
                    print(_HebatListFromUsers);
                    return hebatCards(_HebatListFromUsers[index]);
                  },
                  padding: EdgeInsets.all(8.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

//  getGeo(HebaModel hebaModel)async{
//
//    final Geoflutterfire geoflutterfire = Geoflutterfire() ;
//    var geoRef = geoflutterfire.collection(collectionRef: publicpostsRef);
//     await geoRef.setPoint(hebaModel.id, "postion", hebaModel.geoFirePoint.latitude, hebaModel.geoFirePoint.longitude);
//
//  }

  Widget hebatCards(HebaModel post) {
    return Card(
      child: InkWell(
        onTap: () async {
          setState(() {
            currentHeba = post;
            currentBearing = 90.0;
          });
          await _getLocationOfHebaThenGoToIt(post);
        },
        child: Container(
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.transparent),
          child: Row(
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: Image.asset(
                    'assets/images/appicon.png',
                    color: Colors.grey.withOpacity(0.4),
                  )),
              Flexible(
                child: Text(post.hName),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller, HebaModel post) async {
//    await getMarkersFromList(post);

//    setState(() {
//      mapController = controller;
//    });
  }

  void editPost(DocumentSnapshot documentSnapshot) {
//    documentSnapshot.reference.updateData(data);
  }

  _getLocationAndGoToIt() async {
    print("_getLocationAndGoToIt :  Called");

    /// CurrentLocation
    currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print("userLocation :  $currentLocation");

    /// CameraPosition
    CameraPosition currentPosition = CameraPosition(
        bearing: 15.0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        tilt: 75.00,
        zoom: 12.0);
    GoogleMapController controller = await mapController.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
  }

  Future<void> _getLocationOfHebaThenGoToIt(HebaModel post) async {
    print("_getLocationOfHebaThenGoToIt :  Called");
    setState(() {
      currentHeba = post;
    });
    GoogleMapController controller = await mapController.future;

    /// Heba Position Cords
    LatLng latLng = new LatLng(
        currentHeba.geoPoint.latitude, currentHeba.geoPoint.longitude);

    /// Heba Position
    CameraPosition hebaPosition =
    CameraPosition(bearing: 15.0, target: latLng, tilt: 45.00, zoom: 14.0);

    /// Heba Camera Update
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(latLng, 14);
    CameraUpdate cameraUpdate2 = CameraUpdate.newCameraPosition(hebaPosition);

    controller.animateCamera(cameraUpdate);
    //              print("_getLocationOfHebaThenGoToIt :  Called");
//              final controller = await mapController.future;
//              var currentLocation = await Geolocator()
//                  .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
//              print("userLocation :  $currentLocation");
//
//              /// CameraPosition
//              CameraPosition hebaPosition = CameraPosition(
//                  bearing: 15.0,
//                  target: LatLng(23.22, 22.11),
//                  tilt: 45.00,
//                  zoom: 14.0);
//              LatLng latLng = new LatLng(post.geoPoint.latitude, post.geoPoint.longitude);
//              CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(latLng, 15);
//              controller.animateCamera(cameraUpdate);
////
//////              setState(() {
//////                resetToggle = true;
//////              });
  }
}
//viewMode(Post2 post) {
//  if (_displayPosts == 0) {
//    return GridView.count(
//      shrinkWrap: true,
//      physics: NeverScrollableScrollPhysics(),
//      // Create a grid with 2 columns. If you change the scrollDirection to
//      // horizontal, this produces 2 rows.
//      crossAxisCount: 2,
//      // Generate 100 widgets that display their index in the List.
//      children: List.generate(100, (index) {
//        return Center(
//          child: Text(
//            'Item $index',
//            style: Theme.of(context).textTheme.bodyText1,
//          ),
//        );
//      }),
//    );
//  } else if (_displayPosts == 1) {
//    return ListView.builder(
//        physics: NeverScrollableScrollPhysics(),
//        scrollDirection: Axis.vertical,
//        shrinkWrap: true,
//        reverse: true,
////              itemCount: map.data.documents.length,
//        itemCount: _HebatList.length,
//        padding: const EdgeInsets.only(top: 15.0),
//        itemBuilder: (context, index) {
////                DocumentSnapshot ds = map.data.documents[index];
////                DocumentSnapshot ds = map.data.documents[index];
////                      Post2 post2 = Post2.fromDoc(ds);
////                postFromFuture = Post2.fromFirestore(ds);
////                _HebaPostsFromDb(widget.post);
////                return rowView(_docsList[index], index);
//          return GestureDetector(
//            child: rowView(post, index),
//            onTap: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) =>
//                      HebaDetails(post: _HebatList[index], isMe: false, userId: widget.userId),
//                ),
//              );
//            },
//          );
//        });
//  } else if (_displayPosts == 2) {
//    return mMapView(context: context);
//  }
//}
