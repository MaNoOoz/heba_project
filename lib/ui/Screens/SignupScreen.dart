/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:heba_project/service/FirestoreServiceAuth.dart';

class SignupScreen extends StatefulWidget {

  static final String id = 'signup_screen';
  final Color primaryColor;
  final Color backgroundColor;
  final AssetImage backgroundImage;

  const SignupScreen(
      {Key key, this.primaryColor, this.backgroundColor, this.backgroundImage})
      : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  String _name, _email, _password;

  /// methods ================================================================================
  _CreateNewAcount() {
    print('_CreateNewAcount Called');
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Logging in the user w/ Firebase
      AuthService.signUpUser(context, _name, _email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: ListView(
        children: <Widget>[
          Image(
            image: widget.backgroundImage,
          ),
          Center(
            child: Text(
              ' هبة',
              style: TextStyle(
                fontFamily: ArabicFonts.Cairo,
                fontSize: 32.0,
                letterSpacing: 5,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),

          FormUi(context),

          /// Register btn
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              splashColor: Colors.white,
              color: Color(0xff3B5998),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.creativeCommonsZero,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Create Acount",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                _CreateNewAcount();
                _displaySnackBar(context);
              },
            ),
          )
        ],
      ),
    );
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Are you talkin\' to me?'));
    globalKey.currentState.showSnackBar(snackBar);
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
                    input.length < 3 ? 'Please enter a valid name' : null,
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
