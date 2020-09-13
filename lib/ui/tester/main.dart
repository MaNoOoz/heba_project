import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heba_project/ui/Screens/locationsMap.dart';

void main() {
  runApp(new MyApp());
}

const initialPosition = LatLng(37.7786, -122.4375);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot> _iceCreamStores;
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _iceCreamStores =
        Firestore.instance.collection('locations').orderBy('name').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
          stream: _iceCreamStores,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text("Error ");
              }
            }
            return Stack(
              children: [
                locationsMap(
                  documents: snapshot.data.documents,
                  initialPosition: initialPosition,
                  mapController: _mapController,
                ),
                FloatingActionButton(
                  onPressed: () {},
                ),
//                  StoreCarousel(
//                    mapController: _mapController,
//                    documents: snapshot.data.documents,
//                  ),
              ],
            );
          }),
    );
  }
}

//Future<Post> createPost(Post post) async{
//  final response = await http.post('$url',
//      headers: {
//        HttpHeaders.contentTypeHeader: 'application/json'
//      },
//      body: postToJson(post)
//  );
//
//  return postFromJson(response.body);
//}
