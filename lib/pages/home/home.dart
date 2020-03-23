import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:jinshu_app/components/common-methods.dart';
import 'package:jinshu_app/pages/home/contacts-item.dart';
import 'package:jinshu_app/pages/home/home-appbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  SharedPreferences prefs;

  List userData = [];

  Map user;

  Event event = new Event();

  String connectType = 'success';


  handleQueryContacts(data) async {
    userData = convert.jsonDecode(prefs.getString('contacts'));
    List items = [];

    if (userData != null) {
      userData.forEach((item) {
        if (item['userName'] != null) {
          items.add(item);
        }
      });
    }
    setState(() {
      userData = items;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prefsInit();
    event.on('refreshContacts', handleQueryContacts);
    event.on('connectSuccess', handleConnectSuccess);
    event.on('connectError', handleConnectError);
    event.on('setContactType', handleSetContactType);
  }

  handleConnectSuccess(a) {
    this.setState(() {
      connectType = 'success';
    });
  }

  handleConnectError(a) {
    this.setState(() {
      connectType = 'error';
    });
  }

  handleSetContactType(a) {
    this.setState(() {
      connectType = a['type'];
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  void prefsInit () async {
    prefs = await SharedPreferences.getInstance();
    String userString = prefs.getString('userInfo');
    if (userString == null) {
      event.emit('exitLogin', {});
    } else {
      user  = convert.jsonDecode(userString);
    }
    handleQueryContacts({});
  }

  handleJoinChat(Map item) => CommonMethods(prefs).handleJoinChat(context, item);

  handleDeleteItem(int id) {
    List userList = [];
    userData.forEach((item) {
      if (item['id'] != id) {
        userList.add(item);
      }
    });
    setState(() {
      userData = userList;
    });
//    prefs.setString('contacts', convert.jsonEncode(userList));
  }

//  CustomRouteSlide(ChatScreen(prefs))

  @override
  Widget build(BuildContext context) {
    if (userData == null || userData.length == 0) return new Container();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HomeAppBar(connectType),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ContactsItem(user: userData[index], onDeleteItem: handleDeleteItem);
          },
          itemCount: userData.length,
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {handleQueryContacts({});},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}