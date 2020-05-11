/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

//import 'package:heba_project/service/FirestoreServiceAuth.dart';
//import 'package:heba_project/service/ViewState.dart';
//import 'package:heba_project/service/service_loceter.dart';
//
//import 'BaseModel.dart';
//
//class LoginModel extends BaseModel {
//
//  final AuthService _authenticationService = locator<AuthService>();
//  String errorMessage;
//
//  Future<bool> login(String userIdText) async {
//    setState(ViewState.Busy);
//
//    var userId = int.tryParse(userIdText);
//
//    // Not a number
//    if (userId == null) {
//      errorMessage = 'Value entered is not a number';
//      setState(ViewState.Idle);
//      return false;
//    }
//
//    var success = await _authenticationService.login(userId);
//
//    // Handle potential error here too.
//
//    setState(ViewState.Idle);
//    return success;
//  }
//}