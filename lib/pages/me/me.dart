import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'dart:convert' as convert;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jinshu_app/components/common-methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/pages/settings/settings.dart';

class MeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MeScreenState();
}

class MeScreenState extends State<MeScreen> {
  SharedPreferences prefs = CommonMethods.prefs;

  Event event = new Event();

  Map user = convert.jsonDecode(CommonMethods.prefs.getString('userInfo'));

  bool switchValue = true;

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

  void handleToSettings() {
    Navigator.push(context, new MaterialPageRoute(builder: (context)=> SettingsPage()));
  }

  doPrefsClear() {
    prefs.remove('contacts');
    prefs.remove('rootOwn');
    prefs.remove('isLogin');
    prefs.remove('userInfo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: user['headUrl'] == null ? new Image.asset('images/logo.png', width: double.infinity, fit: BoxFit.fitWidth) : CachedNetworkImage(
                imageUrl: 'http://118.31.126.46:8080/' + user['headUrl'],
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
            ),
            Positioned(
              child: new Image.asset('images/top-mask.png', width: double.infinity, fit: BoxFit.fitWidth),
            ),
            Positioned(
              right: 12.0,
              top: 32.0,
              child: Container(
                child: GestureDetector(
                  onTap: handleExitLogin,
                  child: Text('退出', style: TextStyle(fontSize: 14, color: Colors.white),),
                ),
              ),
            ),
            Positioned(
              top: 273,
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 34, left: 29, right: 26),
                width: double.infinity,
                height: 343,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(user['userName'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                    Container(
                      width: 42,
                      height: 18,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(user['sex'] == 1 ? 'images/sex-man-icon.png' : 'images/sex-woman-icon.png', width: 12, height: 12, fit: BoxFit.fill,),
                          Text('25', style: TextStyle(color: Color(user['sex'] == 1 ? 0xFF359BFE : 0xFFFD598B), fontSize: 12),)
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: Text(user['sign'] ?? '这个人很懒，什么都没写～', style: TextStyle(fontSize: 14, color: Color(0xFF9BA2B1)),),
                    ),
                    Container(
                      width: double.infinity,
                      height: 24,
                      margin: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: handleToSettings,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('帐号与安全设置', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Icon(Icons.keyboard_arrow_right, color: Color(0xFFB5B5B5),)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 24,
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('新消息通知', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          Switch(
                            value: switchValue,
                            activeColor: Color(0xFF3699FF),
                            onChanged: (value) => this.setState(() {
                              switchValue = value;
                            }),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 24,
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('关于锦书', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          Icon(Icons.keyboard_arrow_right, color: Color(0xFFB5B5B5),)
                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
            Positioned(
              top: 236,
              left: MediaQuery.of(context).size.width / 2 - 37,
              child: Container(
                alignment: FractionalOffset(0.5, 0),
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFFeeeeee), width: 3),
                  borderRadius:BorderRadius.all(Radius.circular(37)),
                ),
                child: ClipOval(
                  child: user['headUrl'] == null ? new Image.asset('images/logo.png', fit: BoxFit.fill) : CachedNetworkImage(
                    imageUrl: 'http://118.31.126.46:8080/' + user['headUrl'],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}