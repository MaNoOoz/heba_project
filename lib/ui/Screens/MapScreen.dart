/*
 * Copyright (c) 2020.  Made With Love By Yaman Al-khateeb
 */

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heba_project/service/LocationService.dart';
import 'package:heba_project/ui/shared/Assets.dart';
import 'package:location/location.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light,
    fontFamily: "",
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white30));
final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  primaryColor: Colors.orangeAccent[400],
);

class MapScreen extends StatefulWidget {
  static final String id = "MapScreen";

  MapScreen({BuildContext context});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  /// Map ====================================================
  SolidController _controller = SolidController();
  GoogleMapController mapController;
  LatLng _center = LatLng(24.72, 46.7);
  Set<Marker> _markers = Set<Marker>();
  Location location = Location();
  BitmapDescriptor ico;
  bool _showMapStyle = false;

  /// todo Create Map View Mode For Diffrent Queries : 1- general view all hebat 2- Area View  hebat for areas  3-

  @override
  void initState() {
    super.initState();
    setMarckerIcon();
  }

  /// Marker Icon From Assets
  setMarckerIcon() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), AvailableImages.bubble)
        .then((d) {
      ico = d;
    });
  }

  /// MARKER FROM Assets
  Future<BitmapDescriptor> _getAssetIcon(BuildContext context) async {
    final Completer<BitmapDescriptor> bitmapIcon =
        Completer<BitmapDescriptor>();
    final ImageConfiguration config = createLocalImageConfiguration(context);

    const AssetImage(AvailableImages.shape)
        .resolve(config)
        .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
      final ByteData bytes =
          await image.image.toByteData(format: ImageByteFormat.png);
      final BitmapDescriptor bitmap =
          BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    }));

    return await bitmapIcon.future;
  }

  @override
  build(BuildContext context) {
    var w = MediaQuery.of(context).size.width * 0.1;
    var h = MediaQuery.of(context).size.height * 0.2;

    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: GoogleMap(
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              mapType: MapType.normal,
              myLocationButtonEnabled: false,

              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                  target: LatLng(25.181829, 46.6065447), zoom: 10),
              //                    markers: _markers.values.toSet(),
              markers: _markers,
            ),
          ),
          Align(
              alignment: AlignmentDirectional.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: CustomBarWidget(),
              )),
          Container(
            //            color: Colors.orange.withOpacity(0.4),
            width: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      mini: true,
                      heroTag: "41",
                      backgroundColor: Colors.white70,
                      onPressed: () {
                        setState(() {
                          _showMapStyle = !_showMapStyle;
                        });

                        _toggleMapStyle();
                      },
                      child: Icon(
                        Icons.favorite,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      mini: true,
                      heroTag: "44",
                      backgroundColor: Colors.white70,
                      onPressed: () async {
                        var pos = await LocationService().getLocation();
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                                zoom: 10,
                                target: LatLng(pos.longitude, pos.longitude)),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.location_on,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      mini: true,
                      heroTag: "51",
                      backgroundColor: Colors.white70,
                      onPressed: () async {
                        var a = 23.8337681;
                        var b = 54.1097969;
                        var rndPostion = Random();

                        for (var i = 0; i < 100; i++) {
//                            print(rndPostion.nextDouble() + rndPostion.nextInt(50));
//                            var r = rndPostion.nextInt(50).toDouble() + rndPostion.nextInt(50).toDouble();
//                            print(r);
//                            var r = a = rndPostion.nextInt(b.toInt() - a.toInt()).toDouble();
                          var lat =
                              doubleInRange(rndPostion, a.toInt(), b.toInt());
                          var long =
                              doubleInRange(rndPostion, a.toInt(), b.toInt());
                          print(" LAT :$lat ");
                          print(" LONG :$long ");

                          await addNewMarker(
                              position: LatLng(lat, long), address: "HEY ");
                        }
                      },
                      child: Icon(
                        Icons.dehaze,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ), //
              ],
            ),
          ),
        ],
      ),
    );
  }

