import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/pages/swiper/first-swiper.dart';
import 'package:jinshu_app/components/common-methods.dart';
import 'package:jinshu_app/pages/login/login-home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  SharedPreferences prefs = CommonMethods.prefs;

  bool showLogin;

  @override
  void initState() {
    super.initState();
    setState(() {
      showLogin = prefs.getBool('showLogin') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLogin == false ? FirstSwiperPage() : LoginHomePage();
  }
}
