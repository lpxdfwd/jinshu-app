import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class MessageCache {
  static SharedPreferences prefs;

  static Map messageCacheMap;

  static Map sendLoadingMap;

  MessageCache._internal();

  static MessageCache _instance = new MessageCache._internal();

  factory MessageCache(prefsInstance) {
    if (prefs == null || messageCacheMap == null) {
      prefs = prefsInstance;
      String messageMapString = prefs.getString('messageMap');
      if (messageMapString == null) {
        messageCacheMap = {};
        prefs.setString('messageMap', convert.jsonEncode(messageCacheMap));
      } else {
        messageCacheMap = convert.jsonDecode(prefs.getString('messageMap'));
      }
    }
    return _instance;
  }


  List getMessageList(String key) {
    if (!messageCacheMap.containsKey(key)) {
      messageCacheMap[key] = new List();
    }
    return messageCacheMap[key];
  }

  List setMassageList(String key, List list, bool isHis) {

    if (!messageCacheMap.containsKey(key)) {
      messageCacheMap[key] = list;
    } else {
      if(isHis) {
        messageCacheMap[key] = list.followedBy(messageCacheMap[key]).toList();
      } else {
        messageCacheMap[key] =  messageCacheMap[key].followedBy(list).toList();
      }
    }
    prefs.setString('messageMap', convert.jsonEncode(messageCacheMap));

    return messageCacheMap[key];
  }

  List setSendSuccess(String key, int sendId, Map msgItem) {
    if (!messageCacheMap.containsKey(key)) {
      messageCacheMap[key] = new List();
    }
    print('asdasdasdasdasd');
    if (sendLoadingMap.containsKey(sendId)){
      int index = sendLoadingMap[sendId];

      if (messageCacheMap[key].length > index && messageCacheMap[key][index] != null) {
        messageCacheMap[key][index]['msgId'] = msgItem['msgId'];
        messageCacheMap[key][index]['isLoading'] = false;

      }
    }
    prefs.setString('messageMap', convert.jsonEncode(messageCacheMap));
    return messageCacheMap[key];
  }

  setLoadingMap(int sendId, int index) {
    if (sendLoadingMap == null) sendLoadingMap = {};
    sendLoadingMap[sendId] = index;
  }

  void clear() {
    messageCacheMap = null;
    prefs.remove('messageMap');
  }
}