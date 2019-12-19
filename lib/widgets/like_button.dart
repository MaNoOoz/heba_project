//import 'package:flutter/material.dart';
//import 'package:heba_project/scopedmodels/like_button_model.dart';
//import 'package:heba_project/ui/Views/BaseView.dart';
//
//class LikeButton extends StatelessWidget {
//  final int postId;
//
//  LikeButton({
//    @required this.postId,
//  });
//
//  @override
//  Widget build(BuildContext context) {
//    return BaseView<LikeButtonModel>(
//        builder: (context, model, child) => Row(
//              children: <Widget>[
//                Text('Likes ${model.postLikes(postId)}'),
//                MaterialButton(
//                  color: Colors.white,
//                  child: Icon(Icons.thumb_up),
//                  onPressed: () {
//                    model.increaseLikes(postId);
//                  },
//                )
//              ],
//            ));
//  }
//}
