/*
 * Copyright (c) 2020.  Made With Love By Yaman Al-khateeb
 */

/// CHAT Page ==================================================
//    messageWidget = new ChatMessageBubbles(
////      msg: mMessage,
////      isMe: me,
////      date: ts.toDate().toIso8601String(),
//////      animationController: new AnimationController(
//////        duration: new Duration(milliseconds: 700),
//////        vsync: this,
//////      ),
////    );
//
////    /// Add New Widget
////    setState(() {
////      listScrollController.animateTo(0.0,
////          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
////    });
//////    var mStream = StreamOfMessages = CHATS
//////        .document(widget.loggedInUserUid)
//////        .collection(USERCHATS)
//////        .document(_channelName)
//////        .collection(_channelName)
//////        .snapshots();
////    var me = widget.loggedInUserUid == widget.userId;
////
////    var list = await mMessagesFromDbAsStream();
////    print("list : ${list.length}}");
////
////    if (list.length > 0) {
////      for (var l in list) {
////        messageWidget = ChatMessageBubbles(
////          msg: l,
////          isMe: me,
////        );
////        _chatMessageWidgets.add(messageWidget);
////        print("_chatMessageWidgets : ${_chatMessageWidgets.length}}");
////      }
////    } else {
////      print("ERROR");
////    }
////  }
//
////  Future<String> createOneToOneChannelName() async {
////
////    var logedUserId = widget.loggedInUserUid;
////    var reciverUserId = widget.userId;
////    logedUserId = logedUserId.substring(0, 14);
////    reciverUserId = reciverUserId.substring(0, 14);
////    List<String> list = [logedUserId, reciverUserId];
////    list.sort();
////    _channelName = '${list[0]}-${list[1]}';
////    // cprint(_channelName); //2RhfE-5kyFB
////    return _channelName;
////  }
//Future<String> mReciverName(createdChannelName) async{
//  print("mReciverName : Called $createdChannelName");
//
//  User reciver;
//  User sender;
//
////    var usersRefd = usersRef.snapshots();
//  List<DocumentSnapshot> docs;
//  var querySnapshot = await usersRef.getDocuments();
//  docs = querySnapshot.documents;
//  List<String> IDS = [];
//  List<String> IDSAfterEdit = [];
//  List<User> users = [];
//  String recverName;
//
//  /// to show reciver name in app bar
//  String channelName = createdChannelName.split("-");
//  print("channelName : $channelName");
//
//  String senderFromchaneelName = channelName[0];
//
//  /// static
//  String reciverFromchaneelName = channelName[1];
//
//  /// static
//  for (var i = 0; i < docs.length; i++) {
//    DocumentSnapshot doc = docs[i];
//    reciver = User.fromFirestore(doc);
//    users.add(reciver);
//    print("users: ${users.length}");
//
//    IDS.add(docs[i].documentID);
//    for (var j = 0; j < IDS.length ; j++) {
//      String id = IDS[j].substring(0, 14);
//
//      IDSAfterEdit.add(id);
//      if(widget.userId == doc.documentID){
//        recverName = doc.data['name'];
//      }
//
//      bool ok = reciverFromchaneelName.compareTo(IDSAfterEdit[j]) == true;
//      if (ok == true) {
//        reciverId = reciverFromchaneelName;
//
//        print("reciverId: ${reciverId}");
//        print("id: ${id}");
//        print("recverName: ${recverName}");
//      } else {
//        reciverId = senderFromchaneelName;
//        String recverName = doc.data['name'];
//        print("reciverId: ${reciverId}");
//        print("id: ${id}");
//        print("recverName: ${recverName}");
//      }
//    }
//
//  }
//
//  setState(() {
//    recverNameInAppbar = recverName;
//    reciverInfo = reciver;
//  });
//
//  print("IDS: ${IDS.length}");
//  print("IDSAfterEdit: ${IDSAfterEdit.length}");
//  print("_chatUserList: ${_chatUserList.length}");
//
//
//  return recverNameInAppbar;
//}

