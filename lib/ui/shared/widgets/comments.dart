/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

//
//import 'package:flutter/material.dart';
//import 'package:heba_project/models/comment.dart';
//import 'package:heba_project/scopedmodels/comments_model.dart';
//import 'package:heba_project/service/ViewState.dart';
//import 'package:heba_project/ui/Views/BaseView.dart';
//import 'package:heba_project/ui/shared/app_colors.dart';
//import 'package:heba_project/ui/shared/UI_Helpers.dart';
//
//class Comments extends StatelessWidget {
//  final int postId;
//  Comments(this.postId);
//
//  @override
//  Widget build(BuildContext context) {
//    return BaseView<CommentsModel>(
//      onModelReady: (model) => model.fetchComments(postId),
//      builder: (context, model, child) => model.state == ViewState.Busy
//      ? Center(child: CircularProgressIndicator())
//      : Expanded(child: ListView(
//        children: model.comments
//                  .map((comment) => CommentItem(comment)).toList(),
//      ),)
//    );
//  }
//}
//
///// Renders a single comment given a comment model
//class CommentItem extends StatelessWidget {
//  final Comment comment;
//  const CommentItem(this.comment);
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      padding: EdgeInsets.all(10.0),
//      margin: EdgeInsets.symmetric(vertical: 10.0),
//      decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(10.0), color: commentColor),
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Text(
//            comment.name,
//            style: TextStyle(fontWeight: FontWeight.bold),
//          ),
//          UIHelper.verticalSpaceSmall(),
//          Text(comment.body),
//        ],
//      ),
//    );
//  }
//}
