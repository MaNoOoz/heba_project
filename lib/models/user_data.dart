/*
 * Copyright (c) 2019.  Made With Love By Yaman Al-khateeb
 */

import 'package:flutter/foundation.dart';
import 'package:heba_project/models/user_model.dart';

import 'Chat.dart';

class UserData extends ChangeNotifier {
  String currentUserId;
  String currentChatId;
  String channelId;
  bool isFeatured;
  User user;
  ChatModel conver;
}