/// OTHER Page ==================================================
//
//Widget searchFun() {
//	return Container(
//		height: 60,
//		child: Card(
//			color: Colors.white,
//			elevation: 3,
//			shape: new RoundedRectangleBorder(
//					borderRadius: new BorderRadius.circular(20.0)),
//			child: Padding(
//				padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
//				child: Directionality(
//					textDirection: TextDirection.rtl,
//					child: TextField(
//						autofocus: false,
//						textDirection: TextDirection.rtl,
//						onSubmitted: (input) {
//							if (input.isNotEmpty) {
//								setState(
//											() {
////                      _chats = DatabaseService.searchUsers(input);
//									},
//								);
//							}
//						},
//						controller: _searchController,
//						decoration: InputDecoration(
//							border: InputBorder.none,
//							suffixIcon: Icon(CupertinoIcons.search),
//							hintText: "إبحث",
//							hintStyle: TextStyle(
//								fontSize: 12,
//								fontWeight: FontWeight.normal,
////                  color: Colors.grey.withOpacity(0.6),
//							),
//						),
//					),
//				),
//			),
//		),
//	);
//}
//
//
//Widget searchFun2() {
//	return Container(
////      height: 60,
//		child: Padding(
//			padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 1.0),
//			child: Directionality(
//				textDirection: TextDirection.rtl,
//				child: new TextFormField(
//					autofocus: false,
//					textDirection: TextDirection.rtl,
//					decoration: new InputDecoration(
//						labelText: "إبحث",
//
//						fillColor: Colors.white,
//						border: new OutlineInputBorder(
//							borderRadius: new BorderRadius.circular(5.0),
//							borderSide: new BorderSide(),
//						),
//						//fillColor: Colors.green
//					),
//					validator: (val) {
//						if (val.length == 0) {
//							return "Email cannot be empty";
//						} else {
//							return null;
//						}
//					},
//					keyboardType: TextInputType.emailAddress,
//					style: new TextStyle(
//						fontFamily: "Poppins",
//					),
//				),
//			),
//		),
//	);
//}

//Widget showBtnSheetForMap(BuildContext context) {
//  var h = MediaQuery.of(context).size.height / 2;
//
//  mBottomSheetForFiltiring = showModalBottomSheet(
//	 backgroundColor: Colors.transparent,
//	 context: context,
//	 builder: (context) {
//	   return Container(
//		height: h + 50,
//		decoration: BoxDecoration(
//		  color: Colors.white,
//		  borderRadius: BorderRadius.only(
//		    topLeft: Radius.circular(50),
//		    topRight: Radius.circular(50),
//		  ),
//		),
//		child: Stack(
//		  children: <Widget>[
//		    Container(
//			 child: GoogleMap(
//			   gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
//				new Factory<OneSequenceGestureRecognizer>(
//					 () => new EagerGestureRecognizer(),
//				),
//			   ].toSet(),
//			   onMapCreated: (GoogleMapController controller) {
//				_controller.complete(controller);
//			   },
//			   onCameraMove: _onCameraMove,
//			   mapType: MapType.normal,
//			   myLocationButtonEnabled: true,
//			   initialCameraPosition: CameraPosition(
//				target: _center,
//				zoom: 11,
//			   ),
//			   //                    markers: _markers.values.toSet(),
//			   markers: _markers,
//			 ),
//		    ),
//		    //                Positioned(
//		    //                  bottom: 50,
//		    //                  right: 10,
//		    //                  child: Column(
//		    //                    children: <Widget>[
//		    //                      RawMaterialButton(
//		    //                        child: Icon(
//		    //                          CupertinoIcons.location_solid,
//		    //                          color: Colors.black38,
//		    //                          size: 30.0,
//		    //                        ),
//		    //                        shape: CircleBorder(),
//		    //                        elevation: 0.0,
//		    //                        fillColor: Colors.white,
//		    //                        padding: const EdgeInsets.all(8.0),
//		    //                        onPressed: () async {
//		    ////                                Navigator.of(context).pop();
//		    //                          _onAddMarkerButtonPressed(context);
//		    //                        },
//		    //                      ),
//		    //                    ],
//		    //                  ),
//		    //                )
//		  ],
//		),
//	   );
//	 });
//  //    return mBottomSheetForFiltiring;
//}

