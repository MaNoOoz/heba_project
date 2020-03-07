import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/service/storage_service.dart';
import 'package:heba_project/ui/Screens/HomeScreen.dart';
import 'package:heba_project/ui/shared/CommanUtils.dart';
import 'package:heba_project/ui/shared/Dialogs.dart';
import 'package:heba_project/ui/shared/UtilsImporter.dart';
import 'package:heba_project/ui/shared/ui_helpers.dart';
import 'package:heba_project/ui/widgets/CustomDialog.dart';
import 'package:heba_project/ui/widgets/circular_clipper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  static final String id = 'CreatePostScreen';
  Key key;

//  const CreatePostScreen(
//      {Key key, this.primaryColor, this.backgroundColor, this.backgroundImage})
//      : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with SingleTickerProviderStateMixin {
  /// CustomProgressBar ====================================================
  /// https://mrflutter.com/how-to-use-progress-indicators-in-flutter/
  bool _loading;
  bool tappedYes = false;

  /// CustomProgressBar ====================================================
  /// Multi Image Picker ====================================================
  List<Asset> _readyToUploadImages = List<Asset>();
  Stream<Asset> _readyToUploadImages2; // test
  var imageUrl2;
  var uploadingState;
  var mSelectedImage;
  var mImagesPath;

  /// My Posts ====================================================
  var userId;
  var fuser;
  var fuserImage;

  String _error = 'No Error Dectected';

  /// Form ====================================================
  GlobalKey<FormState> _formkey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textFieldControllerName;
  TextEditingController _textFieldControllerDesc;
  TextEditingController _textFieldControllerLoca;

//  String _currentName;
  bool _autoValidate = false;
  String _name;
  String _desc;
  String _location;
  var color;
  bool showSpinner = false;

  ///  ====================================================

  @override
  void initState() {
    super.initState();
    _loading = false;

    _textFieldControllerName = TextEditingController();
    _textFieldControllerDesc = TextEditingController();
    _textFieldControllerLoca = TextEditingController();
    this._name = _textFieldControllerName.text;
    this._desc = _textFieldControllerDesc.text;
    this._location = _textFieldControllerLoca.text;
  }

  @override
  Widget build(BuildContext context) {
    fuser = Provider
        .of<FirebaseUser>(context)
        .displayName;
    fuserImage = Provider
        .of<FirebaseUser>(context)
        .photoUrl;

    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                    child: Hero(
                      tag: "widget.movie.imageUrl",
                      child: ClipShadowPath(
                        clipper: CircularClipper(),
                        shadow: Shadow(blurRadius: 20.0),
                        child: Image(
                          height: 400.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/addheba.gif"),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
//                    IconButton(
//                      padding: EdgeInsets.only(left: 30.0),
//                      onPressed: () =>
////                          Navigator.pushNamed(context, FeedScreen.id),
//                          Navigator.pop(context),
//                      icon: Icon(Icons.check),
//                      iconSize: 30.0,
//                      color: Colors.white,
//                    ),
//                  Image(
//                    image: AssetImage('assets/images/myIcon.png'),
//
//                  ),
                      Expanded(
                        child: Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'هبة جديدة',
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
//                  Padding(
//                    padding: const EdgeInsets.only(right: 20.0),
//                    child: IconButton(
//                      padding: EdgeInsets.only(left: 30.0),
//                      onPressed: () => print('Add to Favorites'),
//                      icon: Icon(Icons.favorite_border),
//                      iconSize: 30.0,
//                      color: Colors.black,
//                    ),
//                  ),
                      IconButton(
                        padding: EdgeInsets.only(right: 16.0),
                        onPressed: () =>
                            Navigator.pushNamed(context, HomeScreen.id),
                        icon: Icon(Icons.clear),
                        iconSize: 30.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),

              /// Form
              Container(
                margin: EdgeInsets.all(15.0),
                child: Form(
                  key: _formkey,
                  autovalidate: _autoValidate,
                  child: FormUI(),
                ),
              ),
              UIHelper.verticalSpaceWithGrayColor(1, Colors.teal),

              /// Titles
              Container(
                margin: EdgeInsets.all(15.0),
//            color: Colors.teal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      ' صور الهبة  ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              /// Added Images
              Card(
                child: Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          splashColor: Colors.teal,
                          iconSize: 42.0,
                          icon: _readyToUploadImages.length > 0
                              ? Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          )
                              : Icon(
                            Icons.add_circle,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {
                            _loadAssets();
                          },
                        ),
                        Text('أضف صورة')
                      ],
                    ),
                  ),
                ),
              ),
              buildGridView(),

              UIHelper.verticalSpace(10),

              /// Buttons
              _Buttons(),

              UIHelper.verticalSpace(10),

              /// Image
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: ClipRRect(
//              borderRadius: BorderRadius.all(
//                Radius.circular(50.0),
//              ),
//              child: Image.asset(
//                'assets/images/addheba.gif',
//                fit: BoxFit.fill,
//                scale: 13.0,
//              ),
//            ),
//          ),
            ],
          ),
        ),
      ),
    );

