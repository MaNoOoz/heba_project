import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/service/DatabaseService.dart';
import 'package:heba_project/service/StorageService.dart';
import 'package:heba_project/ui/Screens/HomeScreen.dart';
import 'package:heba_project/ui/Screens/photoview.dart';
import 'package:heba_project/ui/shared/Assets.dart';
import 'package:heba_project/ui/shared/Dialogs.dart';
import 'package:heba_project/ui/shared/utili/Constants.dart';
import 'package:heba_project/ui/shared/utili/UI_Helpers.dart';
import 'package:heba_project/ui/shared/widgets/Clippers.dart';
import 'package:heba_project/ui/shared/widgets/CustomWidgets.dart';
import 'package:logger/logger.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import 'file:///H:/Android%20Projects/Projects/Flutter%20Projects/Mine/heba_project/lib/ui/shared/utili/UtilsImporter.dart';

enum TypeOperation {
  upload,
  download,
  delete,
}

class CreatePostScreen extends StatefulWidget {
  static final String id = 'CreatePostScreen';
  final String currentUserId;
  Key key;

//  HebaModel post;

  CreatePostScreen({Key key, this.currentUserId}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with SingleTickerProviderStateMixin {
  /// https://mrflutter.com/how-to-use-progress-indicators-in-flutter/

  /// Multi Image Picker ====================================
  List<Asset> _readyToUploadImages = List<Asset>();
  List<Asset> _placeHolders = List<Asset>();
  var uploadingState;
  var mSelectedImage;

  /// New Multi Image Picker ====================================

//  List<String> imagefilePaths = [];
//  List<String> imagefileNames = [];

  var pathes = [];
  List<File> _files;
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  StorageUploadTask task;

  /// Post ===================================================
  String userId;
  String fuser;
  String fuserImage;
  String currentUserId;
  bool isMine;
  Position currentPosition;
  Geoflutterfire geo = Geoflutterfire();
  List<DropdownMenuItem<dynamic>> _dropDownMenuItems;
  List<String> _dropDownMenuItemsStrings = [];
  List<String> _dropDownMenuItemsStrings2 = [];

  /// Dialoag ====================================================

  bool tappedYes;

  /// Form ====================================================
  GlobalKey<FormState> _formkey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textFieldControllerName;
  TextEditingController _textFieldControllerDesc;
  TextEditingController _textFieldControllerContact;
  bool _autoValidate = false;
  String _name;
  String _desc;
  String _currentCity;
  String _currentContactMethod;
  bool showSpinner = false;
  TypeOperation typeOperation = TypeOperation.download;
  bool isLoading = true;
  bool isSuccess = true;

  /// Map ====================================================
  String mCl;
  Color color;
  Future<BottomSheet> mBottomSheetForFiltiring;

  ///  Log ====================================================
  var logger;

  ///
  ///  ====================================================

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });

    /// ===

    typeOperation = null;

    /// ===
    _textFieldControllerName = TextEditingController();
    _textFieldControllerDesc = TextEditingController();
    _textFieldControllerContact = TextEditingController();
    this._name = _textFieldControllerName.text;
    this._desc = _textFieldControllerDesc.text;
    this._currentContactMethod = _textFieldControllerContact.text;

