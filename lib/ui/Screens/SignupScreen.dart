/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/service/FirestoreServiceAuth.dart';
import 'package:heba_project/service/storage_service.dart';
import 'package:heba_project/ui/Screens/LoginScreen.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  static final String id = ' signup_screen';
  final Color primaryColor;
  final Color backgroundColor;
  final AssetImage backgroundImage;
  final User user;

  const SignupScreen({Key key,
    this.user,
    this.primaryColor,
    this.backgroundColor,
    this.backgroundImage})
      : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldState = GlobalKey<ScaffoldState>();

  String _name, _email, _password;
  String _imageUrl = "";
  File _profileImage;
  String currentUserId;
  User _profileUser;

  /// methods =========================
//  _CreateNewAcount() async {
//    try {
//      print('_CreateNewAcount Called');
//      if (_formKey.currentState.validate() && !_isLoading) {
//        _formKey.currentState.save();
//
//        setState(() {
//          _isLoading = true;
//        });
//        // Logging in the user w/ Firebase
//        AuthService.signUpUser(context, _name, _email, _password, _imageUrl);
//        _imageUrl = await StorageService.uploadUserProfileImageInSignUp(
//            _imageUrl, _profileImage);
//      } else {
//        _displaySnackBar(context);
//      }
//    } catch (e) {
//      print(e);
//    }
//  }

//  _setupProfileUser() async {
//      currentUserId = Provider.of<UserData>(context).currentUserId;
//
//    User profileUser =
//    await DatabaseService.getUserWithId(currentUserId);
//    print("Current User Id :  ${profileUser.id}");
//    setState(() {
//      _profileUser = profileUser;
//    });
//  }

  @override
  void initState() {
    super.initState();
//    _setupProfileUser();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: Text('An Error'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Ok"),
              )
            ],
          ),
    );
  }

  Future<bool> _CreateNewAcount() async {
    try {
      await new Future.delayed(Duration(seconds: 5));
      var valdited = _formKey.currentState.validate();

      print('_CreateNewAcount Called');
      if (valdited) {
        _formKey.currentState.save();

        /// SignUp the User In Firebase
        AuthService.signUpUser(context, _name, _email, _password, _imageUrl);
        _imageUrl = await StorageService.uploadUserProfileImageInSignUp(
            _imageUrl, _profileImage);
      } else {}
    } catch (e) {
      var errorMessage = 'This Email Already Registerd';
      if (e.toString().contains('EMAIL_ALREADY_IN_USE')) {
        _showErrorDialog("$errorMessage");
      } else if (e.toString().contains('INVALID_EMAIL')) {
        var errorMessage = 'إيميل خاطئ';
        _displaySnackBarError(context, "$errorMessage");
      }

//      else if(e.toString().contains('WEAK_PASSWORD')){
//        var errorMessage = 'Password Weak';
//        _displaySnackBarError(context,"${errorMessage}");
//      }

    }
    return true;
  }

  _displayProfileImage() {
    // No new profile image
    if (_profileImage == null) {
      return AssetImage('assets/images/uph.jpg');
    } else {
      // New profile image
      return FileImage(_profileImage);
    }
  }

  _handleImageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _profileImage = imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldState,
          body: ListView(
            children: <Widget>[
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.grey,
                            backgroundImage: _displayProfileImage(),
                          ),
                        ),
                        FlatButton(
                          onPressed: _handleImageFromGallery,
                          child: OutlineButton(
                            onPressed: () => _handleImageFromGallery,
                            child: Text(
                              'Add Profile Image',
                              style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .accentColor,
                                  fontSize: 16.0),
                            ),
                          ),
                        ),
                      ],
                    ),

//                    /// Image
//                    Center(
//                      child: CircleAvatar(
//                          radius: 60.0,
//                          backgroundColor: Colors.transparent,
////                        backgroundImage:
////                            AssetImage('assets/images/appicon.png'),
//                          child: Image.asset(
//                            'assets/images/appicon.png',
//                            scale: 2.0,
//                          )),
//                    ),

                    FormUi(context),

                    /// Register btn
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        splashColor: Colors.white,
                        color: Colors.blueAccent,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.userPlus,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Create New Acount",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
//                          _scaffoldState.currentState
//                              .showSnackBar(snackBarLoading);
                          _displayLoadingSnackBar(context, "Signing-Up...");
                          await _CreateNewAcount().whenComplete(
                                () {
                              print("Acount Created With Name : ${_name}");
                            },
                          ).catchError(
                                (onError) {
                              _displaySnackBarError(
                                  context, "${onError.toString()}");

                              print("$onError");
                            },
                          );
                        },
                      ),
                    ),

                    /// Go To Login
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                  new BorderRadius.circular(30.0)),
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.only(left: 20.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "ALREADY HAVE AN ACCOUNT?",
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, LoginScreen.id);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displaySnackBarError(BuildContext context, String message) {
    final snackBarError = SnackBar(
      duration: new Duration(seconds: 4),
      content: new Text("$message"),
    );
    _scaffoldState.currentState.removeCurrentSnackBar();
    _scaffoldState.currentState.showSnackBar(snackBarError);
  }

  _displayLoadingSnackBar(BuildContext context, String message) {
    final snackBarLoading = SnackBar(
      duration: new Duration(seconds: 4),
      content: new Row(
        children: <Widget>[
          new CircularProgressIndicator(),
          new Text("$message")
        ],
      ),
    );
    _scaffoldState.currentState.removeCurrentSnackBar();
    _scaffoldState.currentState.showSnackBar(snackBarLoading);
  }

  Widget FormUi(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.grey.withOpacity(0.5),
                  margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      hintText: 'Enter your Name',
                    ),
                    validator: (input) =>
                    input
                        .trim()
                        .length < 3
                        ? 'Please enter a valid name'
                        : null,
                    onSaved: (input) => _name = input,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.grey.withOpacity(0.5),
                  margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      hintText: 'Enter your email',
                    ),
                    validator: (input) =>
                    !input.trim().contains('@')
                        ? 'Please enter a valid email'
                        : null,
                    onSaved: (input) => _email = input,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Icon(
                    Icons.lock_open,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.grey.withOpacity(0.5),
                  margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      hintText: 'Enter your Password',
                    ),
                    validator: (input) =>
                    input
                        .trim()
                        .length < 6
                        ? 'Must be at least 6 characters'
                        : null,
                    onSaved: (input) => _password = input,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
