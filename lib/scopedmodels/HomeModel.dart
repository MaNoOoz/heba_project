//import 'package:heba_project/models/post.dart';
//import 'package:heba_project/service/FirestoreServiceAuth.dart';
//import 'package:heba_project/service/ViewState.dart';
//import 'package:heba_project/service/posts_service.dart';
//import 'package:heba_project/service/service_loceter.dart';
//
//import 'BaseModel.dart';
//
//class HomeModel extends BaseModel {
//  PostsService _postsService = locator<PostsService>();
//
//  List<Post> get posts => _postsService.posts;
//
//  Future getPosts(int userId) async {
//    setState(ViewState.Busy);
//    await _postsService.getPostsForUser(userId);
//    setState(ViewState.Idle);
//  }
//
//}