    super.initState();
  }

  init() async {
    _dropDownMenuItemsStrings = cities;
    _dropDownMenuItemsStrings2 = ContactMrthods;

    _currentCity = _dropDownMenuItemsStrings.elementAt(0);
    _currentContactMethod = _dropDownMenuItemsStrings2.elementAt(0);
    log("_dropDownMenuItemsStrings : $_currentCity");
    log("_dropDownMenuItemsStrings2 : $_currentContactMethod");
    logger = Logger();

    /// init Data
    if (this.mounted == true) {
      log("this.mounted");
    }
  }

  Widget _buildWidgetLoading() {
    if (isLoading && typeOperation == TypeOperation.upload ||
        typeOperation == TypeOperation.delete) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[900].withOpacity(0.8),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    fuser = Provider.of<FirebaseUser>(context).displayName;
    fuserImage = Provider.of<FirebaseUser>(context).photoUrl;
    bool ok = _currentContactMethod.length == 10 && _name.length > 5;

    return Scaffold(
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
              Stack(
                children: <Widget>[
                  Container(
                    transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                    child: Hero(
                      tag: "s",
                      child: ClipShadowPath(
                        clipper: CircularClipper(),
                        shadow: Shadow(blurRadius: 10.0, color: Colors.teal),
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
              FormUi(context),

              /// Grid
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  height: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      /// Titles

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        margin: EdgeInsets.all(8.0),
//            color: Colors.teal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                "صور الهبة :   ( ${files.length} ) ",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Colors.blueGrey,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Flexible(
                                  flex: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: buildGridView3(),
                                  )),
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
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 20)
                                            ]),
                                        height: 50,
                                        width: 50,
                                        child: Icon(
                                          files.length == 0
                                              ? Icons.add_circle
                                              : Icons.edit,
                                          color: Colors.blueGrey,
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
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 20)
                                            ]),
                                        height: 50,
                                        width: 50,
                                        child: Center(
                                          child: Icon(
                                            Icons.cloud_upload,
                                            color: Colors.blueGrey,
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
                    ],
                  ),
                ),
              ),
              UIHelper.verticalSpace(10),

              /// Buttons
              _Buttons(ok),
              UIHelper.verticalSpace(30),
            ],
          ),
        ),
      ),
    );

//
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in cities) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  Widget FormUi(BuildContext context) {
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
                maxLength: 32,
                keyboardType: TextInputType.text,
                controller: _textFieldControllerName,
                maxLines: 1,
                style: UtilsImporter().uStyleUtils.loginTextFieldStyle(),
                decoration:
                UtilsImporter().uStyleUtils.textFieldDecorationCircle(
                  hint: UtilsImporter().uStringUtils.hintName,
                  lable: UtilsImporter().uStringUtils.lableFullname1,
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: ArabicFonts.Cairo),
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
                maxLength: 400,
                keyboardType: TextInputType.text,
                controller: _textFieldControllerDesc,
                maxLines: 10,
                style: UtilsImporter().uStyleUtils.loginTextFieldStyle(),
                decoration:
                UtilsImporter().uStyleUtils.textFieldDecorationCircle(
                  hint: UtilsImporter().uStringUtils.hintDesc,
                  lable: UtilsImporter().uStringUtils.lableFullname2,
                  icon: Icon(Icons.description),
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: ArabicFonts.Cairo),
                ),
                textDirection: TextDirection.rtl,
                validator: UtilsImporter().uCommanUtils.validateDesc,
                onSaved: (String val) {
                  _desc = val;
                },
                onChanged: (val) => setState(() => _desc = val),
              ),
            ),

            Divider(),
//            https://codingwithjoe.com/building-forms-with-flutter/
            /// City
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: new FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.location_city),
                            labelText: 'المدينة',
                          ),
                          isEmpty: false,
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              value:
                              _currentCity == "" ? "القصيم" : _currentCity,
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
            ),

            /// Contact
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Flexible(
                  //   flex: 3,
                  //   child: new FormField<String>(
                  //     builder: (FormFieldState<String> state) {
                  //       return InputDecorator(
                  //         decoration: InputDecoration(
                  //           icon: Icon(Icons.contact_phone),
                  //           labelText: 'وسيلة التواصل',
                  //         ),
                  //         isEmpty: false,
                  //         child: new DropdownButtonHideUnderline(
                  //           child: new DropdownButton<String>(
                  //             // value: "value",
                  //             isDense: true,
                  //             onChanged: (String newValue) {
                  //               changedDropDownItem2(newValue);
                  //             },
                  //             items: _dropDownMenuItemsStrings2
                  //                 .map((String value) {
                  //               return new DropdownMenuItem<String>(
                  //                 value: value,
                  //                 child: Row(
                  //                   textDirection: TextDirection.rtl,
                  //                   children: [
                  //                     Padding(
                  //                       padding: const EdgeInsets.all(1.0),
                  //                       child: new Icon(
                  //                         FontAwesomeIcons.whatsappSquare,
                  //                         color: Colors.green,
                  //                       ),
                  //                     ),
                  //                     Spacer(),
                  //                     Padding(
                  //                       padding: const EdgeInsets.all(1.0),
                  //                       child: new Text(
                  //                         value,
                  //                         style: TextStyle(color: Colors.blue),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               );
                  //             }).toList(),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  Text("s"),
                ],
              ),
            ),

            /// Contact info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLength: 10,
                keyboardType: getType(_currentContactMethod),
                controller: _textFieldControllerContact,
                maxLines: 1,
                style: UtilsImporter().uStyleUtils.loginTextFieldStyle(),
                decoration:
                UtilsImporter().uStyleUtils.textFieldDecorationCircle(
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: ArabicFonts.Cairo),
                  hint: " 0555555555",
                  lable: " رقم الهاتف",
                  icon: Icon(Icons.contact_phone),
                ),
                textDirection: TextDirection.rtl,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (input) =>
                input
                    .trim()
                    .length < 10
                    ? 'Please enter a valid Number'
                    : null,
                onSaved: (String val) {
                  _currentContactMethod = val;
                },
                onChanged: (val) => setState(() => _currentContactMethod = val),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

