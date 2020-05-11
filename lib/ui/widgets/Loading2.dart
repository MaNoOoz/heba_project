import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading2 extends StatefulWidget {
  final String title;

//  final key = GlobalKey<>();

  @override
  _Loading2State createState() => _Loading2State();

  Loading2({this.title});
}

class _Loading2State extends State<Loading2> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
//    todo
    void dismissProgressHUD() {
      setState(() {
        if (_loading) {
//          _progressHUD.state.dismiss();
        } else {
//          _progressHUD.state.show();
        }

        _loading = !_loading;
      });
    }

    return AlertDialog(
      title: Text(widget.title),
      content: Container(
        color: Colors.white,
        width: 300.0,
        height: 300.0,
        child: SpinKitFadingCircle(
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.white : Colors.teal,
              ),
            );
          },
          size: 120.0,
        ),
      ),
      actions: <Widget>[
//        FlatButton(
//          child: Text('Yes'),
//          onPressed: () {},
//        ),
//        FlatButton(
//          child: Text('Yes'),
//          onPressed: () {},
//        ),
      ],
    );
  }
}