import 'package:flutter/material.dart';
import 'package:jinshu_app/pages/login/login-account.dart';
import 'package:jinshu_app/pages/register/register.dart';

class LoginHomePage extends StatelessWidget {

  handleToRegisterPage(context) {
    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 85.0),
            child: Image.asset('images/login-bg.png', fit: BoxFit.fitWidth,),
          ),
          Container(
            margin: const EdgeInsets.only(top: 52.0, left: 20.0, right: 20.0),
            child: new MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              minWidth: double.infinity,
              height: 48.0,
              color: Color(0xFF3699FF),
              textColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('images/mobile-login-icon.png', width: 11.0, height: 18.0, fit: BoxFit.fitWidth,),
                  Container(
                    margin: const EdgeInsets.only(left: 4.0),
                    child: new Text('手机号登录'),
                  )
                ],
              ),
              onPressed: () {
                Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> LoginAccountPage()));
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 75.0),
            child: GestureDetector(
              onTap: () => handleToRegisterPage(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 4.0),
                    child:  new Text('立即注册', style: TextStyle(fontSize: 16.0, color: Color(0xFF171725), decoration: TextDecoration.none),),
                  ),
                  Image.asset('images/right-arrow-icon.png', width: 15.0, height: 19.0, fit: BoxFit.fitWidth,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
