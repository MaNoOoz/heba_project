/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/material.dart';
import 'package:heba_project/ui/shared/mAppbar.dart';

class ChatsScreen extends StatefulWidget {
  static final String id = 'chats_screen';

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "المحادثات",
        isHome: true,
        color: Colors.white,
        isImageVisble: true,
      ),
      body: Center(
        child: Text('Activity',
        ),
      ),
    );
  }
}
