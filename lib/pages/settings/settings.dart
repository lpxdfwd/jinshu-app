import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/components/common-methods.dart';
import 'package:jinshu_app/pages/avatar/avatar.dart';
import 'package:jinshu_app/components/picker.dart';
import 'package:jinshu_app/request/request.dart';
import 'package:jinshu_app/pages/settings/edit-name.dart';
import 'package:jinshu_app/pages/settings/edit-sign.dart';
import 'package:jinshu_app/pages/settings/edit-sex.dart';
import 'package:jinshu_app/pages/settings/edit-mobile.dart';
import 'package:jinshu_app/pages/settings/edit-pass.dart';
import 'package:jinshu_app/utils/normalUtils.dart';

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
    event.on('queryUser', handleQueryUser);
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

  void handleToEditName() {
    Navigator.push(context, new MaterialPageRoute(builder: (context)=> EditName(user)));
  }

  void handleToEditSign() {
    Navigator.push(context, new MaterialPageRoute(builder: (context)=> EditSign(user)));
  }

  void handleToEditSex() {
    Navigator.push(context, new MaterialPageRoute(builder: (context)=> EditSex(user)));
  }

  void handleToEditMobile() {
    Navigator.push(context, new MaterialPageRoute(builder: (context)=> EditMobile(user)));
  }

  void handleToEditPass() {
    Navigator.push(context, new MaterialPageRoute(builder: (context)=> EditPass(user)));
  }

  handleGetSex() {
    var sex = user['sex'];
    switch(sex) {
      case 1:
        return '男';
      case 0:
        return '女';
    }
    return '未设置';
  }

  handleQueryUser(a) async {
    dynamic userRes = await request.get('/passport/detail/get', {'userId': user['id'], 'currentUserId': user['id']});
    if (userRes['data'] != null) {
      this.setState(() {
        user = userRes['data'];
        prefs.setString('userInfo', convert.jsonEncode(userRes['data']));
      });
    }
  }

  handleUpdateUser(value, type) async {
    var res = await request.post('/passport/detail/update', {'id': user['id'], '$type': value});
    requestDoneShowToast(res, '', () {
      handleQueryUser({});
    });
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
                  behavior: HitTestBehavior.opaque,
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
              ),
              Container(
                height: 48.0,
                padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 2.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: handleToEditName,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('昵称', style: TextStyle(fontSize: 14.0),),
                      Row(
                        children: <Widget>[
                          Text(user['userName'], style: TextStyle(fontSize: 14.0, color: Color(0xFFA4A4A4)),),
                          Icon(Icons.keyboard_arrow_right, color: Color(0xFF999999)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 48.0,
                padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 2.0),
                child: GestureDetector(
                  onTap: handleToEditMobile,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('手机号', style: TextStyle(fontSize: 14.0),),
                      Row(
                        children: <Widget>[
                          Text(user['mobile'], style: TextStyle(fontSize: 14.0, color: Color(0xFFA4A4A4)),),
                          Icon(Icons.keyboard_arrow_right, color: Color(0xFF999999)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 48.0,
                padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 2.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: handleToEditSex,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('性别', style: TextStyle(fontSize: 14.0),),
                      Row(
                        children: <Widget>[
                          Text(handleGetSex(), style: TextStyle(fontSize: 14.0, color: Color(0xFFA4A4A4)),),
                          Icon(Icons.keyboard_arrow_right, color: Color(0xFF999999)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 48.0,
                padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 2.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (BuildContext ctx) {
                      return Container(
                        child: PickerData(ctx, (y, m, d) {
                          handleUpdateUser('$y-$m-$m', 'birthDate');
                          Navigator.of(ctx).pop();
                        }),
                      );
                    }
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('年龄', style: TextStyle(fontSize: 14.0),),
                      Row(
                        children: <Widget>[
                          Text('${user['ageGroup']} ${user['signStar']}', style: TextStyle(fontSize: 14.0, color: Color(0xFFA4A4A4)),),
                          Icon(Icons.keyboard_arrow_right, color: Color(0xFF999999)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                constraints:BoxConstraints(
                  minHeight: 48.0,
                ),
                padding: const EdgeInsets.all(14),
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 6.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: handleToEditSign,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('签名', style: TextStyle(fontSize: 14.0),),
                      Row(
                        children: <Widget>[
                          Container(
                            constraints:BoxConstraints(
                              maxWidth: 224,
                            ),
                            child: Text(user['sign'], softWrap: true, style: TextStyle(fontSize: 14.0, color: Color(0xFFA4A4A4)),),
                          ),
                          Icon(Icons.keyboard_arrow_right, color: Color(0xFF999999)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 48.0,
                padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                color: Colors.white,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: handleToEditPass,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('修改密码', style: TextStyle(fontSize: 14.0),),
                      Row(
                        children: <Widget>[
                          Text('已设置', style: TextStyle(fontSize: 14.0, color: Color(0xFFA4A4A4)),),
                          Icon(Icons.keyboard_arrow_right, color: Color(0xFF999999)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
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
      resizeToAvoidBottomPadding: false
    );
  }
}