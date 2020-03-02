import 'package:flutter/material.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/pages/settings/settings.dart';

class MeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MeScreenState();
}

class MeScreenState extends State<MeScreen> {
  SharedPreferences prefs;

  Event event = new Event();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prefsInit();
  }

  void prefsInit () async {
    prefs = await SharedPreferences.getInstance();
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
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleToSettings,
        tooltip: 'Increment',
        child: Text(
          '账号安全设置'
        )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}