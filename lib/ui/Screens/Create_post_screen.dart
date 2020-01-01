import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/ui/Screens/HomeScreen.dart';
import 'package:heba_project/ui/shared/UtilsImporter.dart';
import 'package:heba_project/ui/shared/ui_helpers.dart';
import 'package:heba_project/widgets/CustomDialog.dart';
import 'package:heba_project/widgets/circular_clipper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  /// Multi Image Picker ====================================================
  List<Asset> readyToUploadImages = List<Asset>();
  Stream<Asset> readyToUploadImages2;

  var imageUrl2;
  var uploadingState;

  /// My Posts ====================================================
  var userId;

//  List<Asset> fakeList;

  // todo Strings >???
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

  @override
  void initState() {
    super.initState();
    _textFieldControllerName = TextEditingController();
    _textFieldControllerDesc = TextEditingController();
    _textFieldControllerLoca = TextEditingController();
    this._name = _textFieldControllerName.text;
    this._desc = _textFieldControllerDesc.text;
    this._location = _textFieldControllerLoca.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
//      resizeToAvoidBottomPadding: false,

      body: ListView(
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
                  IconButton(
                    padding: EdgeInsets.only(left: 30.0),
                    onPressed: () =>
                        Navigator.pushNamed(context, HomeScreen.id),
                    // todo Fix Nav please
                    icon: Icon(Icons.check),
                    iconSize: 30.0,
                    color: Colors.white,
                  ),
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
                    // todo Fix Nav please
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
                      icon: readyToUploadImages.length > 0
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

//          buildGridView2(),
          _Buttons(),
//todo Fix Must not be null Error
//          FutureBuilder<bool>(
//            future: _CreatePost(),
//            builder: (BuildContext context, AsyncSnapshot snapshot) {
//              if (snapshot.hasError) {
//                return Center(child: Text('مشكلة في إنشاء الهبة '));
//              } else if (snapshot.hasData) {
//                return Center(child: Text('تم إنشاء الهبة بنجاح🤣 '));
//              } else {
//                return Center(child: Text('No Value'));
//              }
//            },
//          ),

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
    );

//
  }

  /// Methods ==========================================================================================
  /// Form
  bool _validateInputs() {
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
        selectedAssets: readyToUploadImages,
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
      readyToUploadImages = resultList;
      _error = error;
    });
  }

  var mSelectedImage;
  var listOfImageLinks = [];

//  Future UploadImageList() async {
//
//    // Todo Check if All Images are Uploaded
////    if (readyToUploadImages.length == listOfImageLinks.length) {
////      print(
////          'FROM UploadImageList() : Upload Finished and the total images are : ${readyToUploadImages.length} image');
////    } else {
////      print('FROM UploadImageList() : Something Wrong With This metheod Bro');
////    }
////    Future.delayed(Duration(seconds: 1)).then((_) {
////      Scaffold.of(context).showSnackBar(SnackBar(
////          backgroundColor: Colors.teal,
////          content: Text('Data Added  From Future')));
////    });
//
//
//  }

  /// Edit  Images before upload to Database
  Future<String> editedImages(Asset imageFile) async {
//    await imageFile.requestOriginal();
    ByteData byteData = await imageFile.requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData(imageData);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String mDownloadUR = await storageTaskSnapshot.ref.getDownloadURL();
    return mDownloadUR;
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
      children: List.generate(readyToUploadImages.length, (index) {
        Asset images = readyToUploadImages[index];
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
  Widget _Buttons() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[

          /// Add Images Btn
          UIHelper.verticalSpace(10),

          Center(child: Text('Error: $_error')),
          UIHelper.verticalSpace(10),

          UIHelper.verticalSpace(10),

          ///  Submit Btn
          FlatButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            splashColor: Colors.white,
            color: Colors.amber,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "إضافة الإعلان",
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            onPressed: () async {
              await _SendToServer();
              showDialog();
//              print("onPressed Triggerd \n"
//                  "Post Object :  name : $_name desc : $_desc location: $_location \n"
//                  " images pathes : ${listOfImageLinks.length} "
//                  "Selected Images List : ${readyToUploadImages.length} \n");

//              Navigator.push(
//                context,
//                MaterialPageRoute<void>(
//                  builder: (BuildContext context) => Loading(),
////                  fullscreenDialog: true,
//                ),
//              );
            },
          ),

          UIHelper.verticalSpace(10),
          UIHelper.verticalSpace(10),
        ],
      ),
    );
  }

  /// Functions ==========================================================================================

  _CreatePost() async {
    print("_CreatePost Called");

    var imageFile;
    var mPostCreated = false;

    if (!_validateInputs()) {
      try {
        await for (imageFile in readyToUploadImages2) {
          print(
              'FROM _CreatePost() : image identifier is : ${imageFile
                  .identifier}');
          mSelectedImage = await editedImages(imageFile);

          print(
              "FROM UploadImageList() : mUploadedImagePath : ${mSelectedImage
                  .toString()}");
        }

        listOfImageLinks.add(mSelectedImage);
        mPostCreated = true;

        if (mPostCreated == true) {
          Post2 post2 = Post2(
              imageUrls: listOfImageLinks,
              hName: _name,
              hDesc: _desc,
              hLocation: _location,
              authorId: Provider
                  .of<UserData>(context)
                  .currentUserId,
              timestamp: Timestamp.fromDate(DateTime.now()));
          DatabaseService.createPost2(post2);
          mPostCreated = true;
        } else {
          print('mPostCreated = false ');
        }
      } finally {
        print('all done');
      }

      setState(() {});
    } else {
      _displaySnackBar(context);
    }
  }

  _Resetdata() {
    print("_Resetdata Called");

    /// Reset data
    _textFieldControllerName.clear();
    _textFieldControllerDesc.clear();
    _textFieldControllerLoca.clear();
    readyToUploadImages.clear();
    listOfImageLinks.clear();
    setState(() {
      _desc = '';
      _location = '';
      _name = '';
//      readyToUploadImages.length = -1;
//      listOfImageLinks.length = -1;
    });
  }

  _SendToServer() async {
    print("_SendToServer Called");

    /// Check Inputs
    _validateInputs();

    /// Create post
    await _CreatePost();

    /// RestData
    _Resetdata();
    print('please enter value');
//    if (_validateInputs() == false) {
//      _displaySnackBar(context);
//    }
  }

  void _displaySnackBar(BuildContext context) {
    print("_displaySnackBar Called");

    if (!_validateInputs() || imageUrl2 == null) {
      final snackBar = SnackBar(content: Text('أكمل الحقول'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(content: Text('جاري رفع الإعلان'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }


  Widget showDialog() {
//    if (!_validateInputs() || imageUrl2 == null) {
    return CustomDialog(
      title: 'إضافة الإعلان',
      buttonText: 'Yes',
      description: 'ss',
      image: Image.asset(
        'assets/images/myIcon.png',
      ),
    );

//    } else {
//      return Container(
//        child: Text("sasdasd"),
//      );
//    }
  }
}

//  final snackBar = SnackBar(content: Text('أكمل الحقول'));
//  _scaffoldKey.currentState.showSnackBar(snackBar);
//
//  final snackBar = SnackBar(content: Text('جاري رفع الإعلان'));
//  _scaffoldKey.currentState.showSnackBar(snackBar);

/// =======================================================================================

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
