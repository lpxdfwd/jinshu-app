import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/components/common-methods.dart';
import 'package:jinshu_app/pages/avatar/avatar.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<SettingsPage> {
  SharedPreferences prefs = CommonMethods.prefs;

  Event event = new Event();

  Map user = convert.jsonDecode(CommonMethods.prefs.getString('userInfo'));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  handleExitLogin() {
    doPrefsClear();
    event.emit('exitLogin', {});
    Navigator.of(context).pushReplacementNamed('/login');
  }

  doPrefsClear() {
    prefs.remove('contacts');
    prefs.remove('rootOwn');
    prefs.remove('isLogin');
    prefs.remove('userInfo');
  }

  void handleToAvatar() {
    Navigator.push(context, new MaterialPageRoute(builder: (context)=> AvatarPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text('账号与安全设置', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 78.0,
                  padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                  child: GestureDetector(
                    onTap: handleToAvatar,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('头像', style: TextStyle(fontSize: 14.0),),
                        Row(
                          children: <Widget>[
                            ClipOval(
                                child: user['headUrl'] == null ? new Image.asset('images/default-pic.png', width: 50, height: 50, fit: BoxFit.fill) : CachedNetworkImage(
                                  imageUrl: 'http://118.31.126.46:8080/' + user['headUrl'],
//              placeholder: (context, url) => CircularProgressIndicator(),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill,
                                )
                            ),
                            Icon(Icons.keyboard_arrow_right, color: Color(0xFF999999)),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Align (
              alignment: FractionalOffset(0.5, 0.92),
              child: MaterialButton(
                child: Text('退出登录'),
                height: 48.0,
                color: Colors.white,
                minWidth: 327.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))
                ),
                onPressed: handleExitLogin,
              ),
            )
          ],
      ),
    );
  }
}