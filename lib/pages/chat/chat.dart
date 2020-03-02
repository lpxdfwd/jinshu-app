import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:jinshu_app/utils/socketUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:jinshu_app/utils/messageCache.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatScreen extends StatefulWidget {

  static SharedPreferences prefsInstance;

  ChatScreen(SharedPreferences prefs) {
    prefsInstance = prefs;
  }

  @override
  State<StatefulWidget> createState() => ChatScreenState(prefsInstance);
}

class ChatScreenState extends State<ChatScreen> {
  TextEditingController sendController = new TextEditingController();

  SharedPreferences prefs;

  Map user = {};

  Map chatUser = {};

  String sendVal = '';

  Event event = new Event();

  MessageCache messageCache;
  
  List msgList = [];

  ChatScreenState(prefsInstance) {
    messageCache = new MessageCache(prefsInstance);
    prefs = prefsInstance;
    user = convert.jsonDecode(prefs.getString('userInfo'));
    chatUser = convert.jsonDecode(prefs.getString('chatUser'));
  }

  @override
  void initState() {
    super.initState();
    initEvent();
  }

  @override
  dispose() {
    super.dispose();
    clearEvent();
  }

  clearEvent() {
    event.remove('current');
    event.remove('join');
  }

  initEvent() {
    event.on('current', handleNormalMsg);
    event.on('join', handleJoinSuccess);
  }

  handleJoinSuccess(data) async {
    List contacts = convert.jsonDecode(prefs.getString('contacts'));
    if (data['isJoin'] == null) {
      contacts.forEach((item) {
        if (item['id'] == chatUser['id']) {
          item['sessionKey'] = data['msgItem']['sessionKey'];
          item['sessionId'] = data['msgItem']['sessionId'];
        }
      });
      await prefs.setString('contacts', convert.jsonEncode(contacts));
      event.emit('refreshContacts', {});
    }
    setState(() {
      msgList = messageCache.getMessageList(SocketUtils.sessionKey);
    });
  }

  handleNormalMsg(data) {
    bool isHistory = data['eventType'] == 'PullHisMsg';
    setState(() {
      msgList = messageCache.setMassageList(SocketUtils.sessionKey, data['msgList'], isHistory);
    });
  }

  Widget renderMsgList() {
    List<Widget> widgetList = [];
    msgList.forEach((item) {
      bool isOwn = item['senderId'] == user['id'];
      widgetList.add(
//          Container(
//            child: new Text(item['content']),
//          )
        Container(
          margin: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              !isOwn ? ClipOval(
                  child: chatUser['headUrl'] == null ? new Image.asset('images/default-pic.png', width: 50, height: 50, fit: BoxFit.fill) : CachedNetworkImage(
                    imageUrl: 'http://118.31.126.46:8080/' + chatUser['headUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  )
              ) : Container(
                  margin: const EdgeInsets.only(right: 12.0),
                  width: 250,
                  child: Text(item['content'], softWrap: true)
              ),
              isOwn ? ClipOval(
                  child: user['headUrl'] == null ? new Image.asset('images/default-pic.png', width: 50, height: 50, fit: BoxFit.fill) : CachedNetworkImage(
                    imageUrl: 'http://118.31.126.46:8080/' + user['headUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  )
              ) : Container(
                  margin: const EdgeInsets.only(left: 12.0),
                  width: 250,
                  child: Text(item['content'], softWrap: true)
              ),
            ],
          ),
        ),
      );
    });
    return ListView(
        children: widgetList
    );
  }

  void handleSendMsg(val) {
    print('发送消息: $val');
    SocketUtils.sendMessage({
      'content': val,
      'senderId': user['id'],
      'senderUseNick': user['userName'],
      'receiverId': chatUser['id'],
      'token': user['token'],
      'tokenTimestamp': DateTime.now().millisecondsSinceEpoch,
      'msgType': 1,
      'role': chatUser['role']
    });
    sendController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatUser['userName'] ?? 'chat'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      child: renderMsgList(),
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                      )
                  ),
                ),
                TextField(
                    autofocus: false,//是否自动获取焦点
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(//InputDecoration：用于控制TextField的外观显示，如提示文本、背景颜色、边框等。
                      hintText: "请输入要发送的消息",
                      prefixIcon: Icon(Icons.message),
                    ),
                    controller: sendController,
                    onSubmitted: handleSendMsg,
                ),
              ]
          )
      )
    );
  }
}