import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/ui/Views/post_view.dart';
import 'package:heba_project/ui/shared/MyClipper.dart';
import 'package:heba_project/ui/shared/constants.dart';
import 'package:heba_project/ui/shared/mAppbar.dart';
import 'package:heba_project/ui/widgets/mWidgets.dart';

import 'edit_profile_screen.dart';

/// =================================================

/// =================================================
class ProfileScreen extends StatefulWidget {
  static String id = "profile_screen";
  final String currentUserId;
  final String userId;

  ProfileScreen({this.currentUserId, this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Post2> _posts = [];
  int _displayPosts = 0; // 0 - grid, 1 - column
  User _profileUser;

  @override
  void initState() {
    super.initState();
    _setupPosts();
    _setupProfileUser();
  }

  _setupPosts() async {
    List<Post2> posts = await DatabaseService.getUserPosts(widget.userId);
    setState(() {
      _posts = posts;
    });
  }

  _setupProfileUser() async {
//    profileUser.id == Provider.of<UserData>(context).currentUserId;

    User profileUser = await DatabaseService.getUserWithId(widget.userId);
    print("current profileUser id :  ${profileUser.id}");
    print("current profileUser email :  ${profileUser.email}");
    print("current profileUser name :  ${profileUser.name}");
    setState(() {
      _profileUser = profileUser;
    });
  }

  /// getImagesUrls
  List<dynamic> _getListOfImagesFromUser(Post2 post2) {
    dynamic list = post2.imageUrls;
    return list;
  }

  Widget _buildProfileInfo(User user) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(top: 4),
        decoration: BoxDecoration(color: Colors.blueAccent, boxShadow: [
          BoxShadow(color: Colors.blue, blurRadius: 20, offset: Offset(0, 0))
        ]),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                /// image
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: user.profileImageUrl.isEmpty
                                  ? Image.asset("assets/images/building.gif")
                                  : CachedNetworkImageProvider(
                                  user.profileImageUrl),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      user.name,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "هبات",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontFamily: ArabicFonts.Cairo,
                      ),
                    ),
                    Text(
                      "${_posts.length}",
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    )
                  ],
                ),
                SizedBox(width: 1), // give it width
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditProfileScreen(
                                user: user,
                              ),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Transform.rotate(
                      angle: (pi * 0.00),
                      child: Container(
                        width: 110,
                        height: 32,
                        child: Center(
                          child: Text("Edit Profile"),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 20)
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            _buildToggleButtons(),
          ],
        ),
      ),
    );
  }

  _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          iconSize: 30.0,
          color: _displayPosts == 0 ? Colors.white : Colors.grey[400],
          onPressed: () => setState(() {
            _displayPosts = 0;
          }),
        ),
        IconButton(
          icon: Icon(Icons.list),
          iconSize: 30.0,
          color: _displayPosts == 1 ? Colors.white : Colors.grey[400],
          onPressed: () => setState(() {
            _displayPosts = 1;
          }),
        ),
      ],
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///
  Widget _gridView(Post2 post) {
    /// fetch the list
    var listFromFirebase =
    _getListOfImagesFromUser(post).cast<String>().toList();
//    var listFromFirebase = _getListOfImagesFromUser(post);
    int _current = 0;

    return GridTile(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: listFromFirebase.isEmpty
                ? Center(child: Text("No Image Bro"))
                : ImagesSlider(
              items: map<Widget>(listFromFirebase, (index, i) {
                print("listFromFirebase ${listFromFirebase.length}");
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: post.imageUrls.isEmpty
                            ? Image.asset(
                            'assets/images/user_placeholder.jpg')
                            : NetworkImage(i),
                        fit: BoxFit.cover),
                  ),
                );
              }),
              autoPlay: false,
              viewportFraction: 1.0,
              aspectRatio: 2.0,
              distortion: false,
              align: IndicatorAlign.bottom,
              indicatorWidth: 5,
              updateCallback: (index) {
                setState(
                      () {
                    _current = index;
                  },
                );
              },
            ),
          ),

