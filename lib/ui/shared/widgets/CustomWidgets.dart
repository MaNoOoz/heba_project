/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';
import 'package:heba_project/service/FirestoreServiceAuth.dart';
import 'package:heba_project/ui/shared/Assets.dart';

class mStatlessWidgets {
  Widget mAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: Center(
        child: IconButton(
            padding: EdgeInsets.only(left: 30.0),
            onPressed: () => print('Menu'),
            icon: Icon(Icons.menu),
            iconSize: 30.0,
            color: Colors.black45),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/appicon.png',
              width: 32,
              height: 32,
              fit: BoxFit.scaleDown,
              scale: 3.0,
            ),
          ),
          Text(
            'هبــة',
            style: TextStyle(
              fontSize: 32,
              color: Colors.black45,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black45,
          ),
          onPressed: () async {
            FirestoreServiceAuth.signOutFirebase();
//            Navigator.pushNamed(context, LoginScreen.id);

            print("message");
          },
        ),
      ],
    );
  }

  Widget mLoading({String title}) {
    return Container(
      color: Colors.grey[900].withOpacity(0.8),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget LogoView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image(
        color: Colors.grey.withOpacity(0.4),
        image: AssetImage(AvailableImages.appIcon),
      ),
    );
  }
}

class mLables extends StatelessWidget {
  Color mColor;
  BuildContext context;
  String mTitle;
  double mWidth;
  TextStyle mStyle;

  mLables({this.context, this.mColor, this.mTitle, this.mWidth, this.mStyle});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: mColor,
      width: mWidth,
      child: Center(
        child: Text(
          mTitle,
          style: mStyle,
        ),
      ),
    );
  }
}

class ButtonMessage extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;

  const ButtonMessage(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: MessageBorder(usePadding: false),
        shadows: [
          BoxShadow(color: Colors.black, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: MessageBorder(),
        child: InkWell(
          splashColor: Colors.orange,
          hoverColor: Colors.blueGrey,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Container(
            height: 64,
            padding: EdgeInsets.only(bottom: 20, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 7,
                  height: 8,
                  decoration: BoxDecoration(
                      color: Color(0xFFCCCCCC), shape: BoxShape.circle),
                ),
                Container(
                  width: 3,
                ),
                Container(
                  width: 7,
                  height: 8,
                  decoration: BoxDecoration(
                      color: Color(0xFFCCCCCC), shape: BoxShape.circle),
                ),
                Container(
                  width: 3,
                ),
                Container(
                  width: 7,
                  height: 8,
                  decoration: BoxDecoration(
                      color: Color(0xFFCCCCCC), shape: BoxShape.circle),
                ),
                Container(
                  width: 6,
                ),
                Container(
                  width: 25,
                  height: 24,
                  decoration: BoxDecoration(
                      color: Color(0xFF1287BA), shape: BoxShape.circle),
                  child: Center(
                    child:
                        Text(text, style: TextStyle(color: Color(0xFFFFFFFF))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageBorder extends ShapeBorder {
  final bool usePadding;

  MessageBorder({this.usePadding = true});

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 20 : 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - Offset(0, 20));
    return Path()
      ..addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)))
      ..moveTo(rect.bottomCenter.dx - 10, rect.bottomCenter.dy)
      ..relativeLineTo(10, 20)
      ..relativeLineTo(20, -20)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
