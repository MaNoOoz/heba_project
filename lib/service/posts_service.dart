import 'package:heba_project/models/post.dart';
import 'package:heba_project/service/service_loceter.dart';

import 'api.dart';

class PostsService {
  Api _api = locator<Api>();

  List<Post> _posts;
  List<Post> get posts => _posts;

  Future getPostsForUser(int userId) async {
    _posts = await _api.getPostsForUser(userId);
  }

  void incrementLikes(int postId){
    _posts.firstWhere((post) => post.id == postId).likes++;
  }
} 
