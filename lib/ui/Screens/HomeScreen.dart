import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/models/user_data.dart';
import 'package:heba_project/ui/Screens/profile_screen.dart';
import 'package:heba_project/ui/Screens/search_screen.dart';
import 'package:provider/provider.dart';

import 'FeedScreen.dart';
import 'activity_screen.dart';
import 'create_post_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = Provider
        .of<UserData>(context)
        .currentUserId;
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedScreen(currentUserId: currentUserId),
          SearchScreen(),
          CreatePostScreen(),
          ActivityScreen(),
          ProfileScreen(
            currentUserId: currentUserId,
            userId: currentUserId,
          ),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentTab,
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        activeColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home, color: Colors.blue[800], size: 42.0,),

            icon: Icon(
              Icons.home,
              size: 32.0,
//              color: Colors.green,

            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.search, color: Colors.blue[800], size: 42.0,),

            icon: Icon(
              Icons.search,
              size: 32.0,
//              color: Colors.amber,

            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.add_circle, color: Colors.blue[800], size: 42.0,),
            icon: Icon(
              Icons.add_circle,
              size: 32.0,
//              color: Colors.blue,

            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.notifications, color: Colors.blue[800], size: 42.0,),

            icon: Icon(
              Icons.notifications,
              size: 32.0,
//              color: Colors.blue,

            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.account_circle, color: Colors.blue[800], size: 42.0,),

            icon: Icon(
              Icons.account_circle,
              size: 32.0,
//              color: Colors.deepOrangeAccent,

            ),
          ),
        ],
      ),
    );
  }
//
//  @override
//  Widget build(BuildContext context) {
//    return BaseView<HomeModel>(
//      onModelReady: (model) => model.getPosts(Provider.of<User>(context).id),
//      builder: (context, model, child) => Scaffold(
//          backgroundColor: backgroundColor,
//          body: model.state == ViewState.Busy
//              ? Center(child: CircularProgressIndicator())
//              : Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              UIHelper.verticalSpaceLarge(),
//              Padding(
//                padding: const EdgeInsets.only(left: 20.0),
//                child: Text(
//                  'Welcome ${Provider.of<User>(context).name}',
//                  style: headerStyle,
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(left: 20.0),
//                child: Text('Here are all your posts',
//                    style: subHeaderStyle),
//              ),
//              UIHelper.verticalSpaceSmall(),
//              Expanded(child: getPostsUi(model.posts)),
//            ],
//          )),
//    );
//  }
//
//  Widget getPostsUi(List<Post> posts) => ListView.builder(
//      itemCount: posts.length,
//      itemBuilder: (context, index) => PostListItem(
//        post: posts[index],
//        onTap: () {
//          Navigator.pushNamed(context, 'post', arguments: posts[index]);
//        },
//      ));
}
