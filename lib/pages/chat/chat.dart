import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:jinshu_app/utils/socketUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:jinshu_app/utils/messageCache.dart';
import 'dart:async';
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

  bool isRoot = false;

  String sendVal = '';

  Event event = new Event();

  MessageCache messageCache;

  List msgList = [];

  bool isHistory = false;

  ScrollController _scrollController = ScrollController();

  ChatScreenState(prefsInstance) {
    messageCache = new MessageCache(prefsInstance);
    prefs = prefsInstance;
    user = convert.jsonDecode(prefs.getString('userInfo'));
    chatUser = convert.jsonDecode(prefs.getString('chatUser'));
    Map rootOwn = convert.jsonDecode(prefs.getString('rootOwn'));
    isRoot = chatUser['id'] == rootOwn['id'];
  }

  @override
  void initState() {
    super.initState();
    initEvent();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == 0 && msgList.length > 10) {
        SocketUtils.queryHistoryMsg({
          'wuyanSessionId': prefs.getString('wuyanSessionId'),
          'sessionId': SocketUtils.sessionId,
          'lastHisMsgId': (messageCache.getMessageList(SocketUtils.sessionKey) == null || messageCache.getMessageList(SocketUtils.sessionKey).length == 0) ? null : messageCache.getMessageList(SocketUtils.sessionKey)[0]['msgId']
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    clearEvent();
    sendController.dispose();
  }

  clearEvent() {
    event.remove('current');
    event.remove('join');
  }

  initEvent() {
    event.on('current', handleNormalMsg);
    event.on('join', handleJoinSuccess);
    event.on('sendSuccess', handleSendSuccess);
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
//      event.emit('refreshContacts', {});
    }
    setState(() {
      msgList = messageCache.getMessageList(SocketUtils.sessionKey);
    });
  }

  handleNormalMsg(data) {
    bool isHis = data['eventType'] == 'PuHisMsgApp';
    setState(() {
      msgList = messageCache.setMassageList(SocketUtils.sessionKey, data['msgList'], isHistory);
      isHistory = isHis;
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
          margin: const EdgeInsets.only(bottom: 27.0),
          width: 316,
          child: Row(
            mainAxisAlignment: isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              item['isLoading'] == true ? Container(
                margin: const EdgeInsets.only(top: 10, right: 10),
                child: Icon( IconData(0xe838, fontFamily: 'iconfont'),color: Colors.blue,size: 15),
              ) : Text(''),
              !isOwn ? ClipOval(
                  child: chatUser['headUrl'] == null ? new Image.asset('images/default-pic.png', width: 50, height: 50, fit: BoxFit.fill) : CachedNetworkImage(
                    imageUrl: 'http://118.31.126.46:8080/' + chatUser['headUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  )
              ) : Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF3699FF), Color(0xFF30D8FC)]),
                      borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  margin: const EdgeInsets.only(right: 16.0),
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 12),
                  constraints: BoxConstraints(
                      minHeight: 20,
                      maxWidth: 250
                  ),
                  child: Text(item['content'], softWrap: true, style: TextStyle(color: Colors.white))
              ),
              isOwn ? ClipOval(
                  child: user['headUrl'] == null ? new Image.asset('images/default-pic.png', width: 50, height: 50, fit: BoxFit.fill) : CachedNetworkImage(
                    imageUrl: 'http://118.31.126.46:8080/' + user['headUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  )
              ) :  Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xFF007BFF), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  margin: const EdgeInsets.only(left: 16.0),
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 12),
                  constraints: BoxConstraints(
                    minHeight: 20,
                    maxWidth: 250
                  ),
                  child: Text(item['content'], softWrap: true)
              ),
            ],
          ),
        ),
      );
    });
    if (widgetList.length > 0 && isHistory == false)
      Timer(Duration(milliseconds: 200  ),
              () => _scrollController.position.jumpTo(_scrollController.position.maxScrollExtent));
    return ListView(
        children: widgetList,
        controller: _scrollController
    );
  }

  void handleSendMsg(val) {
    print('发送消息: $val');
    int sendId = SocketUtils.getSendMsgId();
    SocketUtils.sendMessage({
      'wuyanSessionId': prefs.getString('wuyanSessionId'),
      'sessionId': SocketUtils.sessionId,
      'sessionKey': SocketUtils.sessionKey,
      'content': val,
      'senderId': user['id'],
      'senderUseNick': user['userName'],
      'receiverId': chatUser['id'],
      'msgCreateTime': DateTime.now().millisecondsSinceEpoch,
      'msgType': 1,
      'sessionType': 1,
      'sendMsgId': sendId,
      'role': chatUser['role']
    });
    setState(() {
      msgList = messageCache.setMassageList(SocketUtils.sessionKey, [{
        'senderId': user['id'],
        'content': val,
        'msgId': DateTime.now().millisecondsSinceEpoch,
        'isLoading': true,
        'sendMsgId': sendId,
      }], isHistory);
      messageCache.setLoadingMap(sendId, msgList.length - 1);
      isHistory = false;
    });
    sendController.clear();
  }

  handleSendSuccess(data) {
    setState(() {
      msgList = messageCache.setSendSuccess(SocketUtils.sessionKey, data['sendMsgId'], data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: isRoot ? BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/root-head-bg.png'),
                      fit: BoxFit.cover,
                     ),
                  ) : null,
                  child: AppBar(
                    backgroundColor: isRoot ? Colors.transparent : Colors.white,
                    elevation: 0,
                    iconTheme: IconThemeData(
                        color: isRoot ? Colors.white : Colors.black
                    ),
                    title: Text(isRoot ? '小锦' : chatUser['userName'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isRoot ? Colors.white : Colors.black)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      padding: const EdgeInsets.only(top: 18, right: 16, left: 16),
                      child: renderMsgList(),
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        color: Color(0xFFF7F7F7),
                      )
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  alignment: Alignment.center,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 28,
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: 14),
                      controller: sendController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: handleSendMsg,
//                    onChanged: () {},
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(18, 7, 18, 7),
                        hintText: '',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Color(0xFFFAFAFB),
                      ),
                    ),
                  ),
                ),
              ]
          )
      )
    );
  }
}