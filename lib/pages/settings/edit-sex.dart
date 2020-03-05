import 'package:flutter/material.dart';
import 'package:jinshu_app/request/request.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:jinshu_app/utils/normalUtils.dart';

class EditSex extends StatefulWidget {
  final Map user;

  EditSex(this.user);

  @override
  State<StatefulWidget> createState() => EditSexState();
}

class EditSexState extends State<EditSex> {
  Event event = new Event();

  handleChangeValue(value) {
    setState(() {
      sex = value;
    });
  }

  static int sex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sex = widget.user['sex'];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  handleUpdateUser() async {
    if (sex == null) return;
    var res = await request.post('/passport/detail/update', {'id': widget.user['id'], 'sex': sex});
    requestDoneShowToast(res, '修改成功', () {
      event.emit('queryUser', {});
      Navigator.pop(context);
    });
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
            title: Text('修改性别', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black)),
            actions: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 14),
                child: GestureDetector(
                  onTap: handleUpdateUser,
                  child: Text('完成', style: TextStyle(fontSize: 14, color: Color(sex == null ? 0xFF909399 : 0xFF007AFF))),
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
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => handleChangeValue(1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('images/sex-man-icon.png', width: 16, height: 16, fit: BoxFit.fill,),
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          child: Text('男', style: TextStyle(fontSize: 14)),
                        )
                      ],
                    ),
                    sex == 1 ? Image.asset('images/select-sex.png', width: 20, height: 20, fit: BoxFit.fill,) : Text('')
                  ],
                ),
              ),
            ),
            Container(
              height: 48,
              padding: const EdgeInsets.only(left: 14, right: 14),
              color: Colors.white,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => handleChangeValue(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('images/sex-woman-icon.png', width: 16, height: 16, fit: BoxFit.fill,),
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          child: Text('女', style: TextStyle(fontSize: 14)),
                        )
                      ],
                    ),
                    sex == 0 ? Image.asset('images/select-sex.png', width: 20, height: 20, fit: BoxFit.fill,) : Text('')
                  ],
                ),
              ),
            )
          ],
        ),
        resizeToAvoidBottomPadding: false
    );
  }
}
