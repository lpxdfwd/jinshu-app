import 'package:flutter/material.dart';
import 'package:jinshu_app/request/request.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:jinshu_app/utils/normalUtils.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditMobile extends StatefulWidget {
  final Map user;

  EditMobile(this.user);

  @override
  State<StatefulWidget> createState() => EditMobileState();
}

class EditMobileState extends State<EditMobile> {
  Event event = new Event();

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController codeController = TextEditingController();

  handleChangeValue(String type, String value) {
    setState(() {
      switch(type) {
        case 'mobile':
          mobile = value;
          break;
        case 'code':
          code = value;
          break;
      }
    });
  }

  handleClearValue(String type) {
    setState(() {
      switch(type) {
        case 'mobile':
          mobile = '';
          mobileController.text = '';
          break;
        case 'code':
          code = '';
          codeController.text = '';
          break;
      }
    });
  }

  static String mobile = '';

  static String code = '';

  bool codeBtnDisable = false;

  int downTime = 10;

  TimerUtil timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    // TODO: implement dispose
    super.dispose();
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    mobileController.dispose();
    codeController.dispose();
  }

  handleUpdateUser() async {
    if (mobile.isEmpty || code.isEmpty) return;
    var res = await request.post('/passport/login/modify/mobile', {'mobile': mobile, 'verifyCode': code, 'id': widget.user['id']});
    requestDoneShowToast(res, '修改成功', () {
      event.emit('queryUser', {});
      Navigator.pop(context);
    });
  }

  handleGetCode() async {
    if (codeBtnDisable == true) return;
    if (mobile == '') {
      Fluttertoast.showToast(
        msg: '请输入手机号',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
      );
      return;
    }
    Map result = await request.get('/passport/login/modify/mobile/code', {'mobile': mobile, 'userId': widget.user['id']});
    requestDoneShowToast(result, '', () {});
    this.setState(() {
      codeBtnDisable = true;
    });
    if (timer == null) {
      startCodeDownTime();
    } else {
      timer.startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(
                color: Colors.black
            ),
            title: Text('绑定新的手机号', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black)),
            actions: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 14),
                child: GestureDetector(
                  onTap: handleUpdateUser,
                  child: Text('完成', style: TextStyle(fontSize: 14, color: Color((mobile.isEmpty || code.isEmpty) ? 0xFF909399 : 0xFF007AFF))),
                ),
              )
            ]
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 14, right: 14),
              color: Colors.white,
              margin: const EdgeInsets.only(top: 6.0, bottom: 2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 36),
                    child: Text('手机号', style: TextStyle(fontSize: 14)),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: mobileController,
                      onChanged: (value) => handleChangeValue('mobile', value),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '手机号',
                        hintStyle: TextStyle(fontSize: 14, color: Color(0xFFA4A4A4)),
                        contentPadding: EdgeInsets.all(14),
                        suffixIcon:  mobile.isEmpty ? Text('') : Container(
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
                              onPressed: () => handleClearValue('mobile'),
                            )
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 48,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 14, right: 14),
              color: Colors.white,
              margin: const EdgeInsets.only(top: 6.0, bottom: 2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 36),
                    child: Text('验证码', style: TextStyle(fontSize: 14)),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: codeController,
                      onChanged: (value) => handleChangeValue('code', value),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '验证码',
                        hintStyle: TextStyle(fontSize: 14, color: Color(0xFFA4A4A4)),
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
                              code != '' ? Container(
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
                                    onPressed: () => handleClearValue('code'),
                                  )
                              ) : Text('')
                            ],
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        resizeToAvoidBottomPadding: false
    );
  }
}
