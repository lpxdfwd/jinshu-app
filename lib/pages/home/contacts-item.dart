import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jinshu_app/components/common-methods.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef void DeleteContactBack(int id);

class ContactsItem extends StatelessWidget {
  final Map user;

  final DeleteContactBack onDeleteItem;

  const ContactsItem({Key key, this.user, this.onDeleteItem}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.red,
          iconWidget: Text('删除', style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14.0),),
          onTap: () {onDeleteItem(user['id']);},
        ),
      ],
      child: InkWell(
          onTap: () => CommonMethods().handleJoinChat(context, user),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
            color: Color(0xFFFFFFFF),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(left: 12.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(user['userName'], style: TextStyle(fontSize: 16.0, color: Color(0xFF282828))),
                                  Text('2分钟前', style: TextStyle(fontSize: 12.0, color: Color(0xFFABB1BD)))
                                ],
                              ),
                              Text(user['lastMsg'] ?? '暂无消息', style: TextStyle(fontSize: 14.0, color: Color(0xFFABB1BD)))
                            ]
                        ),
                      )
                  )
                ]
            ),
          )
      ),
    );
  }
}