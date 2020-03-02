import 'package:flutter/material.dart';
import 'package:jinshu_app/pages/login/login-account.dart';

class RegisterCommon extends StatelessWidget {
  static Widget component;

  static String title;

  RegisterCommon(Widget widget, String t) {
    component = widget;
    title = t;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Positioned(
            child: Image.asset('images/register-bg.png', fit: BoxFit.fitWidth,),
          ),
          Positioned(
            right: 19.0,
            top: 57.0,
            child: Container(
              child: GestureDetector(
                onTap: () {Navigator.of(context).pushReplacementNamed('/login');},
                child: Image.asset('images/close-icon.png', width: 16.0, height: 16.0, fit: BoxFit.fill,),
              ),
            ),
          ),

          Align(
            alignment: FractionalOffset(0.5, 0.95),
            child: Container(
              child: GestureDetector(
                onTap: () {Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> LoginAccountPage()));},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 4.0),
                      child:  new Text('已有账户，去登录', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF171725), decoration: TextDecoration.none),),
                    ),
                    Image.asset('images/right-arrow-icon.png', width: 15.0, height: 19.0, fit: BoxFit.fitWidth,)
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 146.0, left: 20.0, bottom: 58.0),
                child: Text(title, textAlign: TextAlign.start, style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
              ),
              component
            ],
          )
        ],
      ),
    );
  }
}
