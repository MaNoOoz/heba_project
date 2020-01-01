/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:heba_project/service/FirestoreServiceAuth.dart';
import 'package:heba_project/ui/Screens/SignupScreen.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';
  final Color primaryColor;
  final Color backgroundColor;
  final AssetImage backgroundImage;

  const LoginScreen(
      {Key key, this.primaryColor, this.backgroundColor, this.backgroundImage})
      : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  /// Methods ================================================================================
  _LoginToTheApp() {
    print('Called');
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      AuthService.login(_email, _password);

//      await loginAction();
    } else {
      print('some thing wrong with form');
    }
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
    return SafeArea(
      child: Scaffold(
        body: ListView(children: <Widget>[
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                /// Image
                SizedBox(
                  child: Image(
                    image: widget.backgroundImage,
                    fit: BoxFit.fill,
                  ),
                ),

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
                      color: Colors.red,
                    ),
                  ),
                ),

                /// Form
                Flexible(
                  flex: 4,
                  child: FormUi(),
                ),

                /// login btn
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Expanded(
                          child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                  new BorderRadius.circular(30.0)),
                              splashColor: Colors.grey,
                              color: Colors.grey,
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Center(
                                    child: new Padding(
                                      padding:
                                      const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        "LOGIN",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              onPressed: () {
                                _LoginToTheApp();
                              }),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Register btn
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
                                "DON'T HAVE AN ACCOUNT?",
                                style: TextStyle(color: Colors.blueAccent),
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

                /// facebook btn  + google btn
//                Flexible(
//                  child: Container(
//                    margin: const EdgeInsets.only(top: 10.0),
//                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: <Widget>[
//                        Expanded(
//                          flex: 2,
//                          child: FlatButton(
//                            shape: new RoundedRectangleBorder(
//                                borderRadius: new BorderRadius.circular(30.0)),
//                            splashColor: Colors.white,
//                            color: Color(0xff3B5998),
//                            child: new Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                              children: <Widget>[
//                                Icon(
//                                  FontAwesomeIcons.facebookF,
//                                  color: Colors.white,
//                                ),
//                                Padding(
//                                  padding: const EdgeInsets.only(left: 2.0),
//                                  child: Text(
//                                    "FACEBOOK",
//                                    style: TextStyle(color: Colors.white),
//                                  ),
//                                ),
//                              ],
//                            ),
//                            onPressed: () => {},
//                          ),
//                        ),
//                        UIHelper.horizontalSpace(10),
//                        Expanded(
//                          flex: 2,
//                          child: FlatButton(
//                            shape: new RoundedRectangleBorder(
//                                borderRadius: new BorderRadius.circular(30.0)),
//                            splashColor: Colors.red[200],
//                            color: Colors.red,
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                              children: <Widget>[
//                                Icon(
//                                  FontAwesomeIcons.google,
//                                  color: Colors.white,
//                                ),
//                                Padding(
//                                  padding: const EdgeInsets.only(left: 2.0),
//                                  child: Text(
//                                    "GOOGLE",
//                                    style: TextStyle(color: Colors.white),
//                                  ),
//                                ),
//                              ],
//                            ),
//                            onPressed: () => {},
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget FormUi() {
    return Form(
      key: _formKey,
      child: ListView(
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
                    !input.contains('@')
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