//  @override
//  build(BuildContext context) {
//    var w = MediaQuery.of(context).size.width * 0.1;
//    var h = MediaQuery.of(context).size.height * 0.2;
//
//    return MaterialApp(
//      theme: defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : kDefaultTheme,
//      home: Scaffold(
//        bottomSheet: SolidBottomSheet(
//          maxHeight: 120,
//          controller: _controller,
//          draggableBody: true,
//          headerBar: Container(
//            child: Padding(
//              padding: const EdgeInsets.all(10.0),
//              child: Column(
//                children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Column(
//                        children: <Widget>[
//                          Padding(
//                            padding: const EdgeInsets.all(0.0),
//                            child: FloatingActionButton(
//                              mini: true,
//                              elevation: 1,
//                              heroTag: "1",
//                              backgroundColor: Colors.white70,
//                              onPressed: () => print(''),
//                              child: Icon(
//                                Icons.more_horiz,
//                                color: Colors.black,
//                              ),
//                            ),
//                          ),
//                          Text('الخدمات'),
//                        ],
//                      ),
//                      Column(
//                        children: <Widget>[
//                          FloatingActionButton(
//                            elevation: 1,
//                            backgroundColor: Colors.white70,
//                            mini: true,
//                            heroTag: "btn2",
//                            onPressed: () {
//                              //                    getMarkers();
//                            },
//                            child: Icon(
//                              Icons.message,
//                              color: Colors.black,
//                            ),
//                          ),
//                          Text('محادثة'),
//                        ],
//                      ),
//                      Column(
//                        children: <Widget>[
//                          FloatingActionButton(
//                            mini: true,
//                            elevation: 1,
//                            backgroundColor: Colors.green,
//                            heroTag: "btn3",
//                            onPressed: () {
//                              //                    getMarkers();
//                            },
//                            child: Icon(
//                              Icons.add,
//                              size: 40,
//                            ),
//                          ),
//                          Text('إعلان جديد'),
//                        ],
//                      ),
//                      Column(
//                        children: <Widget>[
//                          FloatingActionButton(
//                            mini: true,
//                            elevation: 1,
//                            backgroundColor: Colors.white70,
//                            heroTag: "btn4",
//                            onPressed: () {
//                              //                    getMarkers();
//                            },
//                            child: Icon(
//                              Icons.map,
//                              color: Colors.black,
//                            ),
//                          ),
//                          Text('المناطق'),
//                        ],
//                      ),
//                      Column(
//                        children: <Widget>[
//                          FloatingActionButton(
//                            elevation: 1,
//                            backgroundColor: Colors.white70,
//                            mini: true,
//                            heroTag: "btn5",
//                            onPressed: () {
//                              //                    getMarkers();
//                            },
//                            child: Icon(
//                              Icons.person,
//                              color: Colors.black,
//                            ),
//                          ),
//                          Text('إعلان جديد'),
//                        ],
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//          ),
//          body: Container(
//            child: Padding(
//              padding: const EdgeInsets.all(10.0),
//              child: Column(
//                children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Column(
//                        children: <Widget>[
//                          FloatingActionButton(
//                            backgroundColor: Colors.white70,
//                            mini: true,
//                            heroTag: "q",
//                            onPressed: () {
//                              //                    getMarkers();
//                            },
//                            child: Icon(Icons.notifications, color: Colors.black),
//                          ),
//                          Text('طلباتي'),
//                        ],
//                      ),
//                      Column(
//                        children: <Widget>[
//                          FloatingActionButton(
//                            mini: true,
//                            heroTag: "w",
//                            backgroundColor: Colors.white70,
//                            onPressed: () {
//                              //                    getMarkers();
//                            },
//                            child: Icon(FontAwesomeIcons.handshake, color: Colors.black),
//                          ),
//                          Text('حلول تسويقية'),
//                        ],
//                      ),
//                      Column(
//                        children: <Widget>[
//                          FloatingActionButton(
//                            mini: true,
//                            backgroundColor: Colors.white70,
//                            heroTag: "e",
//                            onPressed: () {
//                              //                    getMarkers();
//                            },
//                            child: Icon(FontAwesomeIcons.shoppingBag, color: Colors.black),
//                          ),
//                          Text('البناء والمقاولات'),
//                        ],
//                      ),
//                      Column(
//                        children: <Widget>[
//                          FloatingActionButton(
//                            mini: true,
//                            backgroundColor: Colors.white70,
//                            heroTag: "r",
//                            onPressed: () {
//                              //                    getMarkers();
//                            },
//                            child: Icon(FontAwesomeIcons.fileArchive, color: Colors.black),
//                          ),
//                          Text(' عقود  الأيجار'),
//                        ],
//                      ),
//                      Column(
//                        children: <Widget>[
//                          FloatingActionButton(
//                            mini: true,
//                            backgroundColor: Colors.white70,
//                            heroTag: "t",
//                            onPressed: () {
//                              //                    getMarkers();
//                            },
//                            child: Icon(FontAwesomeIcons.calculator, color: Colors.black),
//                          ),
//                          Text('حاسبه التمويل'),
//                        ],
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ),
//        drawer: Drawer(),
//        body: Stack(
//          children: <Widget>[
//            Container(
//              child: GoogleMap(
//                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
//                  new Factory<OneSequenceGestureRecognizer>(
//                    () => new EagerGestureRecognizer(),
//                  ),
//                ].toSet(),
//                onMapCreated: _onMapCreated,
//                myLocationEnabled: true,
//                mapType: MapType.normal,
//                myLocationButtonEnabled: false,
//
//                zoomGesturesEnabled: true,
//                initialCameraPosition: CameraPosition(target: LatLng(25.181829, 46.6065447), zoom: 10),
//                //                    markers: _markers.values.toSet(),
//                markers: _markers,
//              ),
//            ),
//            Align(
//                alignment: AlignmentDirectional.topCenter,
//                child: Padding(
//                  padding: const EdgeInsets.only(top: 20.0),
//                  child: CustomBarWidget(),
//                )),
//            Container(
//              //            color: Colors.orange.withOpacity(0.4),
//              width: 60,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.end,
//                children: <Widget>[
//                  Align(
//                    alignment: AlignmentDirectional.bottomStart,
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: FloatingActionButton(
//                        mini: true,
//                        heroTag: "41",
//                        backgroundColor: Colors.white70,
//                        onPressed: () {
//                          setState(() {
//                            _showMapStyle = !_showMapStyle;
//                          });
//
//                          _toggleMapStyle();
//                        },
//                        child: Icon(
//                          Icons.favorite,
//                          color: Colors.black45,
//                        ),
//                      ),
//                    ),
//                  ),
//                  Align(
//                    alignment: AlignmentDirectional.bottomStart,
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: FloatingActionButton(
//                        mini: true,
//                        heroTag: "44",
//                        backgroundColor: Colors.white70,
//                        onPressed: () async {
//                          var pos = await LocationService().getLocation();
//                          mapController.animateCamera(
//                            CameraUpdate.newCameraPosition(
//                              CameraPosition(zoom: 10, target: LatLng(pos.longitude, pos.longitude)),
//                            ),
//                          );
//                        },
//                        child: Icon(
//                          Icons.location_on,
//                          color: Colors.black45,
//                        ),
//                      ),
//                    ),
//                  ),
//                  Align(
//                    alignment: AlignmentDirectional.bottomStart,
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: FloatingActionButton(
//                        mini: true,
//                        heroTag: "51",
//                        backgroundColor: Colors.white70,
//                        onPressed: () async {
//                          var a = 23.8337681;
//                          var b = 54.1097969;
//                          var rndPostion = Random();
//
//                          for (var i = 0; i < 100; i++) {
////                            print(rndPostion.nextDouble() + rndPostion.nextInt(50));
////                            var r = rndPostion.nextInt(50).toDouble() + rndPostion.nextInt(50).toDouble();
////                            print(r);
////                            var r = a = rndPostion.nextInt(b.toInt() - a.toInt()).toDouble();
//                            var lat = doubleInRange(rndPostion, a.toInt(), b.toInt());
//                            var long = doubleInRange(rndPostion, a.toInt(), b.toInt());
//                            print(" LAT :$lat ");
//                            print(" LONG :$long ");
//
//                            await addNewMarker(position: LatLng(lat, long), address: "HEY ");
//                          }
//                        },
//                        child: Icon(
//                          Icons.dehaze,
//                          color: Colors.black45,
//                        ),
//                      ),
//                    ),
//                  ), //
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  double doubleInRange(Random source, int start, int end) =>
      source.nextDouble() * (end - start) + start;

  /// Change map style
  void _toggleMapStyle() async {
    String style =
        await DefaultAssetBundle.of(context).loadString('assets/mapstyle.json');

    if (_showMapStyle) {
      mapController.setMapStyle(style);
    } else {
      mapController.setMapStyle(null);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void addNewMarker({LatLng position, String address}) async {
    var rndId = Random().nextInt(30);
    final MarkerId markerId = MarkerId('$rndId');
    BitmapDescriptor markericon = await _getAssetIcon(context);
    // creating a new MARKER
    var rndPrice = Random().nextInt(1000);

    final Marker marker = Marker(
        markerId: markerId,
        position: position,
        infoWindow: InfoWindow(title: "$rndPrice ألف ", snippet: address),
        icon: markericon);

    setState(() {
      _markers.add(marker);
    });
  }
}

class CustomBarWidget extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  //  https://stackoverflow.com/questions/53658208/custom-appbar-flutter
  static List<String> names = [
    'شقة للبيع',
    'فيلا للبيع',
    'بيت للبيع',
    'إستراحة للبيع',
    ' مزرعة للبيع',
    'شقة للإيجار',
    'فيلا للإيجار',
    'بيت للإيجار',
    'إستراحة للإيجار',
    ' مزرعة للإيجار',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 10.0,
            right: 0.0,
            child: Container(
              height: 40,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.5), width: 1.0),
                    color: Colors.white),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.lightGreen,
                  ),
                  onPressed: () {
                    print("your menu action here");
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            left: 0.0,
            right: 50.0,
            child: Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 1.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1.0),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.5), width: 1.0),
                    color: Colors.white),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                        children: names
                            .map<Widget>((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(e),
                                ))
                            .toList())),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
