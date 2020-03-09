import 'package:flutter/material.dart';
import 'package:jinshu_app/request/request.dart';
import 'dart:convert' as convert;
import 'package:jinshu_app/components/common-methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:jinshu_app/pages/follow/follow-item.dart';

enum TAB_KEY {
  FOLLOW_ME,
  FOLLOW_OTHER,
}

class FollowScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FollowScreenState();
}

class FollowScreenState extends State<FollowScreen> {
  SharedPreferences prefs = CommonMethods.prefs;

  Map user = convert.jsonDecode(CommonMethods.prefs.getString('userInfo'));

  TAB_KEY tabKey = TAB_KEY.FOLLOW_ME;

  static Event event = new Event();

  bool loading = false;

  List follows = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.handleQueryFollow({});
    event.on('followSuccess', handleQueryFollow);
  }

  handleQueryFollow(a) async {
    if (follows.length == 0) this.setState(() {loading = true;});
    Map res = await request.get('/attention/list', {'userId': user['id'], 'type': tabKey == TAB_KEY.FOLLOW_ME ? 1 : 0});
    List followList = res['data']['users'] ?? [];
    this.setState(() {
      follows = followList;
      loading = false;
    });
  }

  handleSwitchTab(TAB_KEY key) {
    this.setState((){
      tabKey = key;
      this.handleQueryFollow({});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        alignment: const Alignment(0.0, 1.0),
        color: Colors.white,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 32, left: 15, right: 15, bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  height: 28.0,
                  color: Color(0xFFFAFAFB),
                  child: GestureDetector(
                    onTap: (){},
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(right: 5.0),
                          child: Image.asset('images/search-icon.png', width: 16.0, height: 16.0, fit: BoxFit.fill),
                        ),
                        Text('搜索', style: TextStyle(fontSize: 14.0, color: Color(0xFFABB1BD)))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 28,
                  width: 82,
                  margin: const EdgeInsets.only(right: 50),
                  child: GestureDetector(
                    onTap: () => handleSwitchTab(TAB_KEY.FOLLOW_ME),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('关注我的', style: TextStyle(fontSize: 14, color: Color(tabKey == TAB_KEY.FOLLOW_ME ? 0xFF282828: 0xFF4F585B))),
                        tabKey == TAB_KEY.FOLLOW_ME ? Container(
                          width: 40,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Color(0xFF007BFF),
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                        ) : Container()
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 28,
                  width: 82,
                  child: GestureDetector(
                    onTap: () => handleSwitchTab(TAB_KEY.FOLLOW_OTHER),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('我关注的', style: TextStyle(fontSize: 14, color: Color(tabKey == TAB_KEY.FOLLOW_OTHER ? 0xFF282828: 0xFF4F585B))),
                        tabKey == TAB_KEY.FOLLOW_OTHER ? Container(
                          width: 40,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Color(0xFF007BFF),
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                        ) : Container()
                      ],
                    ),
                  ),
                )
              ],
            ),
            loading == true ? Container(
              alignment: Alignment(0, 0.5),
              margin: const EdgeInsets.only(top: 20),
              child: CircularProgressIndicator(),
            ) : Container(),
            Expanded(
              flex: 1,
              child: follows.length > 0 ? ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return FollowItem(user: follows[index], userId: user['id'].toString());
                },
                itemCount: follows.length,
                shrinkWrap: true,
              ) : Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text('暂无数据', style: TextStyle(fontSize: 14, color: Color(0xFFABB1BD))),
              ),
            )
          ],
        ),
      ),
    );
  }
}