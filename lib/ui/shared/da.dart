///*
// * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
// */
//
//import 'package:flutter/material.dart';
//
//void main() => runApp(new MyApp());
//
//class MyApp extends StatefulWidget {
//  @override _MyAppState createState() => new _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  List<Asset> images = List<Asset>();
//  String _error = 'No Error Dectected';
//
//  @override void initState() {
//    super.initState();
//  }
//
//  Widget buildGridView() {
//    return GridView.count(
//      crossAxisCount: 3, children: List.generate(images.length, (index) {
//      Asset asset = images[index];
//      return ViewImages(
//        index, asset, key: UniqueKey(),);
//    }),);
//  }
//
//  Future<void> loadAssets() async {
//    setState(() {
//      images = List<Asset>();
//    });
//    List<Asset> resultList = List<Asset>();
//    String error = 'No Error Dectected';
//    try {
//      resultList = await MultiImagePicker.pickImages(
//        maxImages: 300,
//        enableCamera: false,
//        options: CupertinoOptions(takePhotoIcon: "chat"),);
//    } on PlatformException catch (e) {
//      error = e.message;
//    }
//    if (!mounted) return;
//    setState(() {
//      images = resultList;
//      _error = error;
//    });
//  }
//
//  @override Widget build(BuildContext context) {
//    return new MaterialApp(
//      debugShowCheckedModeBanner: false, home: new Scaffold(
//      appBar: new AppBar(
//        title: const Text('Multiple Images Example'),), body: Column(
//      children: <Widget>[
//    Row(
//    mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
//      Text('Select the multiple images '),
//      RaisedButton(
//        child: Text("Click", style: TextStyle(
//            color: Colors.white),), color: Colors.blue, onPressed: loadAssets,),
//      //                Icon(Icons.camera_alt,color: Colors.blue,)              ],            ),
//      Center(
//        child: Container(
//          padding: EdgeInsets.all(10.0),
//          child: Text('Error: $_error', style: TextStyle(
//              fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),),
//          decoration: BoxDecoration(
//              borderRadius: BorderRadius.all(Radius.circular(5.0)),
//              border: Border.all(color: Color(0x0FF000000))
//
//          ),),),
//      Expanded(
//        child: buildGridView(),)
//    ],),),);
//  }
//}
//
//class ViewImages extends StatefulWidget {
//  final int _index;
//  final Asset _asset;
//
//  ViewImages(this._index, this._asset, {
//    Key key,}) : super(key: key);
//
//  @override State<StatefulWidget> createState() =>
//      AssetState(this._index, this._asset);
//}
//
//class AssetState extends State<ViewImages> {
//  int _index = 0;
//  Asset _asset;
//
//  AssetState(this._index, this._asset);
//
//  @override void initState() {
//    super.initState();
//    _loadImage();
//  }
//
//  void _loadImage() async {
//    await this._asset.requestThumbnail(300, 300, quality: 50);
//    if (this.mounted) {
//      setState(() {});
//    }
//  }
//
//  @override Widget build(BuildContext context) {
//    if (null != this._asset.thumbData) {
//      return Image.memory(
//        this._asset.thumbData.buffer.asUint8List(), fit: BoxFit.cover,
//        gaplessPlayback: true,);
//    }
//
//    return Text(
//      '${this._index}', style: Theme
//        .of(context)
//        .textTheme
//        .headline,);
//  }
//}