//static void followUser({String currentUserId, String userId}) {
//// Add user to current user's following collection
//followingRef
//    .document(currentUserId)
//    .collection('userFollowing')
//    .document(userId)
//    .setData({});
//// Add current user to user's followers collection
//followersRef
//    .document(userId)
//    .collection('userFollowers')
//    .document(currentUserId)
//    .setData({});
//}
//
//static void unfollowUser({String currentUserId, String userId}) {
//// Remove user from current user's following collection
//followingRef
//    .document(currentUserId)
//    .collection('userFollowing')
//    .document(userId)
//    .get()
//    .then((doc) {
//if (doc.exists) {
//doc.reference.delete();
//}
//});
//// Remove current user from user's followers collection
//followersRef
//    .document(userId)
//    .collection('userFollowers')
//    .document(currentUserId)
//    .get()
//    .then((doc) {
//if (doc.exists) {
//doc.reference.delete();
//}
//});
//}
//
//static Future<bool> isFollowingUser(
//{String currentUserId, String userId}) async {
//DocumentSnapshot followingDoc = await followersRef
//    .document(userId)
//.collection('userFollowers')
//.document(currentUserId)
//.get();
//return followingDoc.exists;
//}
//
//static Future<int> numFollowing(String userId) async {
//QuerySnapshot followingSnapshot = await followingRef
//    .document(userId)
//.collection('userFollowing')
//.getDocuments();
//return followingSnapshot.documents.length;
//}
//
//static Future<int> numFollowers(String userId) async {
//QuerySnapshot followersSnapshot = await followersRef
//    .document(userId)
//.collection('userFollowers')
//.getDocuments();
//return followersSnapshot.documents.length;
//}
//
//static void likePost({String currentUserId, Post2 post}) {
//DocumentReference postRef = postsRef
//    .document(post.authorId)
//    .collection('userPosts')
//    .document(post.id);
//postRef.get().then((doc) {
//int likeCount = doc.data['likeCount'];
//postRef.updateData({'likeCount': likeCount + 1});
//likesRef
//    .document(post.id)
//    .collection('postLikes')
//    .document(currentUserId)
//    .setData({});
//});
//}
//
//static void unlikePost({String currentUserId, Post2 post}) {
//DocumentReference postRef = postsRef
//    .document(post.authorId)
//    .collection('userPosts')
//    .document(post.id);
//postRef.get().then((doc) {
//int likeCount = doc.data['likeCount'];
//postRef.updateData({'likeCount': likeCount - 1});
//likesRef
//    .document(post.id)
//    .collection('postLikes')
//    .document(currentUserId)
//    .get()
//    .then((doc) {
//if (doc.exists) {
//doc.reference.delete();
//}
//});
//});
//}
//
//static Future<bool> didLikePost({String currentUserId, Post2 post}) async {
//DocumentSnapshot userDoc = await likesRef
//    .document(post.id)
//.collection('postLikes')
//.document(currentUserId)
//.get();
//return userDoc.exists;
//}
//
////  todo
////  static Future<User> getUsersFromChat(
//////      {String currentUserId, String userId, Chat chat}) async {
//////    QuerySnapshot messagesSnapshots = await contacts
//////        .document(currentUserId)
//////        .collection('userChats')
//////        .document(chat.chatId)
//////        .collection("messages")
//////        .orderBy('timestamp', descending: true)
//////        .getDocuments();
//////
//////    if (messagesSnapshots.documents.length > 0) {
//////      print("U Have  ${messagesSnapshots.documents.length} Messages");
//////    } else if (messagesSnapshots.documents.length <= 0) {
//////      print(
//////          "Error U Dont Have  Messages ${messagesSnapshots.documents.length}");
//////    }
//////    List<Message> messages = messagesSnapshots.documents
//////        .map((doc) => Message.fromFirestore(doc))
//////        .toList();
//////    return messages;
//////  }

//Future<dynamic> _listOfImageLinks() async {
//  var listOfImageLinks = [];
//  for (var imageFile in _readyToUploadImages) {
//    mSelectedImage = await StorageService.editedImages(imageFile);
//    print(
//        'From _listOfImageLinks() : image identifier is : ${imageFile.identifier}');
//    print(
//        "From _listOfImageLinks() : mUploadedImagePath : ${mSelectedImage.toString()}");
//    listOfImageLinks.add(mSelectedImage);
//  }
//
////    listOfImageLinks.add(mSelectedImage);
//  return listOfImageLinks;
//}

