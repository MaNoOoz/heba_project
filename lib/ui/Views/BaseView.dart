/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

//import 'package:flutter/material.dart';
//import 'package:heba_project/scopedmodels/BaseModel.dart';
//import 'package:heba_project/service/service_loceter.dart';
//import 'package:provider/provider.dart';
//
//
//class BaseView<T extends BaseModel> extends StatefulWidget {
//  final Widget Function(BuildContext context, T model, Widget child) builder;
//  final Function(T) onModelReady;
//
//  BaseView({this.builder, this.onModelReady});
//
//  @override
//  _BaseViewState<T> createState() => _BaseViewState<T>();
//}
//
//class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
//  T model = locator<T>();
//
//  @override
//  void initState() {
//    if (widget.onModelReady != null) {
//      widget.onModelReady(model);
//    }
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return ChangeNotifierProvider<T>(
//        create: (context) => model,
//        child: Consumer<T>(builder: widget.builder));
//  }
//}