import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends PreferredSize {
  String connectType;

  HomeAppBar(this.connectType);

  String getTitleText () {
    switch(connectType) {
      case 'loading':
        return '连接...';
      case 'success':
        return '锦书';
      default:
        return '未连接';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      backgroundColor: Color(0xFFFFFFFF),
      elevation: 0,
      title: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 80.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(getTitleText(), style: TextStyle(fontSize: 18.0, color: Color(0xFF282828))),
                  Image.asset('images/tab-jinshu-icon.png', width: 34.0, height: 7.0, fit: BoxFit.fill)
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 257.0,
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
            )
          ],
        ),
      ),
    );
  }
}