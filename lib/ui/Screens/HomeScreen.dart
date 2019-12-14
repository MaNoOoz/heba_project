import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/models/post.dart';
import 'package:heba_project/models/user.dart';
import 'package:heba_project/scopedmodels/HomeModel.dart';
import 'package:heba_project/service/ViewState.dart';
import 'package:heba_project/ui/Views/BaseView.dart';
import 'package:heba_project/ui/shared/app_colors.dart';
import 'package:heba_project/ui/shared/text_styles.dart';
import 'package:heba_project/ui/shared/ui_helpers.dart';
import 'package:heba_project/widgets/postlist_item.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      onModelReady: (model) => model.getPosts(Provider.of<User>(context).id),
      builder: (context, model, child) => Scaffold(
          backgroundColor: backgroundColor,
          body: model.state == ViewState.Busy
              ? Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UIHelper.verticalSpaceLarge(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Welcome ${Provider.of<User>(context).name}',
                  style: headerStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text('Here are all your posts',
                    style: subHeaderStyle),
              ),
              UIHelper.verticalSpaceSmall(),
              Expanded(child: getPostsUi(model.posts)),
            ],
          )),
    );
  }

  Widget getPostsUi(List<Post> posts) => ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) => PostListItem(
        post: posts[index],
        onTap: () {
          Navigator.pushNamed(context, 'post', arguments: posts[index]);
        },
      ));
}
