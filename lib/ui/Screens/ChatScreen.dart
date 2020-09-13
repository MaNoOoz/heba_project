import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heba_project/models/models.dart';
import 'package:heba_project/ui/shared/utili/Constants.dart';
import 'package:heba_project/ui/shared/widgets/CustomWidgets.dart';
import 'file:///H:/Android%20Projects/Projects/Flutter%20Projects/Mine/heba_project/lib/ui/shared/widgets/CustomAppBar.dart';
import 'package:logger/logger.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  static const String id = "Chat_Screen";
  final String loggedInUserUid;
  final String chatRoomId;

  ChatScreen({this.loggedInUserUid, this.chatRoomId});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final ScrollController listScrollController = new ScrollController();
  final TextEditingController _textController = new TextEditingController();
  final FocusNode focusNode = new FocusNode();

  CollectionReference messagesRefrance;
  Logger logger = Logger();
  String reciverId;
  String loggedInUserID;

  String recverNameInAppbar;
  String createdChannelName;
  bool _isComposing = false;
  Message message;

  final List<Chat> chatObjects = [];
  List<Message> listOfMessages = [];

  ChatMessageBubble bubble;
  List<ChatMessageBubble> messageBubbles = [];
  Stream<QuerySnapshot> messagesStream;
  Stream<ChatMessageBubble> bubblesStream;
  StreamController<ChatMessageBubble> controller =
      StreamController<ChatMessageBubble>.broadcast();

  /// ========================================================================================

  /// LifeCycle ========================================================================================
  @override
  void dispose() {
//    for (ChatMessage message in _chatMessageWidgets) {
////      message.animationController.dispose();
//    }
//    streamSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

//  Future<List<Message>> mMessagesFromDbAsFuture() async {
//    logger.d("mMessagesFromDbAsStream Called");
//
//    messagesRefrance = CHATS.document(createdChannelName).collection(USERCHATS);
//
////    List<Post2> posts = await DatabaseService.getAllPosts2();
//    List<Message> msgs = [];
//    await for (var snapshot in messagesRefrance.snapshots()) {
//      for (var doc in snapshot.documents) {
//        logger.d(" HEE${snapshot.documents.length}");
//        var mMessage = new Message.fromFirestore(doc);
//        msgs.add(mMessage);
//      }
//    }
//    logger.d(" HEE 2 ${listOfMessages.length}");
//
//    return listOfMessages;
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          Stream stream = controller.stream;
//          var ss= stream.listen((event) {
//            logger.d("S $event");
//
//          });
//
//        },
//      ),
      appBar: CustomAppBar(
        isImageVisble: false,
        IsBack: true,
        title: "$recverNameInAppbar",
        color: Colors.white,
      ),
      body: body(),
    );
  }

  /// Methods ========================================================================================
//  List<Message> get messageList {
//    if (listOfMessages == null) {
//      return null;
//    } else {
//      listOfMessages.sort((x, y) => DateTime.parse(x.createdAt)
//          .toLocal()
//          .compareTo(DateTime.parse(y.createdAt).toLocal()));
//      listOfMessages.reversed;
//      return List.from(listOfMessages);
//    }
//  }
//
//  List<User> get chatUserList {
//    if (_chatUserList == null) {
//      return null;
//    } else {
//      return List.from(_chatUserList);
//    }
//  }
//
//  List<ChatMessageBubbles> get chatMessageWidgets {
//    if (_chatMessageWidgets == null) {
//      return null;
//    } else {
//      return List.from(_chatMessageWidgets);
//    }
//  }

//  String get channelName => _channelName;

  void init() async {
    logger.d("init Called");
    await setLoggedInUserID();
    await setChatID();
//    getStreamQuerySnapshot();
    setState(() {
      messagesStream = CHATS
          .document(createdChannelName)
          .collection(CHAT)
          .orderBy("timestamp", descending: true)
          .snapshots();
    });
//    var s2 =await getMessageBubbles();
//    var s = await mMessagesFromDbAsFuture();
//    logger.d("init ${s.length}");
//    logger.d("init ${s2.length}");
  }

  setLoggedInUserID() async {
    logger.d("setLoggedInUserID Called");

    reciverId = widget.chatRoomId
        .toString()
        .replaceAll("_", "")
        .replaceAll(widget.loggedInUserUid.toString(), "");

    loggedInUserID = widget.loggedInUserUid;
    logger.d('loggedInUserID : ${loggedInUserID}');
    logger.d(" Expect to Chat With this UserID: ${reciverId} ");
  }

  setChatID() async {
    logger.d("setChatID Called");
    createdChannelName = widget.chatRoomId;
    logger.d("createdChannelName $createdChannelName");
  }

  Future<QuerySnapshot> getQuerySnapshot() async {
    QuerySnapshot qn = await CHATS
        .document(createdChannelName)
        .collection(CHAT)
        .orderBy("timestamp", descending: true)
        .getDocuments();
    return qn;
  }

//  Stream<QuerySnapshot> getStreamQuerySnapshot() {
//    var qn = CHATS
//        .document(createdChannelName)
//        .collection(CHAT)
//        .orderBy("timestamp", descending: true)
//        .snapshots();
//    setState(() {
//      messagesStream = qn;
//      logger.d("messagesStream ");
//    });
//    return messagesStream;
//  }

//  Future<List<Message>> getMessages() async {
//    logger.d("getMessages Called:");
//    var snapshots = await getQuerySnapshot();
//
//    List<Message> _messages = [];
//
//    List<DocumentSnapshot> documents = snapshots.documents;
//    documents.forEach((DocumentSnapshot doc) {
//      message = Message.fromFirestore(doc);
//      _messages.add(message);
//    });
//    setState(() {
//      listOfMessages = _messages;
//    });
//    return listOfMessages;
//  }

//  Future<List<ChatMessageBubble>> getMessageBubbles() async {
//    logger.d("getMessageBubbles Called:");
//
//    var msgs = await getMessages();
//    if (msgs.length > 0) {
//      List<ChatMessageBubble> _Bubbles = [];
//      listOfMessages.forEach((var msg) {
//        var me = widget.loggedInUserUid == msg.idFrom;
//        var ts = Timestamp.fromDate(msg.timestamp.toDate()).toString();
//
//        bubble = ChatMessageBubble(
//          msg: msg,
//          isMe: me,
//          date: ts,
//        );
//        _Bubbles.add(bubble);
//      });
//
//      setState(() {
//        messageBubbles = _Bubbles;
//      });
//
//      logger.d("messageBubbles: ${messageBubbles.length}");
//    } else {
//      logger.d("U Have Error With readyToCreate: ${msgs}");
//    }
//    return messageBubbles;
//  }

  /// TESTING --- Create Empty Channel Name ============
//  Future<CollectionReference> createEmptyChannelNameRef() async {
//    /// Create Empty Channel Name
//    channelNameCollectionReference =
//        CHATS.document(createdChannelName).collection(CHAT);
//    return channelNameCollectionReference;
//  }
//  Future<bool> checkIfDocIsExist(map) async {
//    logger.d(" checkIfDocIsExist : Called");
//
//    var chatRoomDocId = await CHATS.document(createdChannelName).get();
//    if (chatRoomDocId.exists) {
//      logger.d("checkIfDocIsExist DOC IS  : ${chatRoomDocId.documentID}");
//
//      return true;
//    } else {
//      var chanNameRef = await createEmptyChannelNameRef();
//      logger.d(" chanNameRef : ${chanNameRef.id} ");
//      return false;
//    }
//  }
  ///End ===============================================

  Future<bool> addToDb(Message msg, Chat chat, String chatId) async {
    logger.d('addToDb : Called');
    var messageCollRef = CHATS.document(createdChannelName).collection(CHAT);
//    var messageCDocRef =  CHATS.document(createdChannelName);

    Message MessageFromMap;
    Chat ChatFraomMap;

    if (msg != null) {
      var mapFromMessage = msg.toMap();
//      var mapFromChat = chat.toMap();
//      var mapFromMessage2 = msg.toMap();
//      MessageFromMap = Message.fromMap(mapFromMessage2);

      messageCollRef.add(mapFromMessage);
      return true;

//      MessageFromMap = Message.fromMap(mapFromMessage);
    } else {
      logger.d('addToDb - msg is  : ${msg.message}');
      return false;
    }
  }

//  Future<Message> addToDb(Message msg, Chat chat, String chatId) async {
//    logger.d('addToDb : Called');
//    var messageCollRef = CHATS.document(createdChannelName).collection(CHAT);
////    var messageCDocRef =  CHATS.document(createdChannelName);
//
//    Message MessageFromMap;
//    Chat ChatFraomMap;
//    if (msg != null) {
//      var mapFromMessage = msg.toMap();
//      var mapFromChat = chat.toMap();
////      var mapFromMessage2 = msg.toMap();
////      MessageFromMap = Message.fromMap(mapFromMessage2);
//
//      messageCollRef.add(mapFromMessage);
//      MessageFromMap = Message.fromMap(mapFromMessage);
//    } else {
//      logger.d('addToDb - msg is  : ${msg.message}');
//    }
//    return MessageFromMap;
//  }

  onMessageSubmitted(String text) async {
//    List<String> chatIDS = [];
//    DocumentReference dr;
//    Map<String, dynamic> cData;

    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    var ts = Timestamp.fromDate(DateTime.now());

    /// Create new Message Object
    var msg = await CreateMessage(text);

    /// Add To The List todo 1
//    listOfMessages.add(msg);
    logger.d("listOfMessages :  ${listOfMessages.length}");

    List<User> users = [];

    /// Create New Chat Object
    var chat = Chat(createdChannelName, users);

    /// Add To The List
    chatObjects.add(chat);

    /// Write To Database
    var added = await addToDb(msg, chat, createdChannelName);
    if (added = true) logger.d(" added $added");

    /// Create Widget
//    if (added != null) {
//      /// check if is me
//      var me = widget.loggedInUserUid == added.idFrom;
//      logger.d("me :  ${bubble.isMe}");
//
//      bubble = ChatMessageBubble(
//        msg: added,
//        isMe: me,
//        date: ts.toDate().toIso8601String(),
//      );
//
//      logger.d("messageWidget :  ${bubble.isMe}");
//
//      List<ChatMessageBubble> Bubbles = [];
//
////      Bubbles.add(bubble);
//      Bubbles.add(bubble);
//
//      setState(() {
//        messageBubbles = Bubbles;
//      });
//      logger.d(
//          "chatObjects :${messageBubbles.length} ${chatObjects.length} , ${bubble.msg}");
//
////      return messageBubbles;
//    } else {
//      logger.d("messageWidget is Null");
//    }
  }

  Future<Message> CreateMessage(String text) async {
    Message message;

    var ts = Timestamp.fromDate(DateTime.now());
    var senderId = widget.loggedInUserUid;
    logger.d("senderId :  ${senderId}");
    logger.d("reciverId :  ${reciverId}");

    /// Create new Message Object
    message = Message(
      idFrom: senderId,
      idTo: reciverId,
      message: text,
      timestamp: ts,
      chatId: createdChannelName,
      documentId: createdChannelName,
    );
    logger.d("messageWidget :  ${message.message}");
    return message;
  }

  /// Widgets ========================================================================================
  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              flex: 2,
              child: new TextField(
                controller: _textController,
//                onChanged: (String text) {
//                  setState(() {
//                    _isComposing = text.length > 0;
//                  });
//                },
//                focusNode: focusNode,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? new CupertinoButton(
                      child: new Text("Send"),
                      onPressed: _isComposing
                          ? () async {
                              await onMessageSubmitted(_textController.text);
                            }
                          : null)
                  : new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: () async {
                        await onMessageSubmitted(_textController.text);
                      }),
            ),
          ],
        ),
      ),
    );
  }

  /// As Stream
  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MessageStream(widget.loggedInUserUid, createdChannelName),

        ///  typing Funcion ?? todo
//                _isComposing
//                    ? Align(
//                        alignment: AlignmentDirectional.centerStart,
//                        child: Container(
//                          height: 10,
//                          color: Colors.greenAccent,
//                          child: Text(
//                            'Typing ...',
//                            style: TextStyle(color: Colors.green),
//                          ),
//                        ),
//                      )
//                    : Container(
//                        color: Colors.red,
//                        height: 10,
//                      ),

        /// footer
        Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ],
    );
  }

  Widget MessageStream(
    final String loggedInUser,
    final String _channelName,
  ) {
    QuerySnapshot empty;
    return StreamBuilder<QuerySnapshot>(
        initialData: empty,
        stream: messagesStream ?? empty,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> map) {
          if (!map.hasData) {
            Center(
              child: Text("No Messages"),
            );
          } else if (map.hasError) {
            logger.d('u have error in future');
          } else if (map.connectionState == ConnectionState.waiting) {
            logger.d('waiting ...');
            return Center(
              child: mStatlessWidgets().mLoading(),
            );
          }

//
          final docs = map.data.documents;
          var messageBubble;
          var ts = Timestamp.fromDate(DateTime.now());
          docs.forEach((DocumentSnapshot doc) {
            message = new Message.fromFirestore(doc);
            listOfMessages.add(message);
            logger.d("docs ${docs.length}");
            logger.d("messages ${listOfMessages.length}");
//            messageBubble = ChatMessageBubble(
//              msg: message,
//              date: ts.toString(),
//              isMe: widget.loggedInUserUid == message.idFrom,
//            );
            logger.d("DOC ${doc.documentID}");
            messageBubbles.add(messageBubble);
          });
//          return Expanded(
//            flex: 2,
//            child: ListView(
//              scrollDirection: Axis.vertical,
//              shrinkWrap: true,
//              reverse: true,
//              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//              children: messageBubbles,
//            ),
//          );
          return Expanded(
            flex: 2,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                reverse: true,
                itemCount: docs.length,
                padding: const EdgeInsets.only(top: 15.0),
                itemBuilder: (context, index) {
//                DocumentSnapshot ds = map.data.documents[index];
//                DocumentSnapshot ds = map.data.documents[index];
//                      Post2 post2 = Post2.fromDoc(ds);
//                postFromFuture = Post2.fromFirestore(ds);
//                _HebaPostsFromDb(widget.post);
//                return rowView(_docsList[index], index);
                  return GestureDetector(
                    child: ChatMessageBubble(
                      msg: listOfMessages[index],
                      date: ts.toString(),
                      isMe: widget.loggedInUserUid == message.idFrom,
                    ),
                    onTap: () {
                      logger.d("ChatMessageBubble ${ChatMessageBubble().msg}");
                    },
                  );
                }),
          );

//          return StreamBuilder<ChatMessageBubble>(
//            stream: bubblesStream,
//            builder: (context, AsyncSnapshot<ChatMessageBubble> snapshot) {
//
//            },
//          );
        });
  }
}

class ChatMessageBubble extends StatelessWidget {
  final Message msg;
  final bool isMe;
  final String date;

//  final AnimationController animationController;

  ChatMessageBubble({this.msg, this.isMe, this.date});

//  ChatMessageBubbles({this.msg, this.isMe, this.date, this.animationController});

  @override
  Widget build(BuildContext context) {
    // Add a new locale messages
    var ar = timeago.format(msg.timestamp.toDate(), locale: 'ar');
    var en = timeago.format(msg.timestamp.toDate(), locale: 'en_short');
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(msg.timestamp.toDate());
    String res = timeOfDay.format(context);
    bool is12HoursFormat = res.contains(new RegExp(r'[A-Z]'));
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Expanded(
            child: new Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45, width: 0.4),
                    color: isMe
                        ? Colors.blueAccent.withOpacity(0.2)
                        : Colors.greenAccent.withOpacity(0.2),
                    borderRadius: isMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(0),
                            bottomLeft: Radius.circular(10),
                          )
                        : BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                  ),
                  alignment: isMe
                      ? AlignmentDirectional.centerStart
                      : AlignmentDirectional.centerEnd,
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: new Text("${res}",
                                style: Theme.of(context).textTheme.caption),
                          ),
                        ),
                        isMe
                            ? Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: new Text(msg.idFrom ?? "S",
                                      style:
                                          Theme.of(context).textTheme.caption),
                                ),
                              )
                            : Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: new Text(msg.idTo ?? "S",
                                      style:
                                          Theme.of(context).textTheme.caption),
                                ),
                              ),
                        isMe
                            ? Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: new Text(msg.message,
                                      style:
                                          Theme.of(context).textTheme.subhead),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: new Text(msg.message,
                                      style:
                                          Theme.of(context).textTheme.subhead),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
