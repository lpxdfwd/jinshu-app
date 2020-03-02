import 'package:flutter/material.dart';
import 'package:jinshu_app/request/request.dart';

class FollowScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FollowScreenState();
}

class FollowScreenState extends State<FollowScreen> {
  Map userData = {};

  handleLogin() async {
    Map result = await request.get('/passport/contacts/list', {'userId': 8});
//    print('$result');
    if (result != null) {
      setState(() {
        userData = result['data'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleLogin();
  }

  Widget renderContacts() {
    List<dynamic> dataList = userData['contacts'];
    List<Widget> items = [];
    if (dataList != null) {
      dataList.forEach((item) {
        if (item['userName'] != null) {
          items.add(
              new Row(
                  children: <Widget>[
                    new Text(item['userName'])
                  ]
              )
          );
        }
      });
    }
    return new Column(
        children: items
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Follow'),
      ),
      body: new Center(
        child: renderContacts(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleLogin,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}