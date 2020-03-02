import 'package:flutter/material.dart';
import 'package:jinshu_app/pages/login/login-common.dart';
import 'package:jinshu_app/pages/login/login-pass.dart';

class LoginAccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginAccount();
}

class LoginAccount extends State<LoginAccountPage> {
  final TextEditingController _inputController = TextEditingController();

  String phoneNumber = '';

  handleMobileNext() {
    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => LoginPassPage(phoneNumber)));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _inputController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
            new Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
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
                child: Text('下一步'),
                onPressed: phoneNumber != null && phoneNumber.length == 11 ? handleMobileNext : null,
              ),
            ),
          ],
        )
    );
  }
}

