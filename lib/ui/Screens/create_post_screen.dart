/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:heba_project/models/post_model.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/service/storage_service.dart';
import 'package:heba_project/ui/shared/CommanUtils.dart';
import 'package:heba_project/ui/shared/UtilsImporter.dart';
import 'package:heba_project/ui/shared/ui_helpers.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  /// Multi Image Picker ====================================================
  List<Asset> readyToUploadImages = List<Asset>();

  // todo Strings >???
  List<String> downloadUploadedImages = List<String>();
  String _error = 'No Error Dectected';

  /// Form ====================================================
  GlobalKey<FormState> _formkey = GlobalKey();
  GlobalKey<FormState> _formkey2 = GlobalKey();
  TextEditingController _textFieldControllerName;
  TextEditingController _textFieldControllerDesc;
  TextEditingController _textFieldControllerLoca;
  var color;

//  String _currentName;
  bool _autoValidate = false;
  String _name;
  String _desc;
  String _location;

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
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Add New Heba',
          style: TextStyle(
            fontFamily: ArabicFonts.Cairo,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15.0),
            child: Form(
              key: _formkey,
              autovalidate: _autoValidate,
              child: FormUI(),
            ),
          ),
          buildGridView(),
//          buildGridView2(),

          /// Add Images
          RaisedButton(
            child: Text(
              "إضافة صور",
              style: TextStyle(fontFamily: ArabicFonts.Cairo),
            ),
            onPressed: loadAssets,
          ),
          Center(child: Text('Error: $_error')),
          RaisedButton(
            child: Text("ADD NOW"),
            onPressed: () {
              _validateInputs;
              print("Added  ${_name} ${_desc} ${_location}");
            },
          ),

          RaisedButton(
            child: Text("Submit"),
            onPressed: _submit,
          ),

          UIHelper.verticalSpace(10),
        ],
      ),
    );

//
  }

  /// Methods ==========================================================================================
  /// Form
  void _validateInputs() {
    if (_formkey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formkey.currentState.save();
      print(" name $_name desc $_desc location $_location  ");
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  /// Multi Image Picker
  /// Selected Images
  Future<void> loadAssets() async {
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
    print(resultList);
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      readyToUploadImages = resultList;
      _error = error;
    });

    /// logging
  }

  var singleUpload;

  _UploadImageList() async {
    print('_UploadImageList Called');

    for (var imageFile in readyToUploadImages) {
      print('image  :  ${imageFile.identifier}');
      singleUpload = await postImage(imageFile).catchError((err) {
        print(err);
      }).timeout(Duration(seconds: 15), onTimeout: () {
        print('Uploading Time Takes So Much Time !!!');
      });
    }
    print(singleUpload.toString());
    print(
        'Upload Finished and the total images are : ${readyToUploadImages.length} image');
  }

  /// Upload Images to Database
  Future<String> postImage(Asset imageFile) async {
//    await imageFile.requestOriginal();
    ByteData byteData = await imageFile.requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData(imageData);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    return storageTaskSnapshot.ref.getDownloadURL();
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
            style: UtilsImporter().styleUtils.loginTextFieldStyle(),
            decoration: UtilsImporter().styleUtils.textFieldDecorationCircle(
                  hint: UtilsImporter().stringUtils.hintName,
                  lable: UtilsImporter().stringUtils.lableFullname1,
                  icon: Icon(Icons.card_giftcard),
                ),
            textDirection: TextDirection.rtl,
            validator: UtilsImporter().commanUtils.validateName,
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
            style: UtilsImporter().styleUtils.loginTextFieldStyle(),
            decoration: UtilsImporter().styleUtils.textFieldDecorationCircle(
                  hint: UtilsImporter().stringUtils.hintDesc,
                  lable: UtilsImporter().stringUtils.lableFullname2,
                  icon: Icon(Icons.description),
                ),
            textDirection: TextDirection.rtl,
            validator: UtilsImporter().commanUtils.validateName,
            onSaved: (String val) {
              _desc = val;
            },
            onChanged: (val) => setState(() => _desc = val),
          ),
        ),

        /// Location todo
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            maxLength: 32,
            controller: _textFieldControllerLoca,
            maxLines: 1,
            style: UtilsImporter().styleUtils.loginTextFieldStyle(),
            decoration: UtilsImporter().styleUtils.textFieldDecorationCircle(
                  hint: UtilsImporter().stringUtils.hintLocation,
                  lable: UtilsImporter().stringUtils.lableFullname3,
                  icon: Icon(Icons.not_listed_location),
                ),
            textDirection: TextDirection.rtl,
            validator: CommanUtils().validateName,
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
      crossAxisCount: 5,
      shrinkWrap: true,
      physics: ScrollPhysics(), // to disable GridView's scrolling
      children: List.generate(readyToUploadImages.length, (index) {
        Asset asset = readyToUploadImages[index];
        return Card(
          color: Colors.white,
          child: Center(
            child: AssetThumb(
              asset: asset,
              width: 100,
              height: 100,
            ),
          ),
        );
      }),
    );
  }

