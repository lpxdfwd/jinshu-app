import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:jinshu_app/utils/socketUtils.dart';
import 'package:jinshu_app/components/bottomNav.dart';
import 'package:jinshu_app/pages/login/login.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/request/request.dart';
import 'package:jinshu_app/utils/normalUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:jinshu_app/components/common-methods.dart';

void main() async {
  //强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        platform: TargetPlatform.iOS,
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => BottomNavigationWidget(),
      },
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  Event event = new Event();

  SharedPreferences prefs;

  bool loading = false;

  bool isLogin = false;

  Timer socketTimer;

  Map userInfo;

  Request request;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    event.emit('setContactType', {'type': 'loading'});
    socketInit();
    prefsInit();
    event.on('loginSuccess', handleLoginSuccess);
    event.on('refreshContacts', handleFormatContacts);
    event.on('exitLogin', handleExitLogin);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:// 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed:// 应用程序可见，前台
        await socketInit();
        handleConnectSocket();
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        event.emit('checkBackstage');
        event.emit('setContactType', {'type': 'loading'});
        break;
      case AppLifecycleState.suspending: // 申请将暂时暂停
        break;
    }
  }

  void prefsInit () async {
    prefs = await SharedPreferences.getInstance();
    CommonMethods(prefs);
    request = Request(prefs);
    bool loginStatus = prefs.getBool('isLogin');
    setState(() {
      loading = true;
      isLogin = loginStatus ?? false;
    });
    if (loginStatus == true) {
      userInfo = convert.jsonDecode(prefs.getString('userInfo'));
      handleQueryContacts();
      handleConnectSocket();
    }
  }

  void handleLoginSuccess(Map user) async {
    dynamic userRes = await request.get('/passport/detail/get', {'userId': user['data']['id'], 'currentUserId': user['data']['id']});
    userInfo = userRes['data'];
    await handleQueryContacts();
    handleConnectSocket();
    await prefs.setBool('isLogin', true);
    dynamic token = await request.post('/user/getToken', {'userId': user['data']['id'], 'timestamp': DateTime.now().millisecondsSinceEpoch});
    userInfo['token'] = token['data']['token'];
    await prefs.setString('userInfo', convert.jsonEncode(userInfo));
    event.emit('loginSuccessToHome', {});
  }

  handleFormatContacts () {
    
  }

  handleQueryContacts() async {
    String contactsString = prefs.getString('contacts');
    if (contactsString == null) {
      Map result = await request.get('/passport/contacts/list', {'userId': userInfo['id']});
      if (result != null && result['data'] != null) {
        Map contacts = result['data'];
        List exclusiveRobots = contacts['exclusiveRobots'];
        List contactUsers = contacts['contacts'];
//        await prefs.setString('contacts', convert.jsonEncode(exclusiveRobots.followedBy(contactUsers).toList()));
        await prefs.setString('contacts', convert.jsonEncode(contactUsers));
        await prefs.setString('rootOwn', convert.jsonEncode(exclusiveRobots[0]));
      }
      print('请求联系人接口');
    }
  }

//  void handleStartPullMsg() {
//    if(socketTimer != null) {
//      socketTimer.cancel();
//    }
//    createTimeInterVal((timer) {
//      socketTimer = timer;
//      SocketUtils.handlePullNewMsg({
//        'userId': userInfo['id'],
//        'token': userInfo['token'],
//        'tokenTimestamp': DateTime.now().millisecondsSinceEpoch
//      });
//    }, 1000);
//  }

  handleConnectSocket() {
    print('触发socket链接事件');
    SocketUtils.handleConnect({
      'wuyanSessionId': prefs.getString('wuyanSessionId'),
      'senderId': userInfo['id'],
      'app_os': 'android',
      'app_type': 'phone'
    });
  }

  handleExitLogin (a) async {
    if(socketTimer != null) {
      socketTimer.cancel();
    }
    await prefs.setBool('isLogin', false);
  }


  AlertDialog dialog = new AlertDialog(
    content: new Text(
      "Hello",
      style: new TextStyle(fontSize: 30.0, color: Colors.red),
    ),
  );

//  _socketStatus(dynamic data) {
//    print("Socket status: " + data);
//  }

  // This widget is the root of your application.
  void socketInit() async {
    SocketUtils manager = new SocketUtils("http://112.124.202.207:9098");
    manager.connect();
//    SocketIO socketIO = SocketIOManager().createSocketIO("http://127.0.0.1:3000", "/", query: "", socketStatusCallback: _socketStatus);
//
//    //call init socket before doing anything
//    socketIO.init();
//
//    //connect socket
//    socketIO.connect();
  }

  @override
  Widget build(BuildContext context) {
    if (loading == false) return new Container();
    return isLogin ? BottomNavigationWidget() : LoginPage();
  }
}
