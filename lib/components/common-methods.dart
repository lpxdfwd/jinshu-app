import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:jinshu_app/utils/socketUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:jinshu_app/utils/normalUtils.dart';
import 'package:jinshu_app/pages/chat/chat.dart';
import 'package:jinshu_app/request/request.dart';

class CommonMethods {
  static SharedPreferences prefs;

  CommonMethods._internal();

  Event event = new Event();

  Request request = Request();

  static CommonMethods instance = new CommonMethods._internal();

  factory CommonMethods([SharedPreferences preferences]) {
    if (prefs == null) prefs = preferences;
    return instance;
  }

  handleToggleFollow(String type, String userId, String followId, RequestCallback callback) async {
    Map res = await request.post('/attention/operate', {'userId': userId, 'targetUserId': followId, 'action': type});
    requestDoneShowToast(res, '', callback);
  }

  handleJoinChat(context, Map item) {
    prefs.setString('chatUser', convert.jsonEncode(item));
    String userString = prefs.getString('userInfo');
    if (userString == null) return event.emit('exitLogin', {});
    Map user = convert.jsonDecode(userString);
    if (item['sessionKey'] == null) {
      SocketUtils.joinChat({
        'senderId': user['id'],
        'receiverId': item['id'],
        'token': user['token'],
        'tokenTimestamp': DateTime.now().millisecondsSinceEpoch,
        'msgType': 0
      }, false);
    } else {
      item['isJoin'] = true;
      createTimeOut(() {
        SocketUtils.handleEvent('join', item);
        event.emit('join', item);
      }, 200);
    }
    Navigator.push(context, new MaterialPageRoute(builder: (context)=> ChatScreen(prefs)));
  }
}