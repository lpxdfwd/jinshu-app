import 'package:flutter/material.dart';
import 'package:jinshu_app/pages/register/register.dart';
import 'package:jinshu_app/pages/edit-pass/edit-pass.dart';

class LoginCommon extends StatelessWidget {
  static Widget component;

  LoginCommon(Widget widget) {
    component = widget;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
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
          Positioned(
            child: Image.asset('images/login-top-bg.png', width: 148.0, height: 199.0, fit: BoxFit.fill,),
          ),
          Align(
            alignment: FractionalOffset(0.5, 0.95),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 18.0),
                  child: GestureDetector(
                    onTap: () {Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => EditPassPage()));},
                    child: Text('忘记密码', style: TextStyle(fontSize: 14.0,color: Color(0xFF171725), decoration: TextDecoration.none),),
                  ),
                ),
                Container(
                  width: 1.0,
                  height: 12.0,
                  color: Color(0xFF979797),
                  margin: const EdgeInsets.only(right: 18.0),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));},
                    child: Text('立即注册', style: TextStyle(fontSize: 14.0,color: Color(0xFF171725), decoration: TextDecoration.none),),
                  ),
                )
              ],
            ),
          ),
          component
        ],
      ),
    );
  }
}
