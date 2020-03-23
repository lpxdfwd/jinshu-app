import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jinshu_app/utils/normalUtils.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Request {

  Request._internal();

  static SharedPreferences prefs;

  static Request cacheInstance = new Request._internal();

  String basePath = 'http://112.124.202.207:8080/';

  factory Request([SharedPreferences preferences]) {
    if (prefs == null) prefs = preferences;
    return cacheInstance;
  }

  Dio dio = Dio(BaseOptions(
    baseUrl: 'http://112.124.202.207:8080/',
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  get(String path, Map params) async {
    String uri = basePath + path + queryString(params);
    var response = await http.get(uri);
    return json.decode(response.body);
  }

  post(String path, Map params) async {
    String uri = basePath + path;
    var response = await http.post(
        uri, body: json.encode(params), encoding: Utf8Codec(), headers: {
      'Content-Type': 'application/json',
    });
    String cookieString = response.headers['set-cookie'];
    String wuyanSessionId = formatSearchString(cookieString)['wuyan-session-id'];
    if (wuyanSessionId != null) prefs.setString('wuyanSessionId', wuyanSessionId);
    Map responseData = json.decode(response.body) != null ? json.decode(response.body) : {};
    return responseData;
  }

  file(String path, FormData formData) async {
    var res = await dio.post(path, data: formData);
    print('@@@@@@@@@@@@@@@@@@################$res');
    return res;
  }
}
