/*
 * Copyright (c) 2020.  Made With Love By Yaman Al-khateeb
 */
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:heba_project/models/models.dart';
import 'package:location/location.dart';

class LocationService {
  static UserLocation _currentLocation;
  Location location = Location();
  Position currentPosition = Position();
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();
  StreamController<Position> _locationControllerForPosition =
      StreamController<Position>();

  /// as A Stream  to use it with provider
  Stream<UserLocation> get locationStream => _locationController.stream;

  Stream<Position> get locationStream2 => _locationControllerForPosition.stream;

  /// Using my Model
  LocationService() {
    // Request permission to use location
    location.requestPermission().then((granted) {
      if (granted != null) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged().listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation.fromFeilds(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
              address: "LocationfromStream",
            ));
          }
        });
      }
    });
  }

  /// Using Glocetor
  fromGlocetor() async {
    Position currentPosition = await Geolocator().getCurrentPosition();

    // Request permission to use location
    location.requestPermission().then((granted) {
      if (granted != null) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged().listen((locationData) {
          if (locationData != null) {
            _locationControllerForPosition.add(currentPosition);
          }
        });
      }
    });
  }

  /// or as A Future
  Future<UserLocation> getLocation() async {
    try {
      var mlocation = await location.getLocation();
      _currentLocation = UserLocation.fromFeilds(
        latitude: mlocation.latitude,
        longitude: mlocation.longitude,
        address: "LocationfromFuture",
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }

  Future<Position> getPosition() async {
    try {
      currentPosition = await Geolocator().getCurrentPosition();
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return currentPosition;
  }
}
