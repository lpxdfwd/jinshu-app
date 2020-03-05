import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/components/common-methods.dart';
import 'package:jinshu_app/pages/register/register-common.dart';
import 'package:common_utils/common_utils.dart';
import 'package:jinshu_app/utils/normalUtils.dart';
import 'package:jinshu_app/request/request.dart';
import 'package:jinshu_app/pages/register/register-pass.dart';

class RegisterCodePage extends StatefulWidget {
  static String phoneNumber;

  RegisterCodePage(String phone) {
    phoneNumber = phone;
  }

  @override
  State<StatefulWidget> createState() => RegisterCode(phoneNumber);
}

class RegisterCode extends State<RegisterCodePage> {
  SharedPreferences prefs = CommonMethods.prefs;

  String phoneNumber;

  String registerCode = '';

  RegisterCode(String phone) {
    phoneNumber = phone;
  }

  bool codeBtnDisable = true;

  int downTime = 10;

  TimerUtil timer;

  final TextEditingController _inputController = TextEditingController();

  handleInputChange(value) {
    setState(() {
      registerCode = value;
    });
  }

  handleClearValue() {
    _inputController.text = '';
    setState(() {
      registerCode = '';
    });
  }

  handleGetCode() async {
    if (codeBtnDisable == true) return;
    Map result = await request.get('/passport/register/code', {'mobile': phoneNumber});
    requestDoneShowToast(result, '', () {});
    this.setState(() {
      codeBtnDisable = true;
    });
    timer.startTimer();
  }

  handleMobileNext() {
    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => RegisterPassPage(phoneNumber, registerCode)));
  }

  @override
  void initState() {
    super.initState();
    startCodeDownTime();
  }

  startCodeDownTime() {
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

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    _inputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterCommon(
      Column(
        children: <Widget>[
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
                      registerCode != '' ? Container(
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
              child: Text('下一步'),
              onPressed: registerCode != '' ? handleMobileNext : null,
            ),
          )
        ],
      ),
      '输入验证码'
    );
  }
}
