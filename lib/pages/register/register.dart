import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/components/common-methods.dart';
import 'package:jinshu_app/pages/register/register-common.dart';
import 'package:jinshu_app/pages/register/register-code.dart';
import 'package:jinshu_app/request/request.dart';
import 'package:jinshu_app/utils/normalUtils.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<RegisterPage> {
  SharedPreferences prefs = CommonMethods.prefs;

  String phoneNumber = '';

  final TextEditingController _inputController = TextEditingController();

  handleInputChange(value) {
    setState(() {
      phoneNumber = value;
    });
  }

  handleClearValue() {
    _inputController.text = '';
    setState(() {
      phoneNumber = '';
    });
  }

  handleMobileNext() async {
    Map result = await request.get('/passport/register/code', {'mobile': phoneNumber});
    requestDoneShowToast(result, '', () {
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => RegisterCodePage(phoneNumber)));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _inputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterCommon(
      Column(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 36.0),
            child: new TextField(
              controller: _inputController,
              onChanged: handleInputChange,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '输入手机号码',
                contentPadding: EdgeInsets.all(14),
                suffixIcon:  phoneNumber != '' ? Container(
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
              child: Text('发送验证码'),
              onPressed: phoneNumber != null && phoneNumber.length == 11 ? handleMobileNext : null,
            ),
          )
        ],
      ),
      '验证手机号'
    );
  }
}