//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Card(
//              child: ListView(
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text(post.hName),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text(post.hLocation),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text(post.hDesc),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: CachedNetworkImage(
//                      imageUrl: post.imageUrls[0],
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          )
        ],
      ),
    );
  }

//  _buildDisplayPosts() {
//    if (_displayPosts == 0) {
//      // Grid
//      List<GridTile> tiles = [];
//      _posts.forEach(
//        (post) => tiles.add(_gridView(post)),
//      );
//      return GridView.count(
//        crossAxisCount: 3,
//        childAspectRatio: 1.0,
//        mainAxisSpacing: 2.0,
//        crossAxisSpacing: 2.0,
//        shrinkWrap: true,
//        physics: NeverScrollableScrollPhysics(),
//        children: tiles,
//      );
//    } else {
//      // Column
//      List<PostView> postViews = [];
//      _posts.forEach((post) {
//        postViews.add(
//          PostView(
//            currentUserId: widget.currentUserId,
//            post: post,
//            author: _profileUser,
//          ),
//        );
//      });
//      return Column(children: postViews);
//    }
//  }

  _buildDisplayPosts2() {
    if (_displayPosts == 0) {
      // Grid
      List<GridTile> tiles = [];
      _posts.forEach(
            (post) => tiles.add(_gridView(post)),
      );
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      // Column
      List<PostView> postViews = [];
      _posts.forEach((post) {
        postViews.add(
          PostView(
            currentUserId: widget.currentUserId,
            post: post,
            author: _profileUser,
          ),
        );
      });
      return Column(children: postViews);
    }
  }

  Widget mBody() {
    return FutureBuilder(
      future: usersRef.document(widget.currentUserId).get(),
      builder: (BuildContext context, AsyncSnapshot map) {
        if (!map.hasData) {
          print("map : ${usersRef.getDocuments().then((QuerySnapshot map) {
            map.documents.forEach((f) => print('${f.exists}}'));
          })}");
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                mStatlessWidgets().mLoading(),
              ],
            ),
          );
        } else if (map.hasError) {
          print('u have error in future');
        }
        User user = User.fromDoc(map.data);
        return ListView(
          children: <Widget>[
            _buildProfileInfo(user),
//              _buildImageSlider(post);
//              _buildToggleButtons(),
            Divider(),
            _posts.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Image.asset("assets/images/building.gif"),
              ),
            )
                : _buildDisplayPosts2(),
//              Text("${_posts.length}"),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Heba",
        IsBack: false,
        color: Colors.white,
        isImageVisble: true,
      ),
      body: mBody(),
    );
  }
}

