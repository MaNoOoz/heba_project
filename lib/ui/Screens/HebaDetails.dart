/*
 * Copyright (c) 2020.  Made With Love By Yaman Al-khateeb
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/service/DatabaseService.dart';
import 'package:heba_project/ui/Screens/ChatScreen.dart';
import 'package:heba_project/ui/shared/Assets.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class HebaDetails extends StatefulWidget {
  final HebaModel heba;
  final DocumentSnapshot documentSnapshot;
  final bool isMe;
  final String currentUserId;

  HebaDetails(
      {this.heba, this.documentSnapshot, this.isMe, this.currentUserId});

  @override
  _HebaDetailsState createState() => _HebaDetailsState();
}

class _HebaDetailsState extends State<HebaDetails>
    with TickerProviderStateMixin {
  Logger logger = Logger();
  final key = new GlobalKey<ScaffoldState>();
  String contactMethod;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contactMethod = widget.heba.oContact;
  }

  @override
  Widget build(BuildContext context) {
    var listOfHebaImages =
        _getListOfImagesFromUser(widget.heba).cast<String>().toList();

    return Scaffold(
      key: key,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black45,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${widget.heba.hName}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: mDetailsPage(context, listOfHebaImages, widget.heba),
    );
  }

  List<dynamic> _getListOfImagesFromUser(HebaModel post2) {
    dynamic list = widget.heba.imageUrls;
    return list;
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  mDetailsPage(
      BuildContext context, List<String> listOfHebaImages, HebaModel post2) {
    Size screenSize = MediaQuery.of(context).size;
    var fUser = Provider.of<FirebaseUser>(context);
    TextEditingController _searchController = TextEditingController();
    var Btns = widget.isMe;
    // String chatRoomId =
    // getChatRoomId(helperFunctions.myName, post2.oName); // todo ?

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: ListView(children: <Widget>[
          /// Image Slider
          Container(
            height: 200,
            width: screenSize.width,
            child: Stack(
//              alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Container(
                    color: Colors.grey,
                    child: _ImageSlider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Container(
                        height: 30,
                        width: 60,
                        color: Colors.black26.withAlpha(80),
                        child: Container(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      "${listOfHebaImages.length} / ${listOfHebaImages.length}",
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Icon(
                                      FontAwesomeIcons.camera,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
          ),

          /// Body
          Container(
              color: Colors.white,
              width: screenSize.width,
              child: Column(children: <Widget>[
                /// First Row
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 20,
                              child: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.shareAlt,
                                  color: Colors.black54,
                                  size: 16,
                                ),
                                onPressed: () {
                                  Share.share(
                                      'check out my website https://example.com');
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                _displaySnackBar(context, "الإرسال");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 20,
                                  child: Icon(
                                    FontAwesomeIcons.flag,
                                    color: Colors.black54,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _displaySnackBar(context, "الإرسال");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: AlignmentDirectional.topEnd,
                                  child: Container(
                                    width: 20,
                                    child: Icon(
                                      FontAwesomeIcons.heart,
                                      color: Colors.black54,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            child: SizedBox(
                              width: 10,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Align(
                                alignment: AlignmentDirectional.topStart,
                                child: Container(
                                  child: Text(
                                    widget.heba.oName,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Align(
                                alignment: AlignmentDirectional.center,
                                child: Container(
                                  child: CircleAvatar(
                                    radius: 15.0,
                                    backgroundColor: Colors.white,
                                    backgroundImage: widget.heba.oImage.isEmpty
                                        ? AssetImage(
                                        'assets/images/user_placeholder.jpg')
                                        : CachedNetworkImageProvider(
                                        widget.heba.oImage),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                /// Contact Buttons
                Btns

                /// todo flip value  later
                    ? Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 40,
//                            width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: FloatingActionButton.extended(
                                  heroTag: "btn1",
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(5.0),
                                  ),
                                  elevation: 1.0,
                                  icon: const Icon(
                                    FontAwesomeIcons.phoneAlt,
                                    size: 16,
                                  ),
                                  label: const Text('إتصال',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900)),
                                  onPressed: () {
                                    launch("tel://$contactMethod");
                                    // launch('tel:+${contactMethod.toString()}');
                                    sendMessage(contactMethod);
                                    logger.d(contactMethod);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 40,
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: FloatingActionButton.extended(
                                  backgroundColor: Colors.green,
                                  heroTag: "btn2",
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(5.0),
                                  ),
                                  elevation: 1.0,
                                  icon: const Icon(
                                    FontAwesomeIcons.commentAlt,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    'علق',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 40,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: FloatingActionButton.extended(
                                  heroTag: "btn3",
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(5.0),
                                  ),
                                  elevation: 1.0,
                                  icon: const Icon(
                                    FontAwesomeIcons.comments,
                                    size: 16,
                                  ),
                                  label: const Text('دردش',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900)),
                                  onPressed: () {
                                    // FlutterOpenWhatsapp.sendSingleMessage(
                                    //     "${widget.heba.oContact}",
                                    //     "السلام عليكم بخصوص إتعلانك ${widget.heba.hName}");

                                    sendMessage(widget.heba.authorId);
                                    logger.d(
                                        "auther Id ${widget.heba.authorId}");
                                    logger.d(
                                        "user Id  ${widget.currentUserId}");
                                    logger.d(
                                        "ROOM ID  ${widget.currentUserId}");
//                                          todo Fix  Navigate to chat screen
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (_) => ChatView(
//                                                         chatRoomId: chatRoomId,
//                                                       )));
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                    : Container(),

                /// Body
                Divider(),

                /// hName
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.heba.hName}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                /// Location
                Container(
                  height: 80,
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          child: Container(
                            height: 60,
                            width: screenSize.width,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(2.0),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            "${widget.heba.hCity}",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.mapMarkerAlt,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// التفاصيل

                Card(
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                            Text(
                              "التفاصيل :",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54),
                            ),
                            Spacer(),
                            Flexible(
                              child: Text(
                                " ${widget.heba.hDesc}",
                                maxLines: 4,
                                softWrap: true,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /// التواصل
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        new ClipboardData(text: widget.heba.oContact));
                    key.currentState.showSnackBar(new SnackBar(
                      duration: Duration(milliseconds: 500),
                      content: new Text(
                        "تم النسخ",
                        style: TextStyle(fontFamily: ArabicFonts.Cairo),
                      ),
                    ));
                    // },
                  },
                  child: Card(
                    child: Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Row(
                            children: [
                              Text(
                                "التواصل :",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54),
                              ),
                              Spacer(),
                              new SelectableText(
                                "${widget.heba.oContact}",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54),
                              ),
                              Spacer(),
                              Icon(Icons.content_copy),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// Comments

                Divider(),

                ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 200),
                  child: Container(
                    color: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  "التعليقات",
                                  maxLines: 4,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 100,
                            width: screenSize.width,
                            child: Visibility(
                              visible: true,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(2.0),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: AlignmentDirectional.center,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Align(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: <Widget>[

                                                        /// Icons
                                                        Container(
                                                          width: 20,
                                                          child: IconButton(
                                                            icon: Icon(
                                                              FontAwesomeIcons
                                                                  .trash,
                                                              color: Colors
                                                                  .black54,
                                                              size: 16,
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Align(
                                                            alignment:
                                                            AlignmentDirectional
                                                                .center,
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 8.0,
                                                                  horizontal:
                                                                  8.0),
                                                              child: Container(
                                                                width: 20,
                                                                child:
                                                                IconButton(
                                                                  icon: Icon(
                                                                    FontAwesomeIcons
                                                                        .flag,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 16,
                                                                  ),
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Space
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          1.0),
                                                      child: Container(
                                                        child: SizedBox(
                                                          width: 10,
                                                        ),
                                                      ),
                                                    ),

                                                    Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(1.0),
                                                          child: Align(
                                                            alignment:
                                                            AlignmentDirectional
                                                                .center,
                                                            child: Container(
                                                              child: Text(
                                                                widget
                                                                    .heba.oName,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    11,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(1.0),
                                                          child: Align(
                                                            alignment:
                                                            AlignmentDirectional
                                                                .center,
                                                            child: Container(
                                                              child:
                                                              CircleAvatar(
                                                                radius: 15.0,
                                                                backgroundColor:
                                                                Colors
                                                                    .white,
                                                                backgroundImage: widget
                                                                    .heba
                                                                    .oImage
                                                                    .isEmpty
                                                                    ? AssetImage(
                                                                    'assets/images/user_placeholder.jpg')
                                                                    : CachedNetworkImageProvider(
                                                                    widget
                                                                        .heba
                                                                        .oImage),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ])),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              height: 60,
              width: screenSize.width,
              color: Colors.black12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Card(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(3.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 10.0),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextField(
                                autofocus: false,
                                textDirection: TextDirection.rtl,
                                onSubmitted: (input) {
                                  if (input.isNotEmpty) {
                                    setState(
                                          () {
//    _users = DatabaseService.searchUsers(input);
                                      },
                                    );
                                  }
                                },
                                controller: _searchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "أضف تعليق",
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            "أرسل",
                            maxLines: 4,
                            softWrap: true,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  _ImageSlider() {
    var imagesLength =
        _getListOfImagesFromUser(widget.heba)
            .cast<String>()
            .toList()
            .length;
    var imagesList =
    _getListOfImagesFromUser(widget.heba).cast<String>().toList();
    TabController imagesController =
    TabController(length: imagesLength, vsync: this);

    List<Widget> listOfImageWidget = [];
    listOfImageWidget.length = imagesLength;
    int _current = 0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 00.0),
      child: imagesList.isEmpty
          ? SizedBox(
        height: 200,
        child: Center(
          child: Image.asset(AvailableImages.appIcon),
        ),
      )
          : ImagesSlider(
        height: 200,
        items: map<Widget>(imagesList, (index, i) {
          print("listFromFirebase ${imagesList.length}");
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: widget.heba.imageUrls.isEmpty
                      ? Image.asset('assets/images/user_placeholder.jpg')
                      : NetworkImage(i),
                  fit: BoxFit.cover),
            ),
          );
        }),
        autoPlay: false,
        viewportFraction: 1.0,
        indicatorBackColor: Colors.grey,
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
    );

//    return Padding(
//      padding: const EdgeInsets.all(16.0),
//      child: Container(
//        height: 250.0,
//        child: Center(
//          child: DefaultTabController(
//            initialIndex: 0,
//            length: imagesLength,
//            child: Stack(
//              children: <Widget>[
//                TabBarView(
//                  controller: imagesController,
//                  children: <Widget>[
//                    Image.network(imagesList[0]),
//                    Image.network(imagesList[1]),
//                    Image.network(imagesList[2]),
//                  ],
//                ),
//                Container(
//                  alignment: FractionalOffset(0.5, 0.95),
//                  child: TabPageSelector(
//                    controller: imagesController,
//                    selectedColor: Colors.grey,
//                    color: Colors.white,
//                  ),
//                )
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
  }

  _buildDetailsAndMaterialWidgets() {
    TabController tabController = new TabController(length: 2, vsync: this);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "DETAILS",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "MATERIAL & CARE",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            height: 40.0,
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                Text(
                  "76% acrylic, 19% polyster, 5% metallic yarn Hand-wash cold",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  "86% acrylic, 9% polyster, 1% metallic yarn Hand-wash cold",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openChat(String url) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            WebviewScaffold(
              withJavascript: true,
              appCacheEnabled: true,
              resizeToAvoidBottomInset: true,
              url: url,
              appBar: AppBar(
                title: Text("S.of(context).message"),
                centerTitle: true,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                elevation: 0.0,
              ),
              withZoom: true,
              withLocalStorage: true,
              hidden: true,
              initialChild: Container(child: Text("context")),
            ),
        fullscreenDialog: true,
      ),
    );
  }

  bool canLaunchAppURL;

  IconButton getIconButton(IconData iconData, double iconSize, Color iconColor,
      String appUrl) {
    return IconButton(
      icon: Icon(
        iconData,
        size: iconSize,
        color: iconColor,
      ),
      onPressed: () async {
        if (await canLaunch(appUrl)) {
          if (appUrl.contains('http') && !appUrl.contains('wa.me')) {
            _openChat(appUrl);
          } else {
            await launch(appUrl);
          }
          setState(() {
            setState(() {
              canLaunchAppURL = true;
            });
          });
        } else {
          setState(() {
            canLaunchAppURL = false;
          });
        }
        if (!canLaunchAppURL) {
          final snackBar = SnackBar(
            content: Text(
              " S.of(context).canNotLaunch",
            ),
            action: SnackBarAction(
              label: "S.of(context).undo",
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

  sendMessage(String userName) {
    List<String> users = [widget.currentUserId, userName];

    String chatRoomId = getChatRoomId(widget.currentUserId, userName);
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };
    DatabaseService.addChatRoom(chatRoom, chatRoomId);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
            ChatScreen(
              chatRoomId: chatRoomId,
              loggedInUserUid: widget.currentUserId,
            )
    ));
  }


  _displaySnackBar(BuildContext context, String message) {
    key.currentState.showSnackBar(new SnackBar(
      duration: Duration(milliseconds: 500),
      content: new Text(
        "$message",
        style: TextStyle(fontFamily: ArabicFonts.Cairo),
      ),
    ));
  }

//  geenerateWidgets(int d) {
//    var textEditingControllers = <TextEditingController>[];
//
//    var ImageWidget = <Image>[];
//    var list = new List<int>.generate(d, (i) => i + 1);
//    print(list);
//
//    list.forEach((i) {
//      var textEditingController = new TextEditingController(text: "test $i");
//      textEditingControllers.add(textEditingController);
//      return ImageWidget.add(new Image());
//    });
//    return ImageWidget;
//  }

//rest of the methods
}
