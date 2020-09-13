import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class PhotoViewQ extends StatelessWidget {
  ImageProvider imageProvider;
  File fileImage;

  PhotoViewQ({this.imageProvider, this.fileImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Image.file(fileImage),
      ),
    );
  }
}