//class _ProfileScreenStateOld extends State<ProfileScreen> {
//  bool _isFollowing = false;
//  int _followerCount = 0;
//  int _followingCount = 0;
//  List<Post> _posts = [];
//  int _displayPosts = 0; // 0 - grid, 1 - column
//  User _profileUser;
//
//  @override
//  void initState() {
//    super.initState();
//    _setupIsFollowing();
//    _setupFollowers();
//    _setupFollowing();
//    _setupPosts();
//    _setupProfileUser();
//  }
//
//  _setupIsFollowing() async {
//    bool isFollowingUser = await DatabaseService.isFollowingUser(
//      currentUserId: widget.currentUserId,
//      userId: widget.userId,
//    );
//    setState(() {
//      _isFollowing = isFollowingUser;
//    });
//  }
//
//  _setupFollowers() async {
//    int userFollowerCount = await DatabaseService.numFollowers(widget.userId);
//    setState(() {
//      _followerCount = userFollowerCount;
//    });
//  }
//
//  _setupFollowing() async {
//    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
//    setState(() {
//      _followingCount = userFollowingCount;
//    });
//  }
//
//  _setupPosts() async {
//    List<Post> posts = await DatabaseService.getUserPosts(widget.userId);
//    setState(() {
//      _posts = posts;
//    });
//  }
//
//  _setupProfileUser() async {
//    User profileUser = await DatabaseService.getUserWithId(widget.userId);
//    setState(() {
//      _profileUser = profileUser;
//    });
//  }
//
//  _followOrUnfollow() {
//    if (_isFollowing) {
//      _unfollowUser();
//    } else {
//      _followUser();
//    }
//  }
//
//  _unfollowUser() {
//    DatabaseService.unfollowUser(
//      currentUserId: widget.currentUserId,
//      userId: widget.userId,
//    );
//    setState(() {
//      _isFollowing = false;
//      _followerCount--;
//    });
//  }
//
//  _followUser() {
//    DatabaseService.followUser(
//      currentUserId: widget.currentUserId,
//      userId: widget.userId,
//    );
//    setState(() {
//      _isFollowing = true;
//      _followerCount++;
//    });
//  }
//
//  _displayButton(User user) {
//    return user.id == Provider.of<UserData>(context).currentUserId
//        ? Container(
//      width: 200.0,
//      child: FlatButton(
//        onPressed: () => Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (_) => EditProfileScreen(
//              user: user,
//            ),
//          ),
//        ),
//        color: Colors.blue,
//        textColor: Colors.white,
//        child: Text(
//          'Edit Profile',
//          style: TextStyle(fontSize: 18.0),
//        ),
//      ),
//    )
//        : Container(
//      width: 200.0,
//      child: FlatButton(
//        onPressed: _followOrUnfollow,
//        color: _isFollowing ? Colors.grey[200] : Colors.blue,
//        textColor: _isFollowing ? Colors.black : Colors.white,
//        child: Text(
//          _isFollowing ? 'Unfollow' : 'Follow',
//          style: TextStyle(fontSize: 18.0),
//        ),
//      ),
//    );
//  }
//
//  _buildProfileInfo(User user) {
//    return Column(
//      children: <Widget>[
//        Padding(
//          padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
//          child: Row(
//            children: <Widget>[
//              CircleAvatar(
//                radius: 50.0,
//                backgroundColor: Colors.grey,
//                backgroundImage: user.profileImageUrl.isEmpty
//                    ? AssetImage('assets/images/user_placeholder.jpg')
//                    : CachedNetworkImageProvider(user.profileImageUrl),
//              ),
//              Expanded(
//                child: Column(
//                  children: <Widget>[
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: <Widget>[
//                        Column(
//                          children: <Widget>[
//                            Text(
//                              _posts.length.toString(),
//                              style: TextStyle(
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.w600,
//                              ),
//                            ),
//                            Text(
//                              'posts',
//                              style: TextStyle(color: Colors.black54),
//                            ),
//                          ],
//                        ),
//                        Column(
//                          children: <Widget>[
//                            Text(
//                              _followerCount.toString(),
//                              style: TextStyle(
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.w600,
//                              ),
//                            ),
//                            Text(
//                              'followers',
//                              style: TextStyle(color: Colors.black54),
//                            ),
//                          ],
//                        ),
//                        Column(
//                          children: <Widget>[
//                            Text(
//                              _followingCount.toString(),
//                              style: TextStyle(
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.w600,
//                              ),
//                            ),
//                            Text(
//                              'following',
//                              style: TextStyle(color: Colors.black54),
//                            ),
//                          ],
//                        ),
//                      ],
//                    ),
//                    _displayButton(user),
//                  ],
//                ),
//              )
//            ],
//          ),
//        ),
//        Padding(
//          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Text(
//                user.name,
//                style: TextStyle(
//                  fontSize: 18.0,
//                  fontWeight: FontWeight.bold,
//                ),
//              ),
//              SizedBox(height: 5.0),
//              Container(
//                height: 80.0,
//                child: Text(
//                  user.bio,
//                  style: TextStyle(fontSize: 15.0),
//                ),
//              ),
//              Divider(),
//            ],
//          ),
//        ),
//      ],
//    );
//  }
//
//  _buildToggleButtons() {
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//      children: <Widget>[
//        IconButton(
//          icon: Icon(Icons.grid_on),
//          iconSize: 30.0,
//          color: _displayPosts == 0
//              ? Theme.of(context).primaryColor
//              : Colors.grey[300],
//          onPressed: () => setState(() {
//            _displayPosts = 0;
//          }),
//        ),
//        IconButton(
//          icon: Icon(Icons.list),
//          iconSize: 30.0,
//          color: _displayPosts == 1
//              ? Theme.of(context).primaryColor
//              : Colors.grey[300],
//          onPressed: () => setState(() {
//            _displayPosts = 1;
//          }),
//        ),
//      ],
//    );
//  }
//
//  _buildTilePost(Post post) {
//    return GridTile(
//      child: Image(
//        image: CachedNetworkImageProvider(post.imageUrl),
//        fit: BoxFit.cover,
//      ),
//    );
//  }
//
//  _buildDisplayPosts() {
//    if (_displayPosts == 0) {
//      // Grid
//      List<GridTile> tiles = [];
//      _posts.forEach(
//            (post) => tiles.add(_buildTilePost(post)),
//      );
//      return GridView.count(
//        crossAxisCount: 3,
//        childAspectRatio: 1.0,
//        mainAxisSpacing: 2.0,
//        crossAxisSpacing: 2.0,
//        shrinkWrap: true,
//        physics: NeverScrollableScrollPhysics(),
//        children: tiles,
//      );
//    } else {
//      // Column
//      List<PostView> postViews = [];
//      _posts.forEach((post) {
//        postViews.add(
//          PostView(
//            currentUserId: widget.currentUserId,
//            post: post,
//            author: _profileUser,
//          ),
//        );
//      });
//      return Column(children: postViews);
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.white,
//      appBar: AppBar(
//        backgroundColor: Colors.white,
//        title: Text(
//          'Instagram',
//          style: TextStyle(
//            color: Colors.black,
//            fontFamily: 'Billabong',
//            fontSize: 35.0,
//          ),
//        ),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.exit_to_app),
//            onPressed: AuthService.logout,
//          ),
//        ],
//      ),
//      body: FutureBuilder(
//        future: usersRef.document(widget.userId).get(),
//        builder: (BuildContext context, AsyncSnapshot map) {
//          if (!map.hasData) {
//            return Center(
//              child: CircularProgressIndicator(),
//            );
//          }
//          User user = User.fromDoc(map.data);
//          return ListView(
//            children: <Widget>[
//              _buildProfileInfo(user),
//              _buildToggleButtons(),
//              Divider(),
//              _buildDisplayPosts(),
//            ],
//          );
//        },
//      ),
//    );
//  }
//}
//Widget _gridView2(Post2 post) {
//  /// fetch the list
////    var listFromFirebase = _getListOfImagesFromUser(post).cast<String>().toList();
//  var listFromFirebase = _getListOfImagesFromUser(post);
//  int _current = 0;
//
//  return GridTile(
//    child: listFromFirebase.isEmpty
//        ? Center(child: CircularProgressIndicator())
//        : Container(
//      padding: const EdgeInsets.all(10.0),
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.all(Radius.circular(30.0)),
//        //color: Colors.black
//      ),
//      height: MediaQuery.of(context).size.height / 5,
//      width: MediaQuery.of(context).size.height / 2,
//      child: CarouselSlider(
//        height: 400.0,
//        items: listFromFirebase.map((i) {
//          return Builder(
//            builder: (BuildContext context) {
//              return Container(
//                  width: MediaQuery.of(context).size.width,
//                  margin: EdgeInsets.symmetric(horizontal: 5.0),
//                  decoration: BoxDecoration(color: Colors.amber),
//                  child: Text(
//                    'text $i',
//                    style: TextStyle(fontSize: 16.0),
//                  ));
//            },
//          );
//        }).toList(),
//      ),
//    ),
//  );
//} // refrence another librari to display slider images
