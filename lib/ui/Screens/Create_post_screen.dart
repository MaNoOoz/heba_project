import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/service/storage_service.dart';
import 'package:heba_project/ui/Screens/HomeScreen.dart';
import 'package:heba_project/ui/shared/Constants.dart';
import 'package:heba_project/ui/shared/Dialogs.dart';
import 'package:heba_project/ui/shared/UtilsImporter.dart';
import 'package:heba_project/ui/shared/ui_helpers.dart';
import 'package:heba_project/ui/widgets/CustomDialog.dart';
import 'package:heba_project/ui/widgets/circular_clipper.dart';
import 'package:heba_project/ui/widgets/mWidgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  static final String id = 'CreatePostScreen';
  final String currentUserId;
  Key key;
  HebaModel post;

  CreatePostScreen({Key key, this.currentUserId}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with SingleTickerProviderStateMixin {
  /// https://mrflutter.com/how-to-use-progress-indicators-in-flutter/
  bool _loading;
  bool tappedYes = false;

  /// Multi Image Picker ====================================
  List<Asset> _readyToUploadImages = List<Asset>();
  var uploadingState;
  var mSelectedImage;
  List<dynamic> mImagesPath;
  String _error = 'No Error Dectected';

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
  TextEditingController _textFieldControllerName;
  TextEditingController _textFieldControllerDesc;
  bool _autoValidate = false;
  String _name;
  String _desc;
  String _city;
  bool showSpinner = false;

  /// Map ====================================================
  String mCl;
  Color color;
  Future<BottomSheet> mBottomSheetForFiltiring;

  ///  ====================================================

  @override
  void initState() {
    init();
    _loading = false;
    _textFieldControllerName = TextEditingController();
    _textFieldControllerDesc = TextEditingController();
    this._name = _textFieldControllerName.text;
    this._desc = _textFieldControllerDesc.text;
    super.initState();
  }

  init() async {
    /// init Data
    if (this.mounted == true) {
      print("this.mounted");

      _dropDownMenuItemsStrings = cities;
      _currentCity = _dropDownMenuItemsStrings.elementAt(0);
      print("_dropDownMenuItemsStrings : $_currentCity");

//      await Geolocator().getCurrentPosition().then((currloc) {
//        setState(() {
//          currentPosition = currloc;
//          print(" currentPosition :  ${currentPosition.longitude}");
//
//        });
//
//      });

    }
  }

  @override
  Widget build(BuildContext context) {
    fuser = Provider.of<FirebaseUser>(context).displayName;
    fuserImage = Provider.of<FirebaseUser>(context).photoUrl;

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
              FormUi(context),
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
//              Container(
//                margin: EdgeInsets.all(15.0),
////            color: Colors.teal,
//                child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Center(
//                    child: Text(
//                      's',
//                      style: TextStyle(
//                          fontSize: 16,
//                          color: Colors.black45,
//                          fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                ),
//              ),

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
                          onPressed: () async {
                            await _loadAssets();
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




  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in cities) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCity = selectedCity;
      print("changedDropDownItem _currentCity is :$_currentCity");
    });
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
                decoration:
                UtilsImporter().uStyleUtils.textFieldDecorationCircle(
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
//                                  currentPosition.latitude == null
//                                      ? ""
//                                      : "${currentPosition.latitude}",
//                                  style: TextStyle(
//                                    fontSize: 12,
//                                    color: Colors.blueAccent,
//                                    fontWeight: FontWeight.bold,
//                                  ),
//                                ),
//                              ),
//                        Flexible(
//                          flex: 1,
//                          child: Align(
//                              alignment: AlignmentDirectional.centerEnd,
//                              child: Text(
//                                "تحديد الموقع الحالي",
//                                style: TextStyle(
//                                    fontSize: 12,
//                                    color: Colors.black45,
//                                    fontWeight: FontWeight.bold),
//                              )),
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
            Divider(),
//            https://codingwithjoe.com/building-forms-with-flutter/
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
                          isEmpty: _currentCity == '',
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              value: _currentCity,
                              isDense: true,
                              onChanged: (String newValue) {
                                changedDropDownItem(newValue);
                              },
                              items: _dropDownMenuItemsStrings.map((
                                  String value) {
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

            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  /// Methods ==========================================================================================

  showAddHebaDialog(BuildContext context) {
    return CustomDialog(
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

  /// Multi Image Picker ======================================================
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
          actionBarColor: "#a"
              "bcdef",
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

  Future<HebaModel> _CreatePost() async {
    print("_CreatePost Called");
    HebaModel publicFeed;
    HebaModel privateFeed;

    mImagesPath = await _listOfImageLinks();
    print("mImagesPath: ${mImagesPath.length} ");

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
//    var geFirePoint = GeoFirePoint(lat, long);

    publicFeed = HebaModel(
        oName: fuser,
        oImage: fuserImage,
        isFeatured: false,
        isMine: isMine,
        imageUrls: mImagesPath,
        hName: _name,
        geoPoint: gePoint,
//        geoFirePoint: geFirePoint,
        hDesc: _desc,
        hCity: _currentCity,
        authorId: widget.currentUserId,
        timestamp: ts);

//    print("geFirePoint :${geFirePoint.geoPoint}");

    /// database
    DatabaseService.createPublicPosts(publicFeed);

    /// private Post Object
//    privateFeed = Post2(
//          imageUrls: mImagesPath,
//          oName: fuser,
//          oImage: fuserImage,
//          isFeatured: false,
//          isMine: isMine,
////          location: fetchedLocation,
////          geoPoint: GeoPoint(fetchedLocation.latitude, fetchedLocation.longitude),
//          hName: _name,
//          hDesc: _desc,
//          authorId: widget.currentUserId,
//          timestamp: ts);

    /// database
//      DatabaseService.createPrivatePost(publicFeed);

//    /// public Post Object

//    current_location = post2.location;

    //    setState(() {
//      var mLocation = cl;
//    });
//
////    print(" _CreatePost :_GetUserCar  Called ${mCar.id}");
//    Map<String, dynamic> sd = {
//      'lat': 12.0,
//      'long': 12.9,
//    };
//    mCar = Car(id: "from 548");
//    print("car before map ${mCar.id}  ${mCar.drive()}");
//    mCar = Car.fromJson(sd);
//    var ts = Timestamp.fromDate(DateTime.now());
//    print("car after map ${mCar.id} ${sd['id']} ${mCar.drive().toString()}");
//

    return publicFeed;
  }

  var finalCheck;

  /// Reset data
  Future<bool> _Resetdata() async {
    var dateRested = true;
    print("_Resetdata Called");

    _textFieldControllerName.clear();
    _textFieldControllerDesc.clear();
    _readyToUploadImages.clear();
    mImagesPath.clear();

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

    /// Create New Post
    var postCreated = await _CreatePost();

//    /// Check Location
//    var userLocationCreated = await _GetUserLocation();

    setState(() {
      dataChecked = true;
    });

    /// Rest Fields
    var fieldsRested = await _Resetdata();
    print('fieldsRested $fieldsRested');

    finalCheck =
        dataChecked == false || postCreated != null || fieldsRested == true;

    if (finalCheck == true) {
//      todo
//      _displaySnackBar(context, " تم إضافة الهبة بنجاح");

      print("fieldsRested $fieldsRested     " +
          "userLocationCreated From _CreatePost $postCreated " +
          "dataChecked  $dataChecked     " +
          "fieldsRested $fieldsRested   ");
    }

    return dataUploaded;
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
        content: Text(" أدخل إسم للهبة $_name"),
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
//    print('Location From _Buttons : Lat  ${userLocation?.latitude}, Long: ${userLocation?.longitude}');

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[
          /// Add Images Btn
          UIHelper.verticalSpace(10),

          Center(child: Text('Error: $_error}')),
          UIHelper.verticalSpace(10),

          UIHelper.verticalSpace(10),

          _loading ? mStatlessWidgets().mLoading() : SizedBox.shrink(),

          ///  Submit Btn
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
                          "إضافة الإعلان",
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
                await submit();

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

  submit() async {
    print("Submit called ");

    if (_name.isNotEmpty && !_loading && this.mounted == true) {
      final action = await Dialogs.addNewHebaDialog(
          context, ' Add Heba', 'Are You Sure You Want To Add This Post');
      if (action == DialogAction.yes) {
        print("Before _SendToServer ");

        await _SendToServer();
        await Future.delayed(Duration(seconds: 5)).whenComplete(() {
          _displaySnackBar(context, " تم إضافة الهبة بنجاح");
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
    } else if (_name.isNotEmpty == false) {
      _displaySnackBar(context, " أدخل إسم للهبة $_name");
    }
  }
}
//Future<UserLocation> _GetUserLocation() async {
//  var ll = await LocationService().getLocation();
//
////    Map<String, dynamic> lM = {
////      "lat": current_location.latitude,
////      "long": current_location.longitude,
////      "address": current_location.address,
////    };
////
////    UserLocation s = UserLocation.fromJsonMap(lM);
////    print("_GetUserLocation Called");
////    print("${s.longitude} Called");
////
////    current_location = UserLocation(
////      address: current_location.address,
////      longitude: current_location.longitude,
////      latitude: current_location.latitude,
////    );
////    setState(() {
////      s = current_location;
////    });
//  return ll;
//}
//
////  Future<Car> _GetUserCar() async {
////    print("_GetUserCar Called");
////
////    Car s = Car(
////      id: "from _GetUserCar Object Name s",
////    );
////
////    return s;
////  }
