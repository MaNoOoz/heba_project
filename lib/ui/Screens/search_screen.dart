/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/models/user_model.dart';
import 'package:heba_project/service/database_service.dart';
import 'package:heba_project/ui/Screens/profile_screen.dart';
import 'package:heba_project/ui/shared/mAppbar.dart';
import 'package:heba_project/ui/widgets/mWidgets.dart';

class SearchScreen extends StatefulWidget {
  final String currentUserId;

  SearchScreen({this.currentUserId});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  Future<QuerySnapshot> _users;

  //  todo 1- fix search function
  /// todo 2- fix profile ID not work after selected from search
  ///
  _buildUserTile(User user) {
    return ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundImage: user.profileImageUrl.isEmpty
              ? AssetImage('assets/images/uph.jpg')
              : CachedNetworkImageProvider(user.profileImageUrl),
        ),
        title: Text(user.name),
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(
                  currentUserId: widget.currentUserId,
                  userId: user.uid,
                ),
              ));
        });
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  Widget searchFun() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 5.0),
            height: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.transparent),
            child: TextField(
              onChanged: (input) {
                if (input.isNotEmpty) {
                  setState(() {
                    _users = DatabaseService.searchUsers(input);
                  });
                }
              },
//        onSubmitted: (input) {
//          if (input.isNotEmpty) {
//            setState(() {
//              _users = DatabaseService.searchUsers(input);
//            });
//          }
//        },
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for name",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.withOpacity(0.6),
                ),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    CupertinoIcons.clear,
                    size: 30.0,
                  ),
                  onPressed: _clearSearch,
                ),
                filled: true,
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Colors.black,
                  size: 30.0,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(CupertinoIcons.gear),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          isImageVisble: false,
          IsBack: false,
          title: "Search ",
          color: Colors.white,
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
//            SearchBar(
//              focusNode: null,
//              controller: _searchController,
//            ),
            searchFun(),
            Divider(
              height: 10,
            ),
            mBody(),
          ],
        ));
  }

  Widget mBody() {
    return _users == null
        ? Center(
            child: Text('Search for a user'),
          )
        : FutureBuilder<QuerySnapshot>(
      future: _users,
      builder: (context, map) {
        if (!map.hasData) {
          return Center(child: mStatlessWidgets().mLoading());
        }
        if (map.data.documents.length == 0) {
          return Center(
            child: Text('No users found! Please try again.'),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: map.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            User user = User.fromFirestore(map.data.documents[index]);
//                  Chat chat = Chat.fromFiresore(doc)

            return _buildUserTile(user);
          },
        );
      },
    );
  }
}
