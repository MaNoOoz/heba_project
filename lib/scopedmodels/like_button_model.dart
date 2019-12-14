import 'package:heba_project/service/posts_service.dart';
import 'package:heba_project/service/service_loceter.dart';

import 'BaseModel.dart';

class LikeButtonModel extends BaseModel {
  PostsService _postsService = locator<PostsService>();

  int postLikes(int postId) {
    return _postsService.posts
        .firstWhere((post) => post.id == postId)
        .likes;
  }

  void increaseLikes(int postId) {
    _postsService.incrementLikes(postId);
    notifyListeners();
  }
}
