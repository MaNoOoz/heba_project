//import 'package:get_it/get_it.dart';
//import 'package:heba_project/scopedmodels/HomeModel.dart';
//import 'package:heba_project/scopedmodels/LoginModel.dart';
//import 'package:heba_project/scopedmodels/RegisterModel.dart';
//import 'package:heba_project/scopedmodels/like_button_model.dart';
//import 'FirestoreServiceAuth.dart';
//import 'FirestoreServiceDatabase.dart';
//import 'api.dart';
//
//GetIt locator = GetIt.instance;
//
//void setupLocator() {
//  // Register services
//  locator.registerLazySingleton<AuthService>(() => AuthService());
//  locator.registerLazySingleton<FirestoreServiceDatabase>(() => FirestoreServiceDatabase());
//  locator.registerLazySingleton(() => Api());
//  // Register models
//  locator.registerFactory<HomeModel>(() => HomeModel());
//  locator.registerFactory<LoginModel>(() => LoginModel());
//  locator.registerFactory<RegisterModel>(() => RegisterModel());
//  locator.registerFactory(() => LikeButtonModel());
//}
//