//
  }

  /// Methods ==========================================================================================
  _checkConnection() async {
    bool connectionResult = await CommanUtils.checkConnection();
    CommanUtils.showAlert(context, connectionResult ? "OK" : "internet needed");
  }

  showDialog(BuildContext context) {
    return CustomDialog(
      title: 'إضافة الإعلان',
      buttonText: 'Yes',
      description: 'ss',
      image: Image.asset(
        'assets/images/myIcon.png',
      ),
    );
  }

  showDialog2(BuildContext context) {
//    if (!_validateInputs() || imageUrl2 == null) {
    return AlertDialog(
      title: Text('جاري رفع الإعلان'),
      content: CircularProgressIndicator(),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Yes'),
        )
      ],
    );

//    } else {
//      return Container(
//        child: Text("sasdasd"),
//      );
//    }
  }

  progress() {}

  /// Form
  Future<bool> _validateInputs() async {
    if (_formkey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formkey.currentState.save();
      print(
          "From _validateInputs :  name $_name desc $_desc location $_location  ");
      return true;
    } else {
      return false;

////    If all data are not valid then start auto validation.
//      setState(() {
//        _autoValidate = true;
//      });
//░    }
//    return null;
    }
  }

  /// Multi Image Picker
  /// Selected Images
  Future<void> _loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: _readyToUploadImages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    // The data selected here comes back in the list
    print("Total Selected images is : ${resultList.length}");
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _readyToUploadImages = resultList;
      _error = error;
    });
  }

  Future<dynamic> _listOfImageLinks() async {
    var listOfImageLinks = [];
    for (var imageFile in _readyToUploadImages) {
      mSelectedImage = await StorageService.editedImages(imageFile);
      print(
          'From _listOfImageLinks() : image identifier is : ${imageFile
              .identifier}');
      print(
          "From _listOfImageLinks() : mUploadedImagePath : ${mSelectedImage
              .toString()}");
      listOfImageLinks.add(mSelectedImage);
    }

//    listOfImageLinks.add(mSelectedImage);
    return listOfImageLinks;
  }

  Future<Post2> _CreatePost() async {
    Post2 post2;
    print("_CreatePost Called");

//    var imageFile;

    mImagesPath = await _listOfImageLinks();

    /// private Post Object
//    post2 = Post2(
//        imageUrls: mImagesPath,
//        hName: _name,
//        hDesc: _desc,
//        hLocation: _location,
//        authorId: Provider.of<UserData>(context, listen: false).currentUserId,
//        timestamp: Timestamp.fromDate(DateTime.now()));
//    log("private ${post2.authorId}");

//    /// public Post Object
    post2 = Post2(
        oName: fuser,
        oImage: fuserImage,
        imageUrls: mImagesPath,
        hName: _name,
        hDesc: _desc,
        hLocation: _location,
        authorId: Provider
            .of<UserData>(context, listen: false)
            .currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()));
    log("public ${post2.oName}");

    /// private posts
    DatabaseService.createPost(post2);

    /// public posts
    DatabaseService.createPublicPosts(post2);

    log("after public posts ${post2.authorId}");
    print("onPressed Triggerd \n"
        "Post Object :  name : $_name desc : $_desc location: $_location \n"
        " images pathes : ${mImagesPath.length} "
        "Selected Images List : ${_readyToUploadImages.length} \n");
//    _displaySnackBar(context);

    setState(() {});
