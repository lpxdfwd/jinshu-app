import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jinshu_app/components/common-methods.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:jinshu_app/pages/me/me-other.dart';

typedef void DeleteContactBack(int id);

class FollowItem extends StatelessWidget {
  final Map user;

  final String userId;

  static Event event = new Event();

  const FollowItem({Key key, this.user, this.userId}) : super(key: key);

  handleFollowBack() {
    event.emit('followSuccess', {});
  }

  handleToUserPage(context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context)=>  MeOtherScreen(user: user, userId: userId)));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () =>handleToUserPage(context),
      child: Container(
        height: 58,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 54,
              height: 54,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(27)),
                border: Border.all(color: Color(0xFF007BFF), width: 2)
              ),
              child: GestureDetector(
                onTap: (){},
                child: ClipOval(
                  child: user['headUrl'] == null ? new Image.asset('images/default-pic.png', width: 50, height: 50, fit: BoxFit.fill) : CachedNetworkImage(
                    imageUrl: 'http://118.31.126.46:8080/' + user['headUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  )
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(user['userName'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Text('浙江 杭州', style: TextStyle(fontSize: 14, color: Color(0xFFABB1BD)),),
                  )
                ],
              ),
            ),
            Container(
              width: 54,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: user['attentionStatus'] != 1 ? const LinearGradient(
                      colors: [Color(0xFF007BFF), Color(0xFF24E3FF)]) : null,
                  color: user['attentionStatus'] == 1 ? Color(0xFFF3F3F3) : null,
                  borderRadius: BorderRadius.all(Radius.circular(27))
              ),
              child: GestureDetector(
                onTap: () => CommonMethods().handleToggleFollow(user['attentionStatus'] == 1 ? 'cancel' : 'add', userId.toString(), user['userId'].toString(), handleFollowBack),
                child: Text(user['attentionStatus'] == 1 ? '已关注' : '关注', style: TextStyle(color: user['attentionStatus'] == 1 ? Color(0xFF92929D) : Colors.white, fontSize: 12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}