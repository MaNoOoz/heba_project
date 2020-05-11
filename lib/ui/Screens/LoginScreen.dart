/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:heba_project/service/FirestoreServiceAuth.dart';
import 'package:heba_project/ui/Screens/HomeScreen.dart';
import 'package:heba_project/ui/Screens/SignupScreen.dart';
import 'package:heba_project/ui/shared/UI_Helpers.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';
  final Color primaryColor;
  final Color backgroundColor;
  final AssetImage backgroundImage;
  final String currentUserId;

  const LoginScreen({Key key,
    this.currentUserId,
    this.primaryColor,
    this.backgroundColor,
    this.backgroundImage})
      : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool loading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  /// Methods ================================================================================

  Future<bool> _LoginToTheApp() async {
    print('_LoginToTheApp : Called');
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        FirestoreServiceAuth.loginWithFirebase(_email, _password);
        var cu = await FirestoreServiceAuth.isUserLogged();
        print('current User Check bool : ${cu}  ');

        return true;
      } else {
        _displaySnackBar(context, "Enter Correct Info");
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  _displaySnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text('أدخل معلومات صحيح' + message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
//  Future<bool> loginAction() async {
//    //replace the below line of code with your login request
//    // Logging in the user w/ Firebase
//    await new Future.delayed(const Duration(seconds: 2));
//    return true;
//  }

  /// Widgets ================================================================================

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: Column(
            children: <Widget>[
              /// Logo
              Flexible(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.transparent,
//                        backgroundImage:
//                            AssetImage('assets/images/appicon.png'),
                        child: Image.asset(
                          'assets/images/appicon.png',
                        )),
                  ),
                ),
              ),

              UIHelper.verticalSpace(10),

              /// AppName
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  ' هــبـة ',
                  style: TextStyle(
                    fontFamily: ArabicFonts.Cairo,
                    fontSize: 32.0,
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                  ),
                ),
              ),

              /// Form
              FormUi(),
//                    UIHelper.verticalSpace(20),
              /// Login btn
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    splashColor: Colors.white,
                    color: Colors.teal,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.personBooth,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Login To Your Acount",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      await _LoginToTheApp().then((_) {
                        _scaffoldKey.currentState.showSnackBar(
                          new SnackBar(
                            duration: new Duration(seconds: 4),
                            content: new Row(
                              children: <Widget>[
                                new CircularProgressIndicator(),
                                new Text("  Signing-In...")
                              ],
                            ),
                          ),
                        );
                      }).whenComplete(() {
//                        Navigator.of(context).pushNamed(HomeScreen.id);
                        print("${_email}");
                      });
                    },
                  ),
                ),
              ),

              /// facebook btn  + google btn
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          splashColor: Colors.white,
                          color: Color(0xff3B5998),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.facebookF,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Text(
                                  "FACEBOOK",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            print("Soon");
                          },
                        ),
                      ),
                      UIHelper.horizontalSpace(10),
                      Expanded(
                        flex: 2,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          splashColor: Colors.red[200],
                          color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Text(
                                  "GOOGLE",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            return FirestoreServiceAuth.signInWithGoogle()
                                .whenComplete(() {
                              print(FirestoreServiceAuth
                                  .googleSignIn.currentUser.displayName);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return HomeScreen();
                                  },
                                ),
                              );
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Continue as Guest btn
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Continue as Guest",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, HomeScreen.id);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Register btn
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 30,
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            color: Colors.pink,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                " Create a New Account?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, SignupScreen.id);
                            },
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
    );
  }

  Widget FormUi() {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          ///
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
                    color: Colors.black45,
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
                    validator: (input) {
                      log("$input");
                      return !input.trim().contains('@')
                          ? 'Please enter a valid email'
                          : null;
                    },
                    onSaved: (input) => _email = input,
                  ),
                ),
              ],
            ),
          ),

          ///
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
                    color: Colors.black45,
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
                      hintText: 'Enter your email',
                    ),
                    validator: (input) =>
                    input.length < 6
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
/**/
