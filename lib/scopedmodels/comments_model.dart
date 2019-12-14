
import 'package:heba_project/models/comment.dart';
import 'package:heba_project/service/ViewState.dart';
import 'package:heba_project/service/api.dart';
import 'package:heba_project/service/service_loceter.dart';

import 'BaseModel.dart';


class CommentsModel extends BaseModel {
  Api _api = locator<Api>();

  List<Comment> comments;

  Future fetchComments(int postId) async {
    setState(ViewState.Busy);
    comments = await _api.getCommentsForPost(postId);
    setState(ViewState.Idle);
  }
}
