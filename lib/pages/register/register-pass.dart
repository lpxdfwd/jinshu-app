import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/components/common-methods.dart';
import 'package:jinshu_app/pages/register/register-common.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:jinshu_app/utils/normalUtils.dart';
import 'package:jinshu_app/request/request.dart';

class RegisterPassPage extends StatefulWidget {
  static String phoneNumber;

  static String phoneCode;

  RegisterPassPage(String phone, String code) {
    phoneNumber = phone;
    phoneCode = code;
  }

  @override
  State<StatefulWidget> createState() => RegisterPass(phoneNumber, phoneCode);
}

class RegisterPass extends State<RegisterPassPage> {
  SharedPreferences prefs = CommonMethods.prefs;

  String phoneNumber;

  String phoneCode;

  String password = '';

  String passwordConfirm = '';

  Request request = Request();

  Event event = new Event();

  RegisterPass(String phone, String code) {
    phoneNumber = phone;
    phoneCode = code;
  }

  final TextEditingController passCtrl = TextEditingController();

  final TextEditingController passConfirmCtrl = TextEditingController();

  handleInputChange(value, status) {
    setState(() {
      if (status == 'first') {
        password = value;
      } else {
        passwordConfirm = value;
      }
    });
  }

  handleClearValue(status) {
    setState(() {
      if (status == 'first') {
        passCtrl.text = '';
        password = '';
      } else {
        passConfirmCtrl.text = '';
        passwordConfirm = '';
      }
    });
  }

  handleMobileNext() async {
    print('$phoneNumber,$phoneCode,$password,$passwordConfirm');
    Map result = await request.post('/passport/register', {'mobile': phoneNumber.trim(), 'verifyCode': phoneCode.trim(), 'password': password, 'confirm': passwordConfirm});
    requestDoneShowToast(result, '注册成功，自动登录', () {
      event.emit('loginSuccess', result);
    });
  }

  @override
  void initState() {
    super.initState();
    event.on('loginSuccessToHome', handleLoginSuccessToHome);
  }

  handleLoginSuccessToHome(Map a) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void dispose() {
    super.dispose();
    passCtrl.dispose();
    passConfirmCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterCommon(
      Column(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 14.0),
            child: new TextField(
              controller: passCtrl,
              onChanged: (value) {handleInputChange(value, 'first');},
              obscureText: true,
              decoration: InputDecoration(
                hintText: '请输入密码',
                contentPadding: EdgeInsets.all(14),
                suffixIcon:  password != '' ? Container(
                  width: 20.0,
                  height: 20.0,
                  child: new IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0.0),
                    iconSize: 18.0,
                    icon: Icon(Icons.cancel),
                    color: Color(0x99999999),
                    onPressed: () {handleClearValue('first');},
                  )
                ) : Text(''),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Color(0xFFF4F9FF),
              ),
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 36.0),
            child: new TextField(
              controller: passConfirmCtrl,
              onChanged: (value) {handleInputChange(value, 'confirm');},
              obscureText: true,
              decoration: InputDecoration(
                hintText: '请再次输入密码',
                contentPadding: EdgeInsets.all(14),
                suffixIcon:  passwordConfirm != '' ? Container(
                  width: 20.0,
                  height: 20.0,
                  child: new IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0.0),
                    iconSize: 18.0,
                    icon: Icon(Icons.cancel),
                    color: Color(0x99999999),
                    onPressed: () {handleClearValue('confirm');},
                  )
                ) : Text(''),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
                filled: true,
                fillColor: Color(0xFFF4F9FF),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: MaterialButton(
              disabledColor: Color(0xFFDCDFE6),
              disabledTextColor: Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              minWidth: double.infinity,
              height: 48.0,
              color: Color(0xFF3699FF),
              textColor: Colors.white,
              child: Text('完成'),
              onPressed: password != '' && passwordConfirm != '' && passwordConfirm == password ? handleMobileNext : null,
            ),
          )
        ],
      ),
        '设置登录密码'
    );
  }
}
