/*
 * Copyright (c) 2020.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heba_project/service/FirestoreServiceAuth.dart';
import 'package:heba_project/ui/Screens/HomeScreen.dart';
import 'package:heba_project/ui/Screens/SignupScreen.dart';
import 'package:heba_project/ui/shared/Assets.dart';
import 'package:heba_project/ui/shared/utili/UI_Helpers.dart';
import 'package:heba_project/ui/shared/widgets/CustomWidgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'file:///H:/Android%20Projects/Projects/Flutter%20Projects/Mine/heba_project/lib/ui/shared/utili/UtilsImporter.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';
  final Color primaryColor;
  final Color backgroundColor;
  final AssetImage backgroundImage;
  final String currentUserId;

  const LoginScreen(
      {Key key,
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

  var showSpinner = false;

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
        var cu = await FirestoreServiceAuth.isFirebaseUserLogged();
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
          body: ModalProgressHUD(
            color: Colors.black,
            progressIndicator: mStatlessWidgets().mLoading(title: "Loading"),
            inAsyncCall: showSpinner,
            child: Column(
              children: <Widget>[

                /// Logo
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white70,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    // height: 200,
                    child: Align(
                      alignment: AlignmentDirectional.center,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                            backgroundColor: Colors.amber,
                            radius: 60,

//                        backgroundImage:
//                            AssetImage('assets/images/appicon.png'),
                            child: Image.asset(
                              AvailableImages.myIcon,
                              fit: BoxFit.fill,
                              scale: 1,
                              height: 100,
                              width: 100,
                            )),
                      ),
                    ),
                  ),
                ),

                UIHelper.verticalSpace(10),

                /// Form
                FormUi(),
                UIHelper.verticalSpace(20),

                /// Login btn
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
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
                              "Login To Your Account",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                          Navigator.of(context).pushNamed(HomeScreen.id);
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
                                borderRadius: new BorderRadius.circular(10.0)),
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
                                borderRadius: new BorderRadius.circular(10.0)),
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
                            onPressed: () async {
                              FirestoreServiceAuth.signInWithGoogle()
                                  .then((value) {
                                showSpinner = true;
                                print(
                                    "signInWithGoogle : ${FirestoreServiceAuth
                                        .googleSignIn.currentUser
                                        .displayName}");
                                print("signInWithGoogle : ${value}");
                              }).whenComplete(() {
                                print(
                                    "signInWithGoogle : ${FirestoreServiceAuth
                                        .googleSignIn.currentUser
                                        .displayName}");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomeScreen();
                                    },
                                  ),
                                );
                                showSpinner = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Continue as Guest btn
//                Flexible(
//                  child: Container(
//                    margin: const EdgeInsets.only(top: 10.0),
//                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                    child: new Row(
//                      children: <Widget>[
//                        new Expanded(
//                          child: FlatButton(
//                            shape: new RoundedRectangleBorder(
//                                borderRadius: new BorderRadius.circular(10.0)),
//                            color: Colors.transparent,
//                            child: Container(
//                              padding: const EdgeInsets.only(left: 20.0),
//                              alignment: Alignment.center,
//                              child: Text(
//                                "Continue as Guest",
//                                style: TextStyle(
//                                    color: Colors.green,
//                                    fontWeight: FontWeight.bold),
//                              ),
//                            ),
//                            onPressed: () {
//                              Navigator.pushNamed(context, HomeScreen.id);
//                            },
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),

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
                                  borderRadius:
                                  new BorderRadius.circular(10.0)),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration:
                  UtilsImporter().uStyleUtils.textFieldDecorationCircle(
                    hint: UtilsImporter().uStringUtils.hintEmail,
                    lable: UtilsImporter().uStringUtils.labelEmail,
                    icon: Icon(Icons.person),
                  ),
//                    decoration: InputDecoration(
//                      labelText: 'Email',
//                      hintStyle: TextStyle(color: Colors.grey),
//                      border: InputBorder.none,
//                      hintText: 'Enter your email',
//                    ),
                  validator: (input) =>
                  !input.trim().contains('@')
                      ? 'Please enter a valid email'
                      : null,

//                    validator: (input) {
//                      log("$input");
//                      return !input.trim().contains('@')
//                          ? 'Please enter a valid email'
//                          : null;
//                    },
                  onSaved: (input) => _email = input,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration:
                  UtilsImporter().uStyleUtils.textFieldDecorationCircle(
                    hint: 'Enter your Password',
                    lable: "Password",
                    icon: Icon(Icons.lock_open),
                  ),
                  validator: (input) =>
                  input
                      .trim()
                      .length < 6
                      ? 'Must be at least 6 characters'
                      : null, obscureText: true,
                  onSaved: (input) => _password = input,

                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
/**/