//  todo 1 - get uploaded Images From Firebase Storage "for Testing"
//  Widget buildGridView2() {
//    return GridView.count(
//      crossAxisCount: 5,
//      shrinkWrap: true,
//      physics: ScrollPhysics(), // to disable GridView's scrolling
//      children: List.generate(downloadUploadedImages.length, (index) {
//        String[] imagesPaths = downloadUploadedImages[index];
//        return Card(
//          color: Colors.white,
//          child: Center(
//            child: AssetThumb(
//              asset: asset,
//              width: 100,
//              height: 100,
//            ),
//          ),
//        );
//      }),
//    );
//  }

  File _image;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;

  _showSelectImageDialog() {
//    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
    _androidDialog();
  }

  /// For IOS
//  _iosBottomSheet() {
//    showCupertinoModalPopup(
//      context: context,
//      builder: (BuildContext context) {
//        return CupertinoActionSheet(
//          title: Text('Add Photo'),
//          actions: <Widget>[
//            CupertinoActionSheetAction(
//              child: Text('Take Photo'),
//              onPressed: () => _handleImage(ImageSource.camera),
//            ),
//            CupertinoActionSheetAction(
//              child: Text('Choose From Gallery'),
//              onPressed: () => _handleImage(ImageSource.gallery),
//            ),
//          ],
//          cancelButton: CupertinoActionSheetAction(
//            child: Text('Cancel'),
//            onPressed: () => Navigator.pop(context),
//          ),
//        );
//      },
//    );
//  }
  /// For Android

  _androidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Add Photo'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Take Photo'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text('Choose From Gallery'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      imageFile = await _cropImage(imageFile);
      setState(() {
        _image = imageFile;
      });
    }
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return croppedImage;
  }

  _submit() async {
    if (_autoValidate) {
      print("Called");
      setState(() {
        _isLoading = true;
        print("$_isLoading");
      });

      // Create post
      String imageUrl = await StorageService.uploadPost(_image);
//      String imageUrl2 = postImage(singleUpload).toString();
      Post post = Post(
        imageUrl: imageUrl,
        caption: _caption,
        likeCount: 0,
        authorId: Provider.of<UserData>(context).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      DatabaseService.createPost(post);

      // Reset data
      _textFieldControllerName.clear();
      _textFieldControllerDesc.clear();
      _textFieldControllerLoca.clear();

      setState(() {
        _desc = '';
        _location = '';
        _name = '';
        _image = null;
        _isLoading = false;
      });
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Processing Data')));
    }
  }

  /// =======================================================================================
  ///
//  @override
//  Widget build(BuildContext context) {
//    final height = MediaQuery.of(context).size.height;
//    final width = MediaQuery.of(context).size.width;
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.white,
//        title: Text(
//          'Add New Heba',
//          style: TextStyle(
//            color: Colors.black,
//            fontFamily: ArabicFonts.Cairo,
//          ),
//        ),
//        actions: <Widget>[
//          if (_image == null)
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Icon(
//                Icons.sync_problem,
//                color: Colors.black45,
//                size: 32.0,
//              ),
//            )
//          else
//            IconButton(
//              iconSize: 42.0,
//              icon: Icon(
//                Icons.check,
//                color: Colors.green,
//              ),
//              onPressed: _submit,
//            ),
//          UIHelper.verticalSpace(height),
//          Center(child: Text('Error: $_error')),
//          RaisedButton(
//            child: Text("Pick images"),
//            onPressed: loadAssets,
//          ),
//          Expanded(
//            child: buildGridView(),
//          ),
//        ],
//      ),
//      body: GestureDetector(
//        onTap: () => FocusScope.of(context).unfocus(),
//        child: SingleChildScrollView(
//          child: Container(
//            height: height,
//            child: Column(
//              children: <Widget>[
//                _isLoading
//                    ? Padding(
//                        padding: EdgeInsets.only(bottom: 10.0),
//                        child: LinearProgressIndicator(
//                          backgroundColor: Colors.blue[200],
//                          valueColor: AlwaysStoppedAnimation(Colors.blue),
//                        ),
//                      )
//                    : SizedBox.shrink(),
//                Column(
//                  children: <Widget>[
//                    GestureDetector(
//                      onTap: _showSelectImageDialog,
//                      child: Container(
//                        height: width,
//                        width: width,
//                        color: Colors.grey[300],
//                        child: _image == null
//                            ? Icon(
//                                Icons.add_a_photo,
//                                color: Colors.white70,
//                                size: 150.0,
//                              )
//                            : Image(
//                                image: FileImage(_image),
//                                fit: BoxFit.cover,
//                              ),
//                      ),
//                    ),
//                    if (_image != null)
//                      IconButton(
//                        onPressed: () {},
//                        icon: Icon(
//                          Icons.delete,
//                          color: Colors.red,
//                        ),
//                      )
//                    else
//                      SizedBox(),
//                  ],
//                ),
//                SizedBox(height: 20.0),
//                Padding(
//                  padding: EdgeInsets.symmetric(horizontal: 30.0),
//                  child: TextField(
//                    controller: _captionController,
//                    style: TextStyle(fontSize: 18.0),
//                    decoration: InputDecoration(
//                      labelText: 'الوصف',
//                    ),
//                    onChanged: (input) => _caption = input,
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }

}