//    } else {
//      _displaySnackBar(context);
//    }
    return post2;
  }

  /// Reset data
  Future<bool> _Resetdata() async {
    var dateRested = true;
    print("_Resetdata Called");

    _textFieldControllerName.clear();
    _textFieldControllerDesc.clear();
    _textFieldControllerLoca.clear();
    _readyToUploadImages.clear();
    mImagesPath.clear();
    setState(() {
      _desc = '';
      _location = '';
      _name = '';
//      readyToUploadImages.length = -1;
//      listOfImageLinks.length = -1;
    });
    return dateRested;
  }

  /// Reset data
  Future<bool> _SendToServer() async {
    showSpinner = true;

    await Future.delayed(Duration(seconds: 4));
    var dataUploaded = false;

    /// Check Inputs
    var dataChecked = await _validateInputs();
    print('dataChecked $dataChecked');

    /// Create New Post
    var postCreated = await _CreatePost();
    print(' postCreated $postCreated');
    setState(() {
      dataChecked = true;
    });

    /// Rest Fields
    var fieldsRested = await _Resetdata();
    print('fieldsRested $fieldsRested');

    if (dataChecked == false || postCreated != null || fieldsRested == false) {
      dataUploaded = false;
      _displaySnackBar(context, " تم إضافة الهبة بنجاح");
      showSpinner = false;

      print("fieldsRested $fieldsRested  \n " +
          "dataChecked $dataChecked   \n    " +
          "fieldsRested $fieldsRested  \n   ");
    }
//    Navigator.pop(context);

    return dataUploaded;
  }

  /// Reset data
  void _displaySnackBar(BuildContext context, var s) async {
    print("_displaySnackBar Called");

//    if (mImagesPath = null || _name.isEmpty) {
    final snackBar = SnackBar(content: Text(s));
    _scaffoldKey.currentState.showSnackBar(snackBar);
//    } else if (mImagesPath.length < mSelectedImage) {
//      final snackBar = SnackBar(
//        content: Text('جاري رفع الإعلان'),
//      );
//      _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  /// Widgets ==========================================================================================
  Widget FormUI() {
    return Column(
      children: <Widget>[
        /// Name OF Heba
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            maxLength: 32,
            keyboardType: TextInputType.text,
            controller: _textFieldControllerName,
            maxLines: 1,
            style: UtilsImporter().uStyleUtils.loginTextFieldStyle(),
            decoration: UtilsImporter().uStyleUtils.textFieldDecorationCircle(
              hint: UtilsImporter().uStringUtils.hintName,
              lable: UtilsImporter().uStringUtils.lableFullname1,
              icon: Icon(Icons.card_giftcard),
            ),
            textDirection: TextDirection.rtl,
            validator: UtilsImporter().uCommanUtils.validateName,
            onSaved: (String val) {
              _name = val;
            },
            onChanged: (val) => setState(() => _name = val),
          ),
        ),

        /// Desc OF Heba
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            maxLength: 64,
            keyboardType: TextInputType.text,
            controller: _textFieldControllerDesc,
            maxLines: 1,
            style: UtilsImporter().uStyleUtils.loginTextFieldStyle(),
            decoration: UtilsImporter().uStyleUtils.textFieldDecorationCircle(
              hint: UtilsImporter().uStringUtils.hintDesc,
              lable: UtilsImporter().uStringUtils.lableFullname2,
              icon: Icon(Icons.description),
            ),
            textDirection: TextDirection.rtl,
            validator: UtilsImporter().uCommanUtils.validateDesc,
            onSaved: (String val) {
              _desc = val;
            },
            onChanged: (val) => setState(() => _desc = val),
          ),
        ),

        /// Location todo add pick up functions
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            maxLength: 32,
            controller: _textFieldControllerLoca,
            maxLines: 1,
            style: UtilsImporter().uStyleUtils.loginTextFieldStyle(),
            decoration: UtilsImporter().uStyleUtils.textFieldDecorationCircle(
              hint: UtilsImporter().uStringUtils.hintLocation,
              lable: UtilsImporter().uStringUtils.lableFullname3,
              icon: Icon(Icons.not_listed_location),
            ),
            textDirection: TextDirection.rtl,
            validator: UtilsImporter().uCommanUtils.validateLocation,
            onSaved: (String val) {
              _location = val;
            },
            onChanged: (val) => setState(() => _location = val),
          ),
        ),
      ],
    );
  }

  ///  ImagesLook
  Widget buildGridView() {
    return GridView.count(
      padding: const EdgeInsets.all(3.0),
      crossAxisCount: 5,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      // to disable GridView's scrolling
      children: List.generate(_readyToUploadImages.length, (index) {
        Asset images = _readyToUploadImages[index];
        return Center(
          child: AssetThumb(
            asset: images,
            width: 100,
            height: 100,
          ),
        );
      }),
    );
  }

  ///  Buttons
  _Buttons() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[
          /// Add Images Btn
          UIHelper.verticalSpace(10),

          Center(child: Text('Error: $_error')),
          UIHelper.verticalSpace(10),

          UIHelper.verticalSpace(10),

          _loading
              ? Padding(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightGreen,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
            padding: EdgeInsets.only(bottom: 10),
          )
              : SizedBox.shrink(),

          ///  Submit Btn
          OutlineButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            splashColor: Colors.lightGreen,
            color: Colors.green,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Center(
                      child: Text(
                        "إضافة الإعلان",
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45),
                      ),
                    ),
                  ),
                ),
//                Center(
//                  child: Icon(
//                    Icons.image,
//                    color: Colors.black,
//                  ),
//                )
              ],
            ),
            onPressed: () async {
              if (_name.isNotEmpty && !_loading) {
                final action = await Dialogs.yesAbortDialog(context,
                    ' Add Heba', 'Are You Sure You Wpant To Add This Post');
                if (action == DialogAction.yes) {
                  showDialog2(context);
                  await _CreatePost();
                  setState(() {
                    tappedYes = true;
                  });
                } else {
                  setState(
                        () {
                      tappedYes = false;
                      showSpinner = false;
                    },
                  );
                }
              } else if (_name.isNotEmpty == false) {
                _displaySnackBar(context, " أدخل إسم للهبة $_name");
              }
            },
          ),

          UIHelper.verticalSpace(10),
          UIHelper.verticalSpace(10),
        ],
      ),
    );
  }
}

//  final snackBar = SnackBar(content: Text('أكمل الحقول'));
//  _scaffoldKey.currentState.showSnackBar(snackBar);
//
//  final snackBar = SnackBar(content: Text('جاري رفع الإعلان'));
//  _scaffoldKey.currentState.showSnackBar(snackBar);

/// =======================================================================================

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
