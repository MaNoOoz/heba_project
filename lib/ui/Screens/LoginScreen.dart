import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/scopedmodels/LoginModel.dart';
import 'package:heba_project/service/ViewState.dart';
import 'package:heba_project/ui/Views/BaseView.dart';
import 'package:heba_project/ui/shared/app_colors.dart';
import 'package:heba_project/ui/shared/text_styles.dart';
import 'package:heba_project/ui/shared/ui_helpers.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();
  final log = Logger(printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 3,
    lineLength: 30,
    colors: true,
    printEmojis: true,
    printTime: false
  ));

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoginHeader(
                validationMessage: model.errorMessage, controller: _controller),
            model.state == ViewState.Busy
                ? CircularProgressIndicator()
                : FlatButton(
                    color: Colors.white,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {

                      var loginSuccess = await model.login(_controller.text);
                      if (loginSuccess) {
                        Navigator.pushNamed(context, '/');
                      } else {
                        print('Something wrong !! check login info');
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }
}

class LoginHeader extends StatelessWidget {
  final TextEditingController controller;
  final String validationMessage;

  LoginHeader({@required this.controller, this.validationMessage});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Login', style: headerStyle),
      UIHelper.verticalSpaceMedium(),
      Text('Enter a number between 1 - 10', style: subHeaderStyle),
      LoginTextField(controller),
      this.validationMessage != null
          ? Text(validationMessage, style: TextStyle(color: Colors.red))
          : Container()
    ]);
  }
}

class LoginTextField extends StatelessWidget {

  final TextEditingController controller;
  LoginTextField(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      height: 50.0,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: TextField(
          decoration: InputDecoration.collapsed(hintText: 'User Id'),
          controller: controller),
    );
  }
}