//                Container(
//                    decoration: BoxDecoration(
//                      color: Colors.green.withOpacity(0.2),
//                      borderRadius: BorderRadius.only(
//                        topLeft: Radius.circular(10),
//                        topRight: Radius.circular(0),
//                        bottomRight: Radius.circular(10),
//                        bottomLeft: Radius.circular(10),
//                      ),
//                    ),
//                    alignment: AlignmentDirectional.centerEnd,
//                    margin: const EdgeInsets.all(10),
//                    child: Column(
//                      children: <Widget>[
//                        Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Align(
//                            alignment: AlignmentDirectional.centerStart,
//                            child: new Text(msg.idFrom,
//                                style: Theme.of(context).textTheme.caption),
//                          ),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: new Text(msg.content,
//                              style: Theme.of(context).textTheme.subhead),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Align(
//                            alignment: AlignmentDirectional.centerStart,
//                            child: new Text(
//                                "${timeago.format(msg.timestamp.toDate())}",
//                                style: Theme.of(context).textTheme.caption),
//                          ),
//                        )
//                      ],
//                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

//  Widget build(BuildContext context) {
//    var right = isMe == true;
//    var left = isMe == false;
//    return SizeTransition(
//      sizeFactor: new CurvedAnimation(
//        parent: animationController,
//        curve: Curves.easeOut,
//      ),
//      axisAlignment: 0.0,
//      child: new Container(
//        margin: const EdgeInsets.symmetric(vertical: 10.0),
//        child: new Row(
//          crossAxisAlignment: CrossAxisAlignment.end,
//          children: <Widget>[
//            new Expanded(
//              child: new Column(
//                children: <Widget>[
////                if (right == true)
//                  Container(
//                      decoration: BoxDecoration(
//                        color: Colors.blueAccent.withOpacity(0.2),
//                        borderRadius: BorderRadius.only(
//                          topLeft: Radius.circular(0),
//                          topRight: Radius.circular(10),
//                          bottomRight: Radius.circular(10),
//                          bottomLeft: Radius.circular(10),
//                        ),
//                      ),
//                      alignment: AlignmentDirectional.centerStart,
//                      margin: const EdgeInsets.all(10),
//                      child: Column(
//                        children: <Widget>[
//                          Align(
//                            alignment: AlignmentDirectional.centerStart,
//                            child: Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: new Text(msg.idTo,
//                                  style: Theme.of(context).textTheme.caption),
//                            ),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: new Text(msg.content,
//                                style: Theme.of(context).textTheme.subhead),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: Align(
//                              alignment: AlignmentDirectional.centerStart,
//                              child: new Text(
//                                  "${timeago.format(msg.timestamp.toDate())}",
//                                  style: Theme.of(context).textTheme.caption),
//                            ),
//                          )
//                        ],
//                      )),
//
//                  Container(
//                      decoration: BoxDecoration(
//                        color: Colors.green.withOpacity(0.2),
//                        borderRadius: BorderRadius.only(
//                          topLeft: Radius.circular(10),
//                          topRight: Radius.circular(0),
//                          bottomRight: Radius.circular(10),
//                          bottomLeft: Radius.circular(10),
//                        ),
//                      ),
//                      alignment: AlignmentDirectional.centerEnd,
//                      margin: const EdgeInsets.all(10),
//                      child: Column(
//                        children: <Widget>[
//                          Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: Align(
//                              alignment: AlignmentDirectional.centerStart,
//                              child: new Text(msg.idFrom,
//                                  style: Theme.of(context).textTheme.caption),
//                            ),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: new Text(msg.content,
//                                style: Theme.of(context).textTheme.subhead),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: Align(
//                              alignment: AlignmentDirectional.centerStart,
//                              child: new Text(
//                                  "${timeago.format(msg.timestamp.toDate())}",
//                                  style: Theme.of(context).textTheme.caption),
//                            ),
//                          )
//                        ],
//                      )),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
}