//Widget contentGrid(List<String> listFromFirebase, Post2 post, int _current) {
//  var size = MediaQuery.of(context).size;
//  /*24 is for notification bar on Android*/
//  final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
//  final double itemWidth = size.width / 2;
//
//  var child = GridTile(
//    child: Card(
//      elevation: 5,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          Container(color: Colors.yellow, child: Text(post.oName)),
//          Container(
//            color: Colors.green,
//            child: Text(
//              "${timeago.format(post.timestamp.toDate())}",
//            ),
//          ),
//          Expanded(
//            child: Container(
//              child: listFromFirebase.isEmpty
//                  ? Center(
//                child: Image.asset(
//                  'assets/images/appicon.png',
//                  color: Colors.grey.withOpacity(0.4),
//                ),
//              )
//                  : ImagesSlider(
//                items: map<Widget>(listFromFirebase, (index, i) {
////                print("listFromFirebase ${listFromFirebase.length}");
//                  return Container(
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.only(
//                        bottomLeft: Radius.zero,
//                        bottomRight: Radius.circular(0),
//                        topLeft: Radius.zero,
//                        topRight: Radius.circular(0),
//                      ),
//                      image: DecorationImage(
//                          image: NetworkImage(i), fit: BoxFit.cover),
//                    ),
//                  );
//                }),
//                autoPlay: false,
//                viewportFraction: 1.0,
//                indicatorColor: Colors.grey,
//                aspectRatio: 1.0,
//                distortion: true,
//                align: IndicatorAlign.bottom,
//                indicatorWidth: 1,
//                indicatorBackColor: Colors.black38,
//                updateCallback: (index) {
//                  setState(
//                        () {
//                      _current = index;
//                    },
//                  );
//                },
//              ),
//            ),
//          ),
//          Container(
//            height: 30,
//            child: Directionality(
//              textDirection: TextDirection.rtl,
//              child: Text(
//                post.hName,
//                textDirection: TextDirection.rtl,
//                maxLines: 1,
//                textAlign: TextAlign.end,
//                style: TextStyle(
//                    color: Colors.black, fontWeight: FontWeight.bold),
//              ),
//            ),
//
//            /// texts
//          ),
//          Container(
//            height: 30,
//            child: Directionality(
//              textDirection: TextDirection.rtl,
//              child: Text(
//                post.hName,
//                textDirection: TextDirection.rtl,
//                maxLines: 1,
//                textAlign: TextAlign.end,
//                style: TextStyle(
//                    color: Colors.black, fontWeight: FontWeight.bold),
//              ),
//            ),
//
//            /// texts
//          ),
//          Container(
//            height: 30,
//            child: Directionality(
//              textDirection: TextDirection.rtl,
//              child: Text(
//                post.hName,
//                textDirection: TextDirection.rtl,
//                maxLines: 1,
//                textAlign: TextAlign.end,
//                style: TextStyle(
//                    color: Colors.black, fontWeight: FontWeight.bold),
//              ),
//            ),
//
//            /// texts
//          ),
//        ],
//      ),
//    ),
//  );
//
//  List<GridTile> tiles = [];
//  tiles.add(child);
//
//  return GridView.count(
//    padding: EdgeInsets.all(10),
//    crossAxisCount: 1,
//    childAspectRatio: 0.6,
//    mainAxisSpacing: 0.4,
//    crossAxisSpacing: 0.3,
//    shrinkWrap: true,
//    physics: NeverScrollableScrollPhysics(),
//    children: tiles,
//  );
//}

//Widget mapCard() {
//  var h = MediaQuery.of(context).size.height / 5;
//
//  return Column(
//    children: <Widget>[
//      Text("تحديد الموقع "),
////        Text("${locationName}"),
//      Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Card(
//          child: Container(
//            height: h + 50,
//            decoration: BoxDecoration(
//              color: Colors.white,
//              borderRadius: BorderRadius.only(
//                topLeft: Radius.circular(50),
//                topRight: Radius.circular(50),
//              ),
//            ),
//            child: Stack(
//              children: <Widget>[
//                Container(
//                  child: GoogleMap(
//                    gestureRecognizers:
//                    <Factory<OneSequenceGestureRecognizer>>[
//                      new Factory<OneSequenceGestureRecognizer>(
//                            () => new EagerGestureRecognizer(),
//                      ),
//                    ].toSet(),
//                    onMapCreated: (GoogleMapController controller) async {
//                      await _startQuery();
//
//                      _controller.complete(controller);
//                    },
//                    onCameraMove: _onCameraMove,
//                    mapType: MapType.normal,
//                    myLocationButtonEnabled: true,
//                    initialCameraPosition: CameraPosition(
//                      target: _center,
//                      zoom: 11,
//                    ),
////                    markers: _markers.values.toSet(),
//                    markers: _markers,
//                  ),
//                ),
//                Positioned(
//                  bottom: 10,
//                  right: 1,
//                  child: Column(
//                    children: <Widget>[
//                      RawMaterialButton(
//                        fillColor: Colors.green,
//                        child: Icon(
//                          CupertinoIcons.location_solid,
//                          color: Colors.white,
//                          size: 22.0,
//                        ),
//                        shape: CircleBorder(),
//                        elevation: 0.0,
//                        hoverColor: Colors.green,
//                        onPressed: () async {
//                          print("pos ${current_location.latitude}");
////                            await _getLocationAndGoToIt(context);
//                          _onAddMarkerButtonPressed(context);
////                          _addGeoPoint(context);
//                        },
//                      ),
//                    ],
//                  ),
//                )
//              ],
//            ),
//          ),
//        ),
//      ),
//    ],
//  );
//}
//Widget FormUi() {
//  return Container(
//    margin: EdgeInsets.all(15.0),
//    child: Form(
//      key: _formkey,
//      autovalidate: _autoValidate,
//      child: Column(
//        children: <Widget>[
//          /// Name OF Heba
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: TextFormField(
//              maxLength: 32,
//              keyboardType: TextInputType.text,
//              controller: _textFieldControllerName,
//              maxLines: 1,
//              style: UtilsImporter().uStyleUtils.loginTextFieldStyle(),
//              decoration:
//              UtilsImporter().uStyleUtils.textFieldDecorationCircle(
//                hint: UtilsImporter().uStringUtils.hintName,
//                lable: UtilsImporter().uStringUtils.lableFullname1,
//                icon: Icon(Icons.card_giftcard),
//              ),
//              textDirection: TextDirection.rtl,
//              validator: UtilsImporter().uCommanUtils.validateName,
//              onSaved: (String val) {
//                _name = val;
//              },
//              onChanged: (val) => setState(() => _name = val),
//            ),
//          ),
//
//          /// Desc OF Heba
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: TextFormField(
//              maxLength: 64,
//              keyboardType: TextInputType.text,
//              controller: _textFieldControllerDesc,
//              maxLines: 1,
//              style: UtilsImporter().uStyleUtils.loginTextFieldStyle(),
//              decoration:
//              UtilsImporter().uStyleUtils.textFieldDecorationCircle(
//                hint: UtilsImporter().uStringUtils.hintDesc,
//                lable: UtilsImporter().uStringUtils.lableFullname2,
//                icon: Icon(Icons.description),
//              ),
//              textDirection: TextDirection.rtl,
//              validator: UtilsImporter().uCommanUtils.validateDesc,
//              onSaved: (String val) {
//                _desc = val;
//              },
//              onChanged: (val) => setState(() => _desc = val),
//            ),
//          ),
//
//          SizedBox(
//            height: 10,
//          ),
//        ],
//      ),
//    ),
//  );
//}

//Widget _buildListItem(
//    BuildContext context, DocumentSnapshot map, User user) {
//  final post = Post2.fromSnapshot(map);
//  if (post == null) {
//    return Container();
//  }
//
//  return viewType(post, user);
//}

//  Widget mHebatList(
//      BuildContext context, List<DocumentSnapshot> map, User user) {
//    return SingleChildScrollView(
//      physics: ScrollPhysics(),
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          /// todo Fix GridView
//          ListView(
//            physics: NeverScrollableScrollPhysics(),
//            shrinkWrap: true,
//            padding: const EdgeInsets.only(top: 20.0),
//            children: map
//                .map((data) => _buildListItem(context, data, user))
//                .toList(),
//          ),
////          new ListView.builder(
////              physics: NeverScrollableScrollPhysics(),
////              scrollDirection: Axis.vertical,
////              shrinkWrap: true,
////              itemCount: map.length,
////              padding: const EdgeInsets.only(top: 15.0),
////              itemBuilder: (context, index) {
//////                      Post2 post2 = Post2.fromDoc(ds);
////                return GestureDetector(
////                    onTap: () {
////                      print("${index} ");
////                      Navigator.push(
////                        context,
////                        MaterialPageRoute(
////                          builder: (context) => HebaDetails(_docsList[index]),
////                        ),
////                      );
////                    },
////                    child: viewType(postFromFuture, user));
////              }),
//        ],
//      ),
//    );
//  }
//  Widget feedView(Post2 post, User user) {
//    return Container(
//      height: 100,
//      color: Colors.blueAccent,
//      child: ListView.builder(
//        shrinkWrap: true,
//        itemCount: _docsList.length,
//        itemBuilder: (context, index) {
//          return FutureBuilder<QuerySnapshot>(
//            future: publicpostsRef.getDocuments(),
//            builder: (BuildContext context, map) {
//              switch (map.connectionState) {
//                case ConnectionState.waiting:
//                  return Center(child: CircularProgressIndicator());
//                  break;
//                case ConnectionState.active:
//                  break;
//                case ConnectionState.done:
//                  break;
//                case ConnectionState.none:
//                  break;
//              }
//
//              if (map.hasData) {
//                print("${querDb()}");
//                Text("${post.hName}");
//                Text("${user.name}");
//              } else if (map.hasError) {
//                print("${map.error}");
//              }
//              return Text("${post.id}");
//
//////                return postsList(
//////                    postList: _docsList,
//////                    onSelected: () {
//////                      print("object");
//////                    });
//////                return Text("${post.id}");
////
////                return RowView(
////                  context: context,
////                  post: post,
////                );
//            },
//          );
//        },
//      ),
//    );
//  }
//Future<List<Post2>> _getPosts() async {
//  List<Post2> list = [];
//  QuerySnapshot qn = await publicpostsRef.getDocuments();
//  List<DocumentSnapshot> documents = qn.documents;
//  documents.forEach((DocumentSnapshot doc) {
//    Post2 post = new Post2.fromDoc(doc);
//    list.add(post);
//  });
//
//  return list;
//}

//_checkConnection() async {
//  bool connectionResult = await CommanUtils.checkConnection();
//  CommanUtils.showAlert(context, connectionResult ? "OK" : "internet needed");
//}

/**
 * docs :
    synchronous operation: A synchronous operation blocks other operations from executing until it completes.
    synchronous function: A synchronous function only performs synchronous operations.
    asynchronous operation: Once initiated, an asynchronous operation allows other operations to execute before it completes.
    asynchronous function: An asynchronous function performs at least one asynchronous operation and can also perform synchronous operations.
 */

/// Backup
//Future<bool> uploadFile(int imageId, int duration) async {
//  print('uploadFile Called');
//  await Future.delayed(Duration(seconds: 1));
//  print('uploadFile Complate for $imageId');
//
////    for (var imageFile in readyToUploadImages) {
////      print('FROM UploadImageList() : image identifier is : ${imageFile.identifier}');
////      mUploadedImagePath = await editedImages(imageFile);
////      print("FROM UploadImageList() : mUploadedImagePath : ${mUploadedImagePath.toString()}");
////    }
////
////    /// Check if All Images are Uploaded
////    if (readyToUploadImages.length == listOfImageLinks.length) {
////      print(
////          'FROM UploadImageList() : Upload Finished and the total images are : ${readyToUploadImages.length} image');
////      listOfImageLinks.add(mUploadedImagePath);
////
////    } else {
////      print('FROM UploadImageList() : Something Wrong With This metheod Bro');
////    }
//  return true;
//}
//
//Future uploadFiles() async {
//  var futures = List<Future>();
////
////    for (var i = 0; i < listOfImageLinks.length; i++) {
////      futures.add(uploadFile(i, listOfImageLinks.length));
////    }
////    print('started downloads');
////    await Future.wait(futures);
////    print(' downloads Complated');
//
//  for (var imageFile in readyToUploadImages) {
//    print('FROM UploadImageList() : image identifier is : ${imageFile.identifier}');
//    futures.add(editedImages(readyToUploadImages.length,imageFile));
//    mUploadedImagePath = await editedImages(int.fromEnvironment(imageFile.identifier),imageFile);
//    print("FROM UploadImageList() : mUploadedImagePath : ${mUploadedImagePath.toString()}");
//  }
//  print('Start Uploads');
//  /// Check if All Images are Uploaded
//  if (readyToUploadImages.length == listOfImageLinks.length) {
//    print(
//        'FROM UploadImageList() : Upload Finished and the total images are : ${readyToUploadImages.length} image');
//    listOfImageLinks.add(mUploadedImagePath);
//    await Future.wait(futures);
//    print(' Upload Complate');
//
//  } else {
//    print('FROM UploadImageList() : Something Wrong With This metheod Bro');
//  }
//
//
//}
/// Json - Future from assets error handling
//              print("Added  ${_name} ${_desc} ${_location}");
//              print('Started');
//
//              /// error handling todo Move This logic to submit btn later ok !!
//              var testErrorFrom =
//                  await student().loadAStudentAsset().catchError((onError) {
//                print(onError);
//                CommanUtils().showSnackbar(context, 'مشكلة في ملف ال json ');
//              });
//              student().loadAStudentAsset().then((value) {
//                print('future finished');
//              }).catchError((error) {
//                print(error);
//              });
//              print(_error);

/// good stuff
/// progress
//Widget progress() {
//  return Container(
//    alignment: Alignment.center,
//    child: Column(
//      mainAxisAlignment: MainAxisAlignment.center,
//      crossAxisAlignment: CrossAxisAlignment.center,
//      children: <Widget>[
//        Container(
//          height: 200.0,
//          width: 200.0,
//          padding: EdgeInsets.all(20.0),
//          margin: EdgeInsets.all(30.0),
//          child: progressView(),
//        ),
//        OutlineButton(
//          child: Text("START"),
//          onPressed: () {
//            startProgress();
//          },
//        )
//      ],
//    ),
//  );
//}
//
/////  ==========================================================================================
//initAnimationController() {
//  _progressAnimationController = AnimationController(
//    vsync: this,
//    duration: Duration(milliseconds: 1000),
//  )..addListener(
//        () {
//      setState(() {
//        _percentage = lerpDouble(_percentage, _nextPercentage,
//            _progressAnimationController.value);
//      });
//    },
//  );
//}
//
//start() {
//  Timer.periodic(Duration(milliseconds: 30), handleTicker);
//}
//
//handleTicker(Timer timer) {
//  _timer = timer;
//  if (_nextPercentage < 100) {
//    publishProgress();
//  } else {
//    timer.cancel();
//    setState(() {
//      _progressDone = true;
//    });
//  }
//}
//
//startProgress() {
//  if (null != _timer && _timer.isActive) {
//    _timer.cancel();
//  }
//  setState(() {
//    _percentage = 0.0;
//    _nextPercentage = 0.0;
//    _progressDone = false;
//    start();
//  });
//}
//
//publishProgress() {
//  setState(() {
//    _percentage = _nextPercentage;
//    _nextPercentage += 0.5;
//    if (_nextPercentage > 100.0) {
//      _percentage = 0.0;
//      _nextPercentage = 0.0;
//    }
//    _progressAnimationController.forward(from: 0.0);
//  });
//}
//
//getDoneImage() {
//  return Image.asset(
//    'assets/images/appicon.png',
//    width: 50,
//    height: 50,
//  );
//}
//
//getProgressText() {
//  return Text(
//    _nextPercentage == 0 ? '' : '${_nextPercentage.toInt()}',
//    style: TextStyle(
//        fontSize: 40, fontWeight: FontWeight.w800, color: Colors.green),
//  );
//}
//
//progressView() {
//  return CustomPaint(
//    child: Center(
//      child: _progressDone ? getDoneImage() : getProgressText(),
//    ),
//    foregroundPainter: ProgressPainter(
//        defaultCircleColor: Colors.amber,
//        percentageCompletedCircleColor: Colors.green,
//        completedPercentage: _percentage,
//        circleWidth: 50.0),
//  );
//}
//
/////  ==========================================================================================
