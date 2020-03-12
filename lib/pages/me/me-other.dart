import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'dart:convert' as convert;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jinshu_app/components/common-methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/request/request.dart';

class MeOtherScreen extends StatefulWidget {
  final Map user;

  final String userId;

  const MeOtherScreen({this.user, this.userId});

  @override
  State<StatefulWidget> createState() => MeOtherState();
}

class MeOtherState extends State<MeOtherScreen> {
  SharedPreferences prefs = CommonMethods.prefs;

  Request request = Request();

  Event event = new Event();

  bool switchValue = true;

  Map user = {};

  int autoNumber = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setState(() {user = widget.user;});
    this.initUser();
  }

  void initUser() async {
    Map res = await request.get('/passport/detail/get', {'userId': widget.user['userId'], 'currentUserId': widget.userId});
    print('${res['data']}@@@@${widget.user['userId']}@@@@${widget.userId}');
    if (res['data'] != null) this.setState(() {user = res['data'];});
  }

  void handleChangeAutoNum(ctx, num) {
    this.setState(() {autoNumber = num;});
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        height: double.infinity,
        color: Colors.white,
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
              top: 34,
              left: 16,
              child: Container(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 30,),
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
                  boxShadow: [BoxShadow(color: Colors.black, offset: Offset(5.0, 5.0), blurRadius: 20.0, spreadRadius: 2.0)],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('年龄', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          Text(user['ageGroup'] ?? '', style: TextStyle(fontSize: 14, color: Color(0xFF4F585B))),
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
                          Text('锦龄', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          Text(user['wuAge'] ?? '0年', style: TextStyle(fontSize: 14, color: Color(0xFF4F585B))),
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
                          Text('自动应答', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
                    switchValue ? Container(
                      width: double.infinity,
                      height: 24,
                      margin: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext ctx) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  )
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () => handleChangeAutoNum(ctx, 5),
                                      child: Container(
                                        width: double.infinity,
                                        height: 52.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(bottom:BorderSide(width: 2,color: Color(0xFFFAFAFB))),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text('5轮', style: TextStyle(fontSize: 14.0), textAlign: TextAlign.center,),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => handleChangeAutoNum(ctx, 10),
                                      child: Container(
                                        height: 52.0,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(bottom:BorderSide(width: 2,color: Color(0xFFFAFAFB)))
                                        ),
                                        alignment: Alignment.center,
                                        child: Text('10轮', style: TextStyle(fontSize: 14.0), textAlign: TextAlign.center,),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('每日最多回答', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text('$autoNumber轮', style: TextStyle(fontSize: 14, color: Color(0xFF4F585B))),
                                Icon(Icons.keyboard_arrow_right, color: Color(0xFFB5B5B5),)
                              ],
                            )
                          ],
                        ),
                      ),
                    ) : Container()
                  ],
                ),
              )
            ),
            Positioned(
              top: 236,
              left: 32,
              child: Container(
                alignment: FractionalOffset(0.5, 0),
                width: 68,
                height: 68,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFF999999), width: 3),
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