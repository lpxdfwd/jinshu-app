import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheLib {
  CacheLib._internal();

  static CacheLib cacheInstance = new CacheLib._internal();

  factory CacheLib() {
    if (prefs == null) {
//      SharedPreferences.setMockInitialValues({
//        'isLogin': false
//      });
      SharedPreferences.getInstance().then((instance) {
        prefs = instance;
      });
    }
    return cacheInstance;
  }

  static SharedPreferences prefs;
}

CacheLib cacheLib = CacheLib();
