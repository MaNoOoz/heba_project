import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/service/StorageService.dart';
import 'package:heba_project/ui/Screens/HomeScreen.dart';
import 'package:heba_project/ui/shared/Assets.dart';
import 'package:heba_project/ui/shared/Dialogs.dart';
import 'package:heba_project/ui/shared/utili/Constants.dart';
import 'package:heba_project/ui/shared/utili/UI_Helpers.dart';
import 'package:heba_project/ui/shared/widgets/CustomWidgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import 'file:///H:/Android%20Projects/Projects/Flutter%20Projects/Mine/heba_project/lib/ui/shared/utili/UtilsImporter.dart';
import 'file:///H:/Android%20Projects/Projects/Flutter%20Projects/Mine/heba_project/lib/ui/shared/widgets/CustomAppBar.dart';

class Edit_Heba_Screen extends StatefulWidget {
  static final String id = 'Edit_Heba_Screen';
  final String currentUserId;
  Key key;
  final HebaModel post;

  Edit_Heba_Screen({Key key, this.currentUserId, this.post}) : super(key: key);

  @override
  _Edit_Heba_ScreenState createState() => _Edit_Heba_ScreenState();
}

class _Edit_Heba_ScreenState extends State<Edit_Heba_Screen>
    with SingleTickerProviderStateMixin {
  /// https://mrflutter.com/how-to-use-progress-indicators-in-flutter/
  bool tappedYes = false;

  /// Multi Image Picker ====================================
  List<Asset> _readyToUploadImages = List<Asset>();
  var uploadingState;
  var mSelectedImage;

  /// Post ===================================================
  String userId;
  String fuser;
  String fuserImage;
  String currentUserId;
  bool isMine;
  Position currentPosition;
  Geoflutterfire geo = Geoflutterfire();
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<String> _dropDownMenuItemsStrings = [];
  String _currentCity;

  /// Form ====================================================
  GlobalKey<FormState> _formkey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

//  TextEditingController _textFieldControllerName;
//  TextEditingController _textFieldControllerDesc;
  bool _autoValidate = false;
  String _name;
  String passed_name;
  String _desc;
  String passed_desc;
  var passed_images;

  String _city;

  bool showSpinner = false;

  /// Map ====================================================
  String mCl;
  Color color;
  Future<BottomSheet> mBottomSheetForFiltiring;

  var tapped;

  ///  ====================================================
  var ImagesPathsToUpload = [];
  List<File> _files;
  String _extension;

  ///  Log ====================================================
  var logger;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });

//    _textFieldControllerName = TextEditingController();
//    _textFieldControllerDesc = TextEditingController();
//    this._name = _textFieldControllerName.text;
//    this._desc = _textFieldControllerDesc.text;
    var hName = widget.post.hName;
    var id = widget.post.id;
    log("hName : $hName");
    log("documentID : $id");
    this.passed_name = widget.post.hName;
    this.passed_desc = widget.post.hDesc;
    this.passed_images = widget.post.imageUrls;
    super.initState();
  }

  init() async {
    /// init Data
    if (this.mounted == true) {
      print("this.mounted");

      _dropDownMenuItemsStrings = cities;
      _currentCity = widget.post.hCity;
      print("_dropDownMenuItemsStrings : $_currentCity");

      await Geolocator().getCurrentPosition().then((currloc) {
        setState(() {
          currentPosition = currloc;
          print(" currentPosition :  ${currentPosition.longitude}");
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    fuser = Provider.of<FirebaseUser>(context).displayName;
    fuserImage = Provider.of<FirebaseUser>(context).photoUrl;

    return Scaffold(
      appBar: CustomAppBar(
        title: "تعديل الإعلان",
//                title: "HEBA",
        IsBack: true,
        color: Colors.blue,
        isImageVisble: true,
//              flexSpace: 50,
//              flexColor: Colors.blue,
      ),
      key: _scaffoldKey,
      body: ModalProgressHUD(
        color: Colors.white,
        progressIndicator:
            mStatlessWidgets().mLoading(title: "جاري رفع الإعلان"),
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            children: <Widget>[
              /// Form
              FormUi(context, widget.post),
              UIHelper.verticalSpaceWithColor(1, Colors.teal),

              /// Titles
              Container(
                margin: EdgeInsets.all(15.0),
//            color: Colors.teal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      " صور الهبة :   ( ${widget.post.imageUrls.length} ) ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              ///  Images From DB
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
//                  decoration: BoxDecoration(
//
//                      color: Colors.white12.withOpacity(0.5),
//                      borderRadius:
//                      BorderRadius.all(Radius.circular(5)),
//                     ),

                  height: 100,
                  child: Row(
//                mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          flex: 5, child: buildGridViewForUploadedImages()),
                    ],
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.all(15.0),
//            color: Colors.teal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "رفع صور جديدة ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              /// Upload new Images
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
//                  decoration: BoxDecoration(
//
//                      color: Colors.white12.withOpacity(0.5),
//                      borderRadius:
//                      BorderRadius.all(Radius.circular(5)),
//                     ),

                  height: 200,
                  child: Row(
//                mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(flex: 5, child: buildGridViewForNewImages()),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          /// ADD Btn
                          GestureDetector(
                            onTap: () async {
                              await pickImages();
//                      _clearCachedFiles();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 20)
                                    ]),
                                height: 50,
                                width: 50,
                                child: Icon(
                                  files.length == 0
                                      ? Icons.add_circle
                                      : Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          /// Upload Btn
                          GestureDetector(
                            onTap: () async {
                              await _listOfImageLinks2();
//                      _clearCachedFiles();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 20)
                                    ]),
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: Icon(
                                    Icons.cloud_upload,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              UIHelper.verticalSpace(10),

              /// Buttons
              _Buttons(),
            ],
          ),
        ),
      ),
    );

//
  }

  Future<void> pickImages() async {
    _clearCachedFiles();
    ImagesPathsToUpload.clear();

    try {
      _files = await FilePicker.getMultiFile(
          type: FileType.custom, allowedExtensions: ['jpg']);
      if (_files != null) {
        for (File file in _files) {
          String path = file.path;
          ImagesPathsToUpload.add(path);
          logger.d("path : ${path}");
        }
        logger.d(
            "pathes: ${ImagesPathsToUpload}  --  list size is : ${ImagesPathsToUpload.length}");

        setState(() {
          files = _files;
        });
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
  }

  void _clearCachedFiles() {
    FilePicker.clearTemporaryFiles().then((result) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: result ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    });
  }

  Widget FormUi(BuildContext context, HebaModel heba) {
    return Container(
      child: Form(
        key: _formkey,
        autovalidate: _autoValidate,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /// Name OF Heba
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: passed_name,
                enabled: tapped,
                onTap: () {
                  return onEtTap;
                },
                maxLength: 32,
                keyboardType: TextInputType.text,
//                controller: _textFieldControllerName,
                maxLines: 1,
                style: UtilsImporter().uStyleUtils.loginTextFieldStyle(),
                decoration:
                    UtilsImporter().uStyleUtils.textFieldDecorationCircle(
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
                initialValue: passed_desc,
                enabled: tapped,
                onTap: () {
                  return onEtTap;
                },
                maxLength: 400,
                keyboardType: TextInputType.text,
//                controller: _textFieldControllerDesc,
                maxLines: 10,
                style: UtilsImporter().uStyleUtils.loginTextFieldStyle(),
                decoration:
                    UtilsImporter().uStyleUtils.textFieldDecorationCircle(
                          hint: UtilsImporter().uStringUtils.hintName,
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

            /// Location
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: [
//                Expanded(
//                  flex: 2,
//                  child: Container(
//                    width: MediaQuery.of(context).size.width / 6,
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      textDirection: TextDirection.rtl,
//                      children: <Widget>[
//                        currentPosition == null
//                            ? Center(
//                                child: CircularProgressIndicator(),
//                              )
//                            : Flexible(
//                                flex: 2,
//                                child: Text(
//                                  heba.geoPoint.latitude == null
//                                      ? ""
//                                      : "${heba.geoPoint.latitude}",
//                                  style: TextStyle(
//                                    fontSize: 12,
//                                    color: Colors.blueAccent,
//                                    fontWeight: FontWeight.bold,
//                                  ),
//                                ),
//                              ),
//                        Align(
//                          alignment: AlignmentDirectional.centerEnd,
//                          child: Expanded(
//                            flex: 1,
//                            child: Text(
//                              "تحديد الموقع الحالي",
//                              style: TextStyle(
//                                  fontSize: 12,
//                                  color: Colors.black45,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                          ),
//                        ),
//                        const Icon(
//                          Icons.location_on,
//                          color: Colors.blueAccent,
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ],
//            ),

            SizedBox(
              height: 10,
            ),

//            https://codingwithjoe.com/building-forms-with-flutter/
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: new FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: const Icon(Icons.location_city),
                          labelText: 'المدينة',
                        ),
                        isEmpty: _currentCity == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            value: _currentCity,
                            isDense: true,
                            onChanged: (String newValue) {
                              changedDropDownItem(newValue);
                            },
                            items:
                                _dropDownMenuItemsStrings.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  /// Methods ==========================================================================================
  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCity = selectedCity;
      print("changedDropDownItem _currentCity is :$_currentCity");
    });
  }

  showAddHebaDialog(BuildContext context) {
    return CustomDialog2(
      title: 'تحديث الإعلان',
      buttonText: 'Yes',
      description: 'ss',
      image: Image.asset(
        'assets/images/myIcon.png',
      ),
    );
  }

  showLoadingDialog(BuildContext context) {
    return AlertDialog(
      title: Text('جاري تحديث الإعلان'),
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

  /// Form
  Future<bool> _validateInputs() async {
    if (_formkey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formkey.currentState.save();
//      print("From _validateInputs :  name $_name desc $_desc  Userlocation : ${fetchedLocation.address}");
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

  Future<dynamic> _listOfImageLinks2() async {
    var listOfImageLinks = [];
    for (var imageFile in files) {
      var task = await StorageService.uploadUserProfileImageInSignUp(
          imageFile, widget.currentUserId);
      mSelectedImage = await StorageService.downloadUrl(task);
      print('From _listOfImageLinks2() : image path is : ${imageFile.path}');
      print(
          "From _listOfImageLinks2() : mUploadedImagePath : ${mSelectedImage.toString()}");
      listOfImageLinks.add(mSelectedImage);
    }

//    listOfImageLinks.add(mSelectedImage);
    return listOfImageLinks;
  }

  Future<HebaModel> _UpdatePost() async {
    print("_CreatePost Called");
    HebaModel heba = widget.post;
    log('Id before Updated ${heba.id}');
    log('hDesc before Updated ${heba.hDesc}');

    ImagesPathsToUpload = await _listOfImageLinks2();
    var passed_images = widget.post.imageUrls;
    print("pathes: ${ImagesPathsToUpload.length} ");

    /// public posts
    var currentUserId2 =
        Provider.of<UserData>(context, listen: false).currentUserId;
    isMine = widget.currentUserId == currentUserId2;
    var ts = Timestamp.fromDate(DateTime.now());
    var lat = currentPosition.latitude;
    var long = currentPosition.longitude;
    var gePoint = GeoPoint(lat, long);

    var heba2 = HebaModel(
        id: heba.id,
        oName: fuser,
        oImage: fuserImage,
        isFeatured: false,
        isMine: isMine,
        imageUrls: passed_images,
        hName: _name,
        geoPoint: gePoint,
        hDesc: _desc,
        hCity: _currentCity,
        authorId: widget.currentUserId,
        timestamp: ts);
//    var map = heba.toMapAsJson();

    return heba2;
  }

  var finalCheck;

  /// Reset data
  Future<bool> _Resetdata() async {
    var dateRested = true;
    print("_Resetdata Called");
    _readyToUploadImages.clear();
    ImagesPathsToUpload.clear();

    setState(() {
      _desc = '';
      _name = '';
      _city = '';

//      listOfImageLinks.length = -1;
    });
    return dateRested;
  }

  /// Send data
  Future<bool> _SendToServer() async {
    showSpinner = true;

    var dataUploaded = false;

    /// Check Inputs
    var dataChecked = await _validateInputs();
    print('dataChecked $dataChecked');

    /// Update New Post
    var postCreated = await _UpdatePost();
    var s = postCreated.id;
    var ss = postCreated.hDesc;
    log('Id after Updated $s');
    log('hDesc after Updated $ss');
//    var docRef = await DatabaseService.updatePublicPosts2(updatedPost: postCreated);
//    log('docRef  ${docRef}');

//    /// Check Location
//    var userLocationUpdated = await _GetUserLocation();

//    setState(() {
//      dataChecked = true;
//    });
    /// add to database
//    String docRef;
//    docRef = await DatabaseService.updatePublicPosts2(updatedPost: widget.post)
//        .then((value) {
////      docRef = value.documentID;
//      log("docRef for added doc is  :${docRef}");
//      log("hName for added doc is  :${postCreated.hName}");
//    }).catchError((onError) {
//      log("$onError");
//    }).whenComplete(() {
//      log('Future Complete {whenComplete}');
//    });

    /// Rest Fields
    var fieldsRested = await _Resetdata();
    print('fieldsRested $fieldsRested');

    finalCheck =
            dataChecked == false || postCreated != null || fieldsRested == true
//            || updated == true
        ;

    if (finalCheck == true) {
//      todo
//      _displaySnackBar(context, " تم إضافة الهبة بنجاح");

      print("fieldsRested $fieldsRested     " +
          "userLocationCreated From _CreatePost  " +
          "dataChecked  $dataChecked     " +
          "fieldsRested $fieldsRested   ");
    }
  }

  /// Confirm data
  void _displaySnackBar(BuildContext context, var title) {
    print("_displaySnackBar Called");

//    if (mImagesPath = null || _name.isEmpty) {
    if (finalCheck == true) {
      final snackBar = SnackBar(
        content: Text(title),
        duration: Duration(seconds: 3),
      );
      var s = _scaffoldKey.currentState.showSnackBar(snackBar);
      s.closed.whenComplete(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });

//      Navigator.pushNamed(context, HomeScreen.id);

    } else {
      final snackBar = SnackBar(
        content: Text(title),
        duration: Duration(seconds: 3),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

//    } else if (mImagesPath.length < mSelectedImage) {
//      final snackBar = SnackBar(
//        content: Text('جاري رفع الإعلان'),
//      );
//      _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void SendChangedHeba() async {
    print("Submit called ");
    if (passed_name.isNotEmpty) {
      final action = await CustomDialog1.addNewHebaDialog(
          context, ' هبة جديدة', 'متأكد خلاص  ولا ؟؟ ');

      if (action == DialogAction.yes) {
        print("Before _SendToServer ");
        FocusScope.of(context).unfocus();

        await _SendToServer().whenComplete(() {
          _displaySnackBar(context, " تم إضافة الهبة بنجاح");

          setState(() {
            showSpinner = false;
          });
        }).catchError((e) {
          log(e.toString());
        });

        print("after _SendToServer ");

        if (this.mounted) {
          setState(() {
            tappedYes = true;
            print("tappedYes $tappedYes ");
          });
        }
      } else {
        setState(
          () {
            tappedYes = false;
            showSpinner = false;
          },
        );
      }
    } else {
      _displaySnackBar(context, "أفااا تأكد عندك نقص بالمعلومات طال عمرك");
    }
  }

  Future Delete() async {
    print("Delete called ");

    /// todo :
    ///   for delete a heba i need to
    ///   #find Heba photos Related in firestorege $imageUrls
    ///   # delete Image First $future
    ///   #wait for the result then Delete post Object
    ///   #update ui

    final action = await CustomDialog1.addNewHebaDialog(
        context, '  حذف الهبة', 'متأكد خلاص  ولا ؟؟ ');

    if (action == DialogAction.yes) {
      print("Before delete ");

      await publicpostsRef.document(widget.post.id).delete().then((value) {
        _displaySnackBar(context, " تم حذف الهبة بنجاح");
        setState(() {
//          todo
        });
      }).catchError((onError) {
        print("$onError ");
      }).whenComplete(() {
        _displaySnackBar(context, "Done");
        Navigator.of(context).pop();
      });

      print("after delete ");

      if (this.mounted) {
        setState(() {
          tappedYes = true;
          print("tappedYes $tappedYes ");
        });
      } else {
        setState(
          () {
            tappedYes = false;
            showSpinner = false;
          },
        );
      }
    } else {
      _displaySnackBar(context, "أفااا تأكد عندك نقص بالمعلومات طال عمرك");
    }
  }

  void Update() async {
    print("Delete called ");

    /// todo :
    ///   for delete a heba i need to
    ///   #find Heba photos Related in firestorege $imageUrls
    ///   # delete Image First $future
    ///   #wait for the result then Delete post Object
    ///   #update ui

    final action = await CustomDialog1.addNewHebaDialog(
        context, ' Delete Heba', 'Are You Sure You Want To Delete This Post');
    if (action == DialogAction.yes) {
      print("Before delete ");

      await publicpostsRef.document(widget.post.id).delete().then((value) {
        _displaySnackBar(context, " تم حذف الهبة بنجاح");
      }).catchError((onError) {
        print("$onError ");
      }).whenComplete(() {
        _displaySnackBar(context, "Done");
        Navigator.of(context).pop();
      });

      print("after delete ");

      if (this.mounted) {
        setState(() {
          tappedYes = true;
          print("tappedYes $tappedYes ");
        });
      } else {
        setState(
          () {
            tappedYes = false;
            showSpinner = false;
          },
        );
      }
    } else {
      _displaySnackBar(context, "postCreated is null");
    }
  }

  bool onEtTap(tapped) {
    if (tapped == true) {
      tapped = false;
    } else {
      tapped = true;
    }
  }

  /// Widgets ==========================================================================================
  ///  ImagesLook

  List<File> files = [];

  Widget buildGridViewForUploadedImages() {
    final orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: (orientation == Orientation.portrait) ? 3 : 5),
      itemCount: passed_images.length ?? 6,
      padding: const EdgeInsets.all(3.0),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return passed_images.length == 0
            ? Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    color: Colors.grey.withOpacity(0.4),
                    image: AssetImage(AvailableImages.appIcon),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
              )
            : rowItemForUploadedImages(passed_images[index], index);
      },
    );
  }

  Widget buildGridViewForNewImages() {
    final orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: (orientation == Orientation.portrait) ? 3 : 5),
      itemCount: files.length ?? 6,
      padding: const EdgeInsets.all(3.0),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return files.length == 0
            ? Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    color: Colors.grey.withOpacity(0.4),
                    image: AssetImage(AvailableImages.appIcon),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
              )
            : rowItemForNewImages(files[index], index);
      },
    );
  }

  Widget rowItemForUploadedImages(String image, int index) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) => PhotoViewQ(
//                  fileImage: image,
//                ),
//              ),
//            );
          },
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Image.network(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: GestureDetector(
            onTap: () async {
//              todo
              /// check Hebat Images
              await StorageService.ReadyToDeleteTask(
                  model: widget.post, index: index);

//            todo
              log('$index');
              print("remove ");
              passed_images.removeAt(index);
              setState(() {
//                https://stackoverflow.com/questions/51931017/update-ui-after-removing-items-from-list
                passed_images = List.from(passed_images);
              });
            },
            child: Container(
              color: Colors.black38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.delete,
                      textDirection: TextDirection.rtl,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Text(
                        "${index + 1} / ${passed_images.length}",
                        style: TextStyle(fontSize: 8, color: Colors.white),
                      ),
                    ),
                  ),

//                GestureDetector(
//                  onTap: () async {},
//                  child: Container(
//                    child: Padding(
//                      padding: EdgeInsets.only(right: 4.0),
//                      child: Icon(
//                        FontAwesomeIcons.edit,
//                        size: 10,
//                        color: Colors.white,
//                      ),
//                    ),
//                  ),
//                ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget rowItemForNewImages(File image, int index) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) => PhotoViewQ(
//                  fileImage: image,
//                ),
//              ),
//            );
          },
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Image.file(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: GestureDetector(
            onTap: () async {
//              todo
              /// check Hebat Images
              await StorageService.ReadyToDeleteTask(
                  model: widget.post, index: index);

//            todo
              log('$index');
              print("remove ");
              files.removeAt(index);
              setState(() {
//                https://stackoverflow.com/questions/51931017/update-ui-after-removing-items-from-list
                files = List.from(files);
              });
            },
            child: Container(
              color: Colors.black38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.delete,
                      textDirection: TextDirection.rtl,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),

                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Text(
                        "${index + 1} / ${files.length}",
                        style: TextStyle(fontSize: 8, color: Colors.white),
                      ),
                    ),
                  ),

//                GestureDetector(
//                  onTap: () async {},
//                  child: Container(
//                    child: Padding(
//                      padding: EdgeInsets.only(right: 4.0),
//                      child: Icon(
//                        FontAwesomeIcons.edit,
//                        size: 10,
//                        color: Colors.white,
//                      ),
//                    ),
//                  ),
//                ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in cities) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  ///  Buttons
  _Buttons() {
//    print('Location From _Buttons : Lat  ${userLocation?.latitude}, Long: ${userLocation?.longitude}');

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[
          ///  Update Btn
          FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              splashColor: Colors.blueAccent,
              color: Colors.blue,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Center(
                        child: Text(
                          " تعديل الإعلان",
                          style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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
              onPressed: () {
                SendChangedHeba();

                // or
//                var s = submit().whenComplete(() {
//                  print("submit whenComplete ");
//
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => HomeScreen()));
//                });
              }),

          ///  Delete Btn

          FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              splashColor: Colors.red,
              color: Colors.red,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Center(
                        child: Text(
                          "حذف ",
                          style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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
                await Delete();
                // or
//                var s = submit().whenComplete(() {
//                  print("submit whenComplete ");
//
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => HomeScreen()));
//                });
              }),

          UIHelper.verticalSpace(10),
          UIHelper.verticalSpace(10),
        ],
      ),
    );
  }
}
