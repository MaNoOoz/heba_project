import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/service/LocationService.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/service/storage_service.dart';
import 'package:heba_project/ui/Screens/HomeScreen.dart';
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
  Post2 post;

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
  var imageUrl2;
  var uploadingState;
  var mSelectedImage;
  var mImagesPath;
  String _error = 'No Error Dectected';

  /// Post ===================================================
  var userId;
  var fuser;
  var fuserImage;
  var currentUserId;
  var isMine;
  var mCar;
  UserLocation fetchedLocation;

  /// Form ====================================================
  GlobalKey<FormState> _formkey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textFieldControllerName;
  TextEditingController _textFieldControllerDesc;

//  TextEditingController _textFieldControllerLoca;
//  TextEditingController _textFieldControllerLoca2;
  bool _autoValidate = false;
  String _name;
  String _desc;
  bool showSpinner = false;

  /// Map ====================================================
  String mCl;
  Color color;
  UserLocation current_location;
  Future<BottomSheet> mBottomSheetForFiltiring;

//  final Map<String, Marker> _markers = {};
  final Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(26.0055512, 44.169235);
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  String city = "";

  ///  ====================================================
  _LocationFromFuture() async {
    UserLocation ll;
    try {
      ll = await LocationService().getLocation();
      print("_LocationFromFuture : ${ll.address}");
      return ll;
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    } finally {
      print("_LocationFromFuture Done");
    }
    return ll;
  }

  @override
  void initState() {
    super.initState();

    _loading = false;
    _textFieldControllerName = TextEditingController();
    _textFieldControllerDesc = TextEditingController();
    this._name = _textFieldControllerName.text;
    this._desc = _textFieldControllerDesc.text;

//    _textFieldControllerLoca = TextEditingController();
//    this._location = _textFieldControllerLoca.text;
//    this.locationString = longitude + "," + latitude;
//    this.locationString = _textFieldControllerLoca2.text;
  }

  @override
  Widget build(BuildContext context) {
    fuser = Provider
        .of<FirebaseUser>(context)
        .displayName;
    fuserImage = Provider
        .of<FirebaseUser>(context)
        .photoUrl;
    current_location = Provider.of<UserLocation>(context);

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
                      tag: "s",
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

  Container FormUi(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Form(
        key: _formkey,
        autovalidate: _autoValidate,
        child: Column(
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
            Container(
              width: double.infinity,
              child: FlatButton(
                splashColor: Colors.black12,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    Text(
                      "${city}",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          "تحديد الموقع",
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.bold),
                        )),
                    const Icon(
                      Icons.location_on,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
                onPressed: () async {
                  fetchedLocation = await _GetUserLocation().then((value) {
                    city = value.address;
                    print(
                        " Create _post_Screen :FormUi: onPressed currentLocation.address = ${value
                            .address}");
                  });
                },
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

  /// Form
  Future<bool> _validateInputs() async {
    if (_formkey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formkey.currentState.save();
      print(
          "From _validateInputs :  name $_name desc $_desc  Userlocation : $fetchedLocation");
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

  Future<Post2> _CreatePost() async {
    print("_CreatePost Called");
    Post2 post2;

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
    mImagesPath = await _listOfImageLinks();

    /// private Post Object
//    post2 = Post2(
//        imageUrls: mImagesPath,
//        oName: fuser,
//        oImage: fuserImage,
//        isFeatured: false,
////        category: Category.home,
//        hName: _name,
//        hDesc: _desc,
//        hLocation: _location,
//        authorId: Provider.of<UserData>(context, listen: false).currentUserId,
//        timestamp: Timestamp.fromDate(DateTime.now()));
//    log("private ${post2.authorId}");

//    /// public Post Object

//    current_location = post2.location;
    var currentUserId2 =
        Provider
            .of<UserData>(context, listen: false)
            .currentUserId;

    isMine = widget.currentUserId == currentUserId2;
//    isMine = widget.currentUserId;
    var ts = Timestamp.fromDate(DateTime.now());

    post2 = Post2(
        oName: fuser,
        oImage: fuserImage,
        isFeatured: false,
        isMine: isMine,
//        car: mCar,
//        location: fetchedLocation,
        imageUrls: mImagesPath,
        hName: _name,
        hDesc: _desc,
//        hLocation: _location,
        authorId: widget.currentUserId,
        timestamp: ts);
//    log("public ${post2.location.address}");

    /// private posts
//    DatabaseService.createPost(post2);

    /// public posts
//    var s = await DatabaseService.createPublicPosts2(post2).then((value) {
//      log("after public posts ${post2.authorId}");
//      print("onPressed Triggerd \n"
//          "Post Object :  name : $_name desc : $_desc location: $locationString \n"
//          " images pathes : ${mImagesPath.length} "
//          "Selected Images List : ${_readyToUploadImages.length} \n");
//    });
//    log("s ${s.toString()}");

    DatabaseService.createPublicPosts(post2);

//    _displaySnackBar(context);

//    localData data;
//    await data.addItem(post2);

    setState(() {});
//    } else {
//      _displaySnackBar(context);
//    }
    return post2;
  }

  Future<UserLocation> _GetUserLocation() async {
    var ll = await LocationService().getLocation();

//    Map<String, dynamic> lM = {
//      "lat": current_location.latitude,
//      "long": current_location.longitude,
//      "address": current_location.address,
//    };
//
//    UserLocation s = UserLocation.fromJsonMap(lM);
//    print("_GetUserLocation Called");
//    print("${s.longitude} Called");
//
//    current_location = UserLocation(
//      address: current_location.address,
//      longitude: current_location.longitude,
//      latitude: current_location.latitude,
//    );
//    setState(() {
//      s = current_location;
//    });
    return ll;
  }

//  Future<Car> _GetUserCar() async {
//    print("_GetUserCar Called");
//
//    Car s = Car(
//      id: "from _GetUserCar Object Name s",
//    );
//
//    return s;
//  }

  /// Reset data
  Future<bool> _Resetdata() async {
    var dateRested = true;
    print("_Resetdata Called");

    _textFieldControllerName.clear();
    _textFieldControllerDesc.clear();
//    _textFieldControllerLoca.clear();
//    _textFieldControllerLoca2.clear();
    _readyToUploadImages.clear();
    mImagesPath.clear();
    setState(() {
      _desc = '';
//      _location = '';
      _name = '';

//      readyToUploadImages.length = -1;
//      listOfImageLinks.length = -1;
    });
    return dateRested;
  }

  /// Send data
  Future<bool> _SendToServer() async {
    showSpinner = true;

//    await Future.delayed(Duration(seconds: 4));
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

    var finalCheck =
        dataChecked == false || postCreated != null || fieldsRested == true;
//        userLocationCreated != null;

    if (finalCheck == true) {
      dataUploaded = false;

      showSpinner = false;
      _displaySnackBar(context, " تم إضافة الهبة بنجاح");

      print("fieldsRested $fieldsRested     " +
          "userLocationCreated From _CreatePost $postCreated      " +
          "dataChecked  $dataChecked     " +
          "fieldsRested $fieldsRested   ");
    }
//    Navigator.pop(context);

    return dataUploaded;
  }

  /// Confirm data
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

  Widget showBtnSheetForMap(BuildContext context) {
    var h = MediaQuery
        .of(context)
        .size
        .height / 2;

    mBottomSheetForFiltiring = showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: h + 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  child: GoogleMap(
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                      new Factory<OneSequenceGestureRecognizer>(
                            () => new EagerGestureRecognizer(),
                      ),
                    ].toSet(),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onCameraMove: _onCameraMove,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 11,
                    ),
//                    markers: _markers.values.toSet(),
                    markers: _markers,
                  ),
                ),
//                Positioned(
//                  bottom: 50,
//                  right: 10,
//                  child: Column(
//                    children: <Widget>[
//                      RawMaterialButton(
//                        child: Icon(
//                          CupertinoIcons.location_solid,
//                          color: Colors.black38,
//                          size: 30.0,
//                        ),
//                        shape: CircleBorder(),
//                        elevation: 0.0,
//                        fillColor: Colors.white,
//                        padding: const EdgeInsets.all(8.0),
//                        onPressed: () async {
////                                Navigator.of(context).pop();
//                          _onAddMarkerButtonPressed(context);
//                        },
//                      ),
//                    ],
//                  ),
//                )
              ],
            ),
          );
        });
//    return mBottomSheetForFiltiring;
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onAddMarkerButtonPressed(BuildContext context) {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'تحديد هنا',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Future<void> _getLocationAndGoToIt(context) async {
    /// CurrentLocation
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print("userLocation :  $currentLocation");

    /// CameraPosition
    CameraPosition currentPosition = CameraPosition(
        bearing: 15.0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        tilt: 75.00,
        zoom: 12.0);

    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));

//    _onAddMarkerButtonPressed();

//    this.setState(() {
////      _markers.clear();
//      var marker = Marker(
//        markerId: MarkerId("curr_loc"),
//        position: LatLng(currentLocation.latitude, currentLocation.longitude),
//        infoWindow: InfoWindow(title: 'موقعي الخالي'),
//      );
//      _markers["Current Location"] = marker;
//    });
  }

//  void _setLocation(LocationData locData) {
//    _formData['location'] = locData;
//  }

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
                return submit();
              }),

          UIHelper.verticalSpace(10),
          UIHelper.verticalSpace(10),
        ],
      ),
    );
  }

  submit() async {
    if (_name.isNotEmpty && !_loading) {
      final action = await Dialogs.addNewHebaDialog(
          context, ' Add Heba', 'Are You Sure You Want To Add This Post');
      if (action == DialogAction.yes) {
        showLoadingDialog(context);
        await _SendToServer();
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
  }
}