//
//void newChatsListener(senderID, channelId) {
//  chats
//      .document(senderID)
//      .collection("userChats")
//      .document(senderID)
//      .collection(channelId)
//      .snapshots()
//      .listen(_onChatUserAdded);
//}
//
//void _onChatUserAdded(QuerySnapshot querySnapshot) {
//  DocumentSnapshot doc;
//  User model;
//  if (_chatUserList == null) {
//    _chatUserList = List<User>();
//  }
//  if (querySnapshot.documents != null) {
//    List<DocumentSnapshot> documents = querySnapshot.documents;
//    for (doc in documents) {
//var map = doc.data;
//if (map != null) {
//model = User.fromMap(map);
//model.uid = doc.data['uid'];
//if (_chatUserList.length > 0 &&
//_chatUserList.any((x) => x.uid == model.uid)) {
//return;
//} else {
//_chatUserList = null;
//}
//}
//}
//    _usersController.add(model);
//  }
//}

//  getMesages() async {
//    List<Message> mesages = await getMesagesForUser(
//        currentUserId: widget.currentUserId, userId: widget.userId);
//    for (var message in mesages) {
//      logger.d(" SENDER ${message.idTo}");
//    }
//    setState(() {
//      _mesages = mesages;
//    });
//  }

//  initMesages() async {
//    List<Message> mesages = DatabaseService.createMesagesForUser(
//        currentUserId: widget.currentUserId, userId: widget.userId);
//    for (var message in mesages) {
//      logger.d(" SENDER ${message.senderName}");
//    }
//    setState(() {
//      _mesages = mesages;
//    });
//  }

//  mMessagesFromDb() async {
//    logger.d("mMessagesFromDb Called");
//
//    messagesRefrance = contacts
//        .document(widget.currentUserId)
//        .collection('userContacts')
//        .document(widget.userId)
//        .collection("messages");
//
//    messagesStream = messagesRefrance.snapshots();
//
////    List<Post2> posts = await DatabaseService.getAllPosts2();
//    List<Message> msgs = [];
//    QuerySnapshot qn = await messagesRefrance.getDocuments();
//
//    List<DocumentSnapshot> documents = qn.documents;
//    documents.forEach((DocumentSnapshot doc) {
//      mMessage = new Message.fromFirestore(doc);
//      msgs.add(mMessage);
//    });
//
//    logger.d("_setupPosts  ${mMessage.idFrom}");
//    logger.d("_setupPosts  ${msgs.length}");
//    setState(() {
//      _mesages = msgs;
//    });
//    logger.d("SSSADASD : ${mMessage.idTo}");
//
//    return msgs;
//  }

//  mMessagesFromDbAsStream() async {
//    logger.d("mMessagesFromDb Called");
//
//    messagesRefrance = contacts
//        .document(widget.currentUserId)
//        .collection('userContacts')
//        .document(widget.userId)
//        .collection("messages");
//
////    List<Post2> posts = await DatabaseService.getAllPosts2();
//    List<Message> msgs = [];
//    await for (var snapshot in messagesRefrance.snapshots()) {
//      for (var doc in snapshot.documents) {
//        logger.d(doc.data);
//        mMessage = new Message.fromFirestore(doc);
//        msgs.add(mMessage);
//      }
//      setState(() {
//        _mesages = msgs;
//      });
//    }
//    return msgs;
//  }
//Widget mMessageList() {
//  return Expanded(
//    flex: 2,
//    child: Container(
//      child: ListView.builder(
//        controller: listScrollController,
//        shrinkWrap: true,
//        reverse: true,
//        itemCount: _chatMessageWidgets.length,
//        padding: const EdgeInsets.only(top: 15.0),
//        itemBuilder: (BuildContext context, int index) {
//          var chatBuble = _chatMessageWidgets[index];
//
//          logger.d("chatBuble ${chatBuble.msg} ${chatBuble.date}");
//
//          return chatBuble;
//        },
//
////            Container(
////              color: Colors.cyan,
////              child: new ListView.builder(
////                  physics: ScrollPhysics(),
////                  scrollDirection: Axis.vertical,
////                  shrinkWrap: true,
//////              itemCount: map.data.documents.length,
////                  itemCount: _mesages.length,
////                  padding: const EdgeInsets.only(top: 15.0),
////                  itemBuilder: (context, index) {
////                    DocumentSnapshot ds = map.data.documents[index];
////                    Message msgsFromDb = Message.fromFirestore(ds);
//////                      Post2 post2 = Post2.fromDoc(ds);
//////                postFromFuture = Post2.fromFirestore(ds);
//////                _HebaPostsFromDb(widget.post);
////                    return ListTile(
////                      leading: CircleAvatar(
////                        radius: 20.0,
////                        backgroundImage: msgsFromDb.senderPhotoUrl.isEmpty
////                            ? AssetImage('assets/images/uph.jpg')
////                            : CachedNetworkImageProvider(
////                                msgsFromDb.senderPhotoUrl),
////                      ),
////                      title: Text(msgsFromDb.senderName),
////                      trailing: Text(msgsFromDb.senderPhotoUrl),
////                      subtitle: Text(msgsFromDb.text),
////                    );
////
//////                return GestureDetector(
//////                    onTap: () {
//////                      logger.d("${index} ");
//////                      Navigator.push(
//////                        context,
//////                        MaterialPageRoute(
//////                          builder: (context) => HebaDetails(_docsList[index]),
//////                        ),
//////                      );
//////                    },
//////                    child: viewType(postFromFuture));
////                  }),
////            ),
////          FirebaseAnimatedList(),
//      ),
//    ),
//  );
//}

/// As Future
//  Widget mBody(Message message) {
//    return FutureBuilder<QuerySnapshot>(
//      future: messagesRefrance.getDocuments(),
//      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> map) {
//        if (!map.hasData) {
//          return Center(
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                mStatlessWidgets().mLoading(),
//              ],
//            ),
//          );
//        } else if (map.hasError) {
//          logger.d('u have error in future');
//        }
//
//        var docs = map.data.documents.reversed;
//        docs.forEach((DocumentSnapshot doc) {
//          message = new Message.fromFirestore(doc);
//          logger.d("DOC ${doc.documentID}");
//          logger.d("DOC ${message.idFrom}");
//
//          var chatWidget = ChatMessage(
//            msg: message,
//            isMe: widget.currentUserId == message.idFrom,
//          );
////          _mesages.add(message);
//          _ChatMessages.add(chatWidget);
//        });
//
////        var ts = Timestamp.fromDate(DateTime.now());
//
//        return new Container(
//            color: Colors.white,
//            child: new Column(
//              children: <Widget>[
//                mMessageList(context, map),
//
//                /// footer
//                Container(
//                  decoration:
//                      new BoxDecoration(color: Theme.of(context).cardColor),
//                  child: _buildTextComposer(map.data),
//                ),
//              ],
//            ),
//            decoration: Theme.of(context).platform == TargetPlatform.iOS
//                ? new BoxDecoration(
//                    border: new Border(
//                      top: new BorderSide(color: Colors.grey[200]),
//                    ),
//                  )
//                : null);
//      },
//    );
//  }

//Widget mMessageList2(BuildContext context) {
//  return Expanded(
//    flex: 2,
//    child: Container(
//        color: Colors.amber,
//        child: _chatMessageWidgets.isNotEmpty
//            ? ListView(
//          scrollDirection: Axis.vertical,
//          shrinkWrap: true,
//          reverse: true,
//          controller: listScrollController,
//          padding: const EdgeInsets.only(top: 15.0),
//          children: _chatMessageWidgets,
//        )
//            : Center(
//          child: Text("No Messages"),
//        )),
//  );
//}