//  Widget _uploadStatus(StorageUploadTask task, String startingText, String doneText,
//      String uploadingText){
//    return StreamBuilder<StorageTaskEvent>(
//      stream: task.events,
//      builder: (BuildContext context, AsyncSnapshot<StorageTaskEvent> snapshot) {
//
////        if(snapshot.hasData){
////          final StorageTaskEvent event = snapshot.
////          final StorageTaskSnapshot snapshot = event.snapshot;
////        }
////      },
//
////    );
//

//  }
  /// Methods ==========================================================================================
  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCity = selectedCity;
      log("changedDropDownItem _currentCity is :$_currentCity");
    });
  }

  void changedDropDownItem2(String selectedContactWay) {
    setState(() {
      _currentContactMethod = selectedContactWay;
      log(
          "changedDropDownItem2 __currentContactMethod is :$_currentContactMethod");
    });
  }

  showAddHebaDialog(BuildContext context) {
    return CustomDialog2(
      title: 'إضافة الإعلان',
      buttonText: 'Yes',
      description: 'ss',
      image: Image.asset(
        'assets/images/myIcon.png',
      ),
    );
  }

  showLoadingDialog(BuildContext context) {
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

  /// Form
  Future<bool> _validateInputs() async {
    if (_formkey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formkey.currentState.save();
//      log("From _validateInputs :  name $_name desc $_desc  Userlocation : ${fetchedLocation.address}");
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

  /// New Multi Image Picker ======================================================

//  Future<void> downloadFile(StorageReference ref) async {
//    final String url = await ref.getDownloadURL();
//    final http.Response downloadData = await http.get(url);
//    final Directory systemTempDir = Directory.systemTemp;
//    final File tempFile = File('${systemTempDir.path}/tmp.jpg');
//    if (tempFile.existsSync()) {
//      await tempFile.delete();
//    }
//    await tempFile.create();
//    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
//    final int byteCount = (await task.future).totalByteCount;
//    var bodyBytes = downloadData.bodyBytes;
//    final String name = await ref.getName();
//    final String path = await ref.getPath();
//    log(
//      'Success!\nDownloaded $name \nUrl: $url'
//      '\npath: $path \nBytes Count :: $byteCount',
//    );
//    _scaffoldKey.currentState.showSnackBar(
//      SnackBar(
//        backgroundColor: Colors.white,
//        content: Image.memory(
//          bodyBytes,
//          fit: BoxFit.fill,
//        ),
//      ),
//    );
//  }

  List<File> files = [];

//  todo
//  Future<void> uploadToFirebase() async {
//    AnsiPen pen = new AnsiPen()..red(bold: true);
//    log(pen("Bright white foreground") + " this text is default fg/bg");
//
//    _paths.forEach((fileName, filePath) {
//      imagefilePaths.add(filePath);
//      imagefileNames.add(fileName);
//      log("imagefilePaths ${imagefilePaths[0]}");
//      logger.d("imagefilePaths ${imagefilePaths[0]}");
////      upload(fileName, filePath);
//    });
//  }
//
//  upload(fileName, filePath) {
//    _extension = fileName.toString().split('.').last;
//    StorageReference storageRef =
//        FirebaseStorage.instance.ref().child(fileName);
//    final StorageUploadTask uploadTask = storageRef.putFile(
//      File(filePath),
//      StorageMetadata(
//        contentType: '$_pickType/$_extension',
//      ),
//    );
//    setState(() {
//      _tasks.add(uploadTask);
//    });
//  }

  ///  https://firebasestorage.googleapis.com/v0/b/heba-project-3b3c4.appspot.com/o/images%2Fusers%2FuserProfile_a95c11fc-0f5f-4402-807b-420ed5b130b3.jpg?alt=media&token=018e8eb9-650b-427a-bc49-dde7f647872c

  Future<void> pickImages() async {
    _clearCachedFiles();
    pathes.clear();

    try {
      _files = await FilePicker.getMultiFile(
          type: FileType.custom, allowedExtensions: ['jpg']);
      if (_files != null) {
        for (File file in _files) {
          String path = file.path;
          pathes.add(path);
          logger.d("path : ${path}");
        }
        logger.d("pathes: ${pathes}  --  list size is : ${pathes.length}");

        setState(() {
          files = _files;
        });
      }
    } on PlatformException catch (e) {
      log("Unsupported operation" + e.toString());
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

//  Future<dynamic> _listOfImageLinks() async {
//    var listOfImageLinks = [];
//    for (var imageFile in _readyToUploadImages) {
//      mSelectedImage = await StorageService.editedImages(imageFile);
//      log(
//          'From _listOfImageLinks() : image identifier is : ${imageFile.identifier}');
//      log(
//          "From _listOfImageLinks() : mUploadedImagePath : ${mSelectedImage.toString()}");
//      listOfImageLinks.add(mSelectedImage);
//    }
//
////    listOfImageLinks.add(mSelectedImage);
//    return listOfImageLinks;
//  }

  Future<dynamic> _listOfImageLinks2() async {
    var listOfImageLinks = [];
    for (var imageFile in files) {
      var task = await StorageService.uploadUserProfileImageInSignUp(
          imageFile, widget.currentUserId);
      mSelectedImage = await StorageService.downloadUrl(task);
      log('From _listOfImageLinks2() : image path is : ${imageFile.path}');
      log("From _listOfImageLinks2() : mUploadedImagePath : ${mSelectedImage
          .toString()}");
      listOfImageLinks.add(mSelectedImage);
    }

//    listOfImageLinks.add(mSelectedImage);
    return listOfImageLinks;
  }

  Future<HebaModel> _CreatePost() async {
    log("_CreatePost Called");

    HebaModel hebaObject;

    pathes = await _listOfImageLinks2();
    log("pathes: ${pathes.length} ");
    currentPosition = await Geolocator().getCurrentPosition();
    log(" currentPosition :  ${currentPosition.longitude}");

//    Geolocator().getCurrentPosition().then((currloc) {
//      setState(() {
//        currentPosition = currloc;
//        log(" currentPosition :  ${currentPosition.longitude}");
//      });
//    });

    /// public posts
    var currentUserId2 =
        Provider
            .of<UserData>(context, listen: false)
            .currentUserId;
    isMine = widget.currentUserId == currentUserId2;
    var ts = Timestamp.fromDate(DateTime.now());
    var lat = currentPosition.latitude;
    var long = currentPosition.longitude;
    var gePoint = GeoPoint(lat, long);

    if (_currentCity == "") {
      _currentCity = "غير معروف";
    }

    hebaObject = HebaModel(
//      id: 123.toString(),
        oName: fuser,
        oImage: fuserImage,
        isFeatured: false,
        isMine: isMine,
        imageUrls: pathes,
        hName: _name,
        geoPoint: gePoint,
        hDesc: _desc,
        hCity: _currentCity,
        oContact: _currentContactMethod,
        authorId: widget.currentUserId,
        timestamp: ts);

    return hebaObject;
  }

  var finalCheck = false;

  /// Reset data
  Future<bool> _Resetdata() async {
    log("_Resetdata Called");

    _textFieldControllerName.clear();
    _textFieldControllerDesc.clear();
    _readyToUploadImages.clear();
    pathes.clear();

    setState(() {
      _desc = '';
      _name = '';
      _currentContactMethod = '';

//      listOfImageLinks.length = -1;
    });
  }

  /// Send data
  Future<bool> _SendToServer() async {
    showSpinner = true;

    /// Check Inputs
    var dataChecked = false;
    await _validateInputs().whenComplete(() {
      dataChecked = true;
      log('dataSented $dataChecked');
    });

    /// Create New Post
    var postCreated = await _CreatePost();

    /// add to database
    String docRef;
    docRef = await DatabaseService.createPublicPosts(postCreated).then((value) {
      docRef = value.documentID;
      log("docRef for added doc is  :${docRef}");
    }).catchError((onError) {
      log("$onError");
    }).whenComplete(() {
      log('Future Complete {whenComplete}');
    });

    /// Rest Fields
    var fieldsRested = false;
    await _Resetdata().whenComplete(() {
      fieldsRested = true;
      log('fieldsRested $fieldsRested');
    });
    ;

    finalCheck =
        dataChecked == false || postCreated != null || fieldsRested == true;
//        ||
//        dataSented == false;

    if (finalCheck == true) {
      log("dataChecked  $dataChecked" + "fieldsRested $fieldsRested");
    } else {
      return finalCheck;
    }
  }

  /// Confirm data
  void _displaySnackBar(BuildContext context, var title) {
    log("_displaySnackBar Called");

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

  /// Widgets ==========================================================================================
  ///  ImagesLook
  Widget buildGridView() {
    return GridView.count(
      padding: const EdgeInsets.all(3.0),
      crossAxisCount: 5,
      shrinkWrap: true,
      crossAxisSpacing: 3,
      physics: ScrollPhysics(),
      // to disable GridView's scrolling
      children: List.generate(_readyToUploadImages.length, (index) {
        Asset images = _readyToUploadImages[index];
        Asset image = Asset("${AvailableImages.appIcon}",
            "${AvailableImages.appIcon}", 100, 100);
        return Center(
          child: AssetThumb(
            asset: images,
            width: 100,
            height: 100,
//            spinner: mStatlessWidgets().EmptyView(),
          ),
        );
      }),

//      children: List.generate(_readyToUploadImages.length, (index) {
//        Asset images = _readyToUploadImages[index];
//        return Center(
//          child: AssetThumb(
//            asset: images,
//            width: 100,
//            height: 100,
//            spinner: mStatlessWidgets().EmptyView(),
//          ),
//        );
//      }),
    );
  }

  Widget buildGridView2() {
    return GridView.count(
      padding: const EdgeInsets.all(3.0),
      crossAxisCount: 5,
      shrinkWrap: true,
      crossAxisSpacing: 3,
      physics: ScrollPhysics(),

      // to disable GridView's scrolling
      children: List.generate(6, (index) {
        return Container(
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
        );
      }),

//      children: List.generate(_readyToUploadImages.length, (index) {
//        Asset images = _readyToUploadImages[index];
//        return Center(
//          child: AssetThumb(
//            asset: images,
//            width: 100,
//            height: 100,
//            spinner: mStatlessWidgets().EmptyView(),
//          ),
//        );
//      }),
    );
  }

  Widget buildGridView3() {
    final orientation = MediaQuery
        .of(context)
        .orientation;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueGrey, width: 1.0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: GridView.builder(
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
              ? GridTile(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border:
                    Border.all(color: Colors.deepOrange, width: 5)),
                child: Image(
                  color: Colors.grey.withOpacity(0.4),
                  fit: BoxFit.fill,
                  image: AssetImage(AvailableImages.myIcon),
                ),
              ),
            ),
          )
              : rowItem(files[index], index);
        },
      ),
    );
  }

  var imagee;

  Widget rowItem(File image, int index) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            log('$index');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PhotoViewQ(
                      fileImage: image,
                    ),
              ),
            );
          },
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              // color: Colors.black12,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Image.file(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
        ),

        /// top
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: GestureDetector(
            onTap: () {
              log("remove ");
              files.removeAt(index);
              setState(() {
//                https://stackoverflow.com/questions/51931017/update-ui-after-removing-items-from-list
                files = List.from(files);
              });
            },
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                  // topLeft: Radius.circular(8),
                  // topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Icon(
                      Icons.delete,
                      textDirection: TextDirection.rtl,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        /// bottom
        Align(
          alignment: AlignmentDirectional.topCenter,
          child: GestureDetector(
            onTap: () {
//               log("remove ");
//               files.removeAt(index);
//               setState(() {
// //                https://stackoverflow.com/questions/51931017/update-ui-after-removing-items-from-list
//                 files = List.from(files);
//               });
            },
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Colors.black12.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  // bottomLeft: Radius.circular(10),
                  // bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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

  List<dynamic> _getListOfImagesFromUser(HebaModel post2) {
    dynamic list = post2.imageUrls;
    return list;
  }

//  Widget buildGridView2(HebaModel post, int index) {
//    /// fetch the list
//    var listFromFirebase =
//        _getListOfImagesFromUser(post).cast<String>().toList();
//    int _current = 0;
//
//    return GridView.builder(
//      itemCount: _readyToUploadImages.length,
//      itemBuilder: (BuildContext context, int index) {
//        Asset images = _readyToUploadImages[index];
//
//        return Container(
//          child: Stack(
//            alignment: Alignment.bottomCenter,
//            children: <Widget>[
//              FadeInImage(
//                image: Image.asset(),
//                placeholder: AssetImage(AvailableImages.appIcon),
//                fit: BoxFit.cover,
//                width: double.infinity,
//                height: double.infinity,
//              ),
//              Container(
//                color: Colors.black.withOpacity(0.7),
//                height: 30,
//                width: double.infinity,
//                child: Center(
//                  child: Text(
//                    imageModel.folderName,
//                    maxLines: 1,
//                    overflow: TextOverflow.ellipsis,
//                    style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 16,
//                        fontFamily: 'Regular'
//                    ),
//                  ),
//                ),
//              )
//            ],
//          ),
//        );
//
//      },
//      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//        crossAxisCount: 5,
//      ),
//    );
//  }

  ///  Buttons
  _Buttons(ok) {
//    log('Location From _Buttons : Lat  ${userLocation?.latitude}, Long: ${userLocation?.longitude}');

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[

          ///  Submit Btn

          FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              splashColor: Colors.blueAccent,
              color: ok ? Colors.green : Colors.red,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Center(
                        child: new Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Center(
                            child: Text(
                              "إضافة ",
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Center(
                          child: Icon(
                            getIcon(ok),
                            color: Colors.white,
                            size: 23,
                          ),
                        ),
                      ),
                    ],
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
                if (ok == true) {
                  _Send();
                } else {
                  _displaySnackBar(context,
                      "تأكد من إسم الهبة أن يكون أكثر من 7 أحرف وإدخال رقم الجوال بشكل صحيح");
                }

                // or
//                var s = submit().whenComplete(() {
//                  log("submit whenComplete ");
//
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => HomeScreen()));
//                });
              }),
        ],
      ),
    );
  }

  IconData getIcon(ok) {
    return !ok ? Icons.warning : Icons.done;
  }

  void _Send() async {
    log("Submit called ");
    if (_name.isNotEmpty && _currentContactMethod.isNotEmpty) {
      final action = await CustomDialog1.addNewHebaDialog(
          context, '  إضافة الهبة', 'متأكد من المعلومات عزيزي ؟؟ ');

      if (action == DialogAction.yes) {
        log("Before _SendToServer ");
        FocusScope.of(context).unfocus();

        await _SendToServer().whenComplete(() {
          _displaySnackBar(context, " تم إضافة الهبة بنجاح");

          setState(() {
            showSpinner = false;
          });
        }).catchError((e) {
          log(e.toString());
        });

        log("after _SendToServer ");

        if (this.mounted) {
          setState(() {
            tappedYes = true;
            log("tappedYes $tappedYes ");
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

  getType(String type) {
    type = _currentContactMethod;
    switch (type) {
      case 'واتساب':
        return TextInputType.number;
      case 'تيلجرام':
        return TextInputType.text;
    }
    return TextInputType.text;
  }
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)} bytes sent');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
