import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:heba_project/service/FirestoreServiceAuth.dart';

import 'SignupScreen.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Logging in the user w/ Firebase
      AuthService.login(_email, _password);
    }
  }

//  TextEditingController _controller = TextEditingController();
//
//  final log = Logger(printer: PrettyPrinter(
//    methodCount: 0,
//    errorMethodCount: 3,
//    lineLength: 30,
//    colors: true,
//    printEmojis: true,
//    printTime: false
//  ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              Text(
                'HEBA PROJECT',
                style: TextStyle(
                  fontFamily: ArabicFonts.Cairo,
                  fontSize: 50.0,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (input) =>
                        !input.contains('@')
                            ? 'Please enter a valid email'
                            : null,
                        onSaved: (input) => _email = input,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (input) =>
                        input.length < 6
                            ? 'Must be at least 6 characters'
                            : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 250.0,
                      child: FlatButton(
                        onPressed: _submit,
                        color: Colors.blue,
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 250.0,
                      child: FlatButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, SignupScreen.id),
                        color: Colors.blue,
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Go to Signup',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
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
}

//  @override
//  Widget build(BuildContext context) {
//    return BaseView<LoginModel>(
//      builder: (context, model, child) => Scaffold(
//        backgroundColor: backgroundColor,
//        body: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            LoginHeader(
//                validationMessage: model.errorMessage, controller: _controller),
//            model.state == ViewState.Busy
//                ? CircularProgressIndicator()
//                : FlatButton(
//                    color: Colors.white,
//                    child: Text(
//                      'Login',
//                      style: TextStyle(color: Colors.black),
//                    ),
//                    onPressed: () async {
//
//                      var loginSuccess = await model.login(_controller.text);
//                      if (loginSuccess) {
//                        Navigator.pushNamed(context, '/');
//                      } else {
//                        print('Something wrong !! check login info');
//                      }
//                    },
//                  )
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//class LoginHeader extends StatelessWidget {
//  final TextEditingController controller;
//  final String validationMessage;
//
//  LoginHeader({@required this.controller, this.validationMessage});
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(children: <Widget>[
//      Text('Login', style: headerStyle),
//      UIHelper.verticalSpaceMedium(),
//      Text('Enter a number between 1 - 10', style: subHeaderStyle),
//      LoginTextField(controller),
//      this.validationMessage != null
//          ? Text(validationMessage, style: TextStyle(color: Colors.red))
//          : Container()
//    ]);
//  }
//}
//
//class LoginTextField extends StatelessWidget {
//
//  final TextEditingController controller;
//  LoginTextField(this.controller);
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      padding: EdgeInsets.symmetric(horizontal: 15.0),
//      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
//      height: 50.0,
//      alignment: Alignment.centerLeft,
//      decoration: BoxDecoration(
//          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
//      child: TextField(
//          decoration: InputDecoration.collapsed(hintText: 'User Id'),
//          controller: controller),
//    );
//  }
//}
