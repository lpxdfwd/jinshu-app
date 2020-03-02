import 'package:flutter/material.dart';
import 'package:jinshu_app/request/request.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:jinshu_app/utils/normalUtils.dart';
import 'package:jinshu_app/pages/login/login-common.dart';
import 'package:common_utils/common_utils.dart';
import 'package:jinshu_app/pages/login/login-pass.dart';

class LoginCodePage extends StatefulWidget {
  static String phoneNumber;

  LoginCodePage(number) {
    phoneNumber = number;
  }

  @override
  State<StatefulWidget> createState() => LoginCode(phoneNumber);
}

class LoginCode extends State<LoginCodePage> {
  final TextEditingController _inputController = TextEditingController();

  String phoneNumber = '';

  String verifyCode = '';

  bool codeBtnDisable = false;

  Event event = new Event();

  int downTime = 60;

  TimerUtil timer;

  LoginCode(number) {
    phoneNumber = number;
  }

  handleMobileNext() async {
    Map result = await request.post('/passport/login', {'mobile': phoneNumber.trim(), 'verifyCode': verifyCode.trim()});
    print('$result');
    requestDoneShowToast(result, '登录成功', () {
      event.emit('loginSuccess', result);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _inputController.dispose();
    if (timer != null) timer.cancel();
    timer = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    event.on('loginSuccessToHome', handleLoginSuccessToHome);
  }

  handleInputChange(value) {
    setState(() {
      verifyCode = value;
    });
  }

  handleClearValue() {
    _inputController.text = '';
    setState(() {
      verifyCode = '';
    });
  }

  handleLoginSuccessToHome (Map a) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  handleGetCode() {
    if (codeBtnDisable == false) {
      handleSendCode();
      this.setState(() {
        codeBtnDisable = true;
      });
    timer = createDownTimer((time) {
        this.setState(() {
          downTime = time;
        });
      }, () {
      this.setState(() {
        codeBtnDisable = false;
        downTime = 10;
      });
    }, downTime);
    }
  }

  handleSendCode() async {
    Map result = await request.get('/passport/login/code', {'mobile': phoneNumber});
    requestDoneShowToast(result, '', () {});
  }

  handleToPassLogin() {
    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => LoginPassPage(phoneNumber)));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LoginCommon(
      Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 139.0, bottom: 58.0, left: 20.0),
            child: Text('手机号登录', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Color(0xFF000000), decoration: TextDecoration.none),) ,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text('手机号码 $phoneNumber', textAlign: TextAlign.start, style: TextStyle(fontSize: 16.0, color: Color(0xFF000000), decoration: TextDecoration.none),) ,
          ),
          new Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 14.0, top: 30),
            child: new TextField(
              controller: _inputController,
              onChanged: handleInputChange,
              decoration: InputDecoration(
                hintText: '请填写验证码',
                contentPadding: EdgeInsets.all(14),
                suffixIcon:  Container(
                  constraints: BoxConstraints(
                    maxWidth: 120,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 70.0,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: handleGetCode,
                          child: codeBtnDisable
                            ? Text('${downTime}s后重试', textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, color: Color(0xFFA3AFBC), decoration: TextDecoration.none))
                            : Text('获取验证码', textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, color: Color(0xFF3699FF), decoration: TextDecoration.none))
                        ),
                      ),
                      verifyCode != '' ? Container(
                        margin: const EdgeInsets.only(left: 20.0),
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
                          onPressed: handleClearValue,
                        )
                      ) : Text('')
                    ],
                  ),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Color(0xFFF4F9FF),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 30.0, left: 20.0),
            width: double.infinity,
            child: GestureDetector(
              onTap: handleToPassLogin,
              child: Text('密码登录', textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, color: Color(0xFF3699FF), decoration: TextDecoration.none)),
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
              child: Text('登录'),
              onPressed: verifyCode != ''  ? handleMobileNext : null,
            ),
          ),
        ],
      )
    );
  }
}

