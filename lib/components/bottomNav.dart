import 'package:flutter/material.dart';
import 'package:jinshu_app/pages/home/home.dart';
import 'package:jinshu_app/pages/follow/follow.dart';
import 'package:jinshu_app/pages/me/me.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:jinshu_app/components/common-methods.dart';

class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 1;

  List<Widget> pages = List<Widget>();

  SharedPreferences prefs = CommonMethods.prefs;

  @override
  void initState() {
    super.initState();
    pages
      ..add(HomeScreen())
      ..add(FollowScreen())
      ..add(MeScreen());
  }

  Color getTextColor(int index) {
    return index == _currentIndex ? Color(0xFF0890FF) : Color(0xFF92929D);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: pages[_currentIndex - 1],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('images/tab-me.png', width: 26, height: 20, fit: BoxFit.fill),
            activeIcon: Image.asset('images/tab-me.png', width: 26, height: 20, fit: BoxFit.fill),
            title: new Text(
              '我',
              style: TextStyle(color: getTextColor(0)),
            )),
          BottomNavigationBarItem(
            icon: Image.asset('images/tab-jinshu.png', width: 26, height: 20, fit: BoxFit.fill),
            activeIcon: Image.asset('images/tab-jinshu-active.png', width: 26, height: 20, fit: BoxFit.fill),
            title: new Text(
              '锦书',
              style: TextStyle(color: getTextColor(1)),
            )
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/tab-follow.png', width: 22, height: 20, fit: BoxFit.fill),
            activeIcon: Image.asset('images/tab-follow-active.png', width: 22, height: 20, fit: BoxFit.fill),
            title: new Text(
              '关注',
              style: TextStyle(color: getTextColor(2)),
            )),
          BottomNavigationBarItem(
            icon: Image.asset('images/tab-settings.png', width: 21, height: 20, fit: BoxFit.fill),
            activeIcon: Image.asset('images/tab-settings-active.png', width: 21, height: 20, fit: BoxFit.fill),
            title: new Text(
              '设置',
              style: TextStyle(color: getTextColor(3)),
            ))
        ],
        currentIndex: _currentIndex,
        onTap: (int i) {
          if (i != 0) {
            setState(() {
              _currentIndex = i;
            });
          } else {
            Map rootOwn = convert.jsonDecode(prefs.getString('rootOwn'));
            CommonMethods(prefs).handleJoinChat(context, rootOwn);
          }
        },
      ),
    );
  }
}