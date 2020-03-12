import 'package:flutter/material.dart';
import 'package:jinshu_app/request/request.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:jinshu_app/utils/normalUtils.dart';

class EditSign extends StatefulWidget {
  final Map user;

  EditSign(this.user);

  @override
  State<StatefulWidget> createState() => EditSignState();
}

class EditSignState extends State<EditSign> {
  final TextEditingController _inputController = TextEditingController();

  Event event = new Event();

  Request request = Request();

  handleInputChange(value) {
    setState(() {
      sign = value;
    });
  }

  static String sign = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sign = widget.user['sign'];
    _inputController.text = sign;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _inputController.dispose();
  }

  handleUpdateUser() async {
    if (sign.isEmpty) return;
    var res = await request.post('/passport/detail/update', {'id': widget.user['id'], 'sign': sign});
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
        title: Text('修改签名', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: handleUpdateUser,
              child: Text('完成', style: TextStyle(fontSize: 14, color: Color(sign.isEmpty ? 0xFF909399 : 0xFF007AFF))),
            ),
          )
        ]
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 6),
        child: new TextField(
          controller: _inputController,
          onChanged: handleInputChange,
          maxLines: 3,
          style: TextStyle(fontSize: 14, color: Color(0xFFA1A4A3)),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: '个性签名',
            contentPadding: EdgeInsets.all(14),
            suffixIcon:  Container(
              margin: const EdgeInsets.only(top: 36),
              child: Text('${30 - sign.length}/30', style: TextStyle(fontSize: 12, color: Color(0xFF98A6A2)),)
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
      resizeToAvoidBottomPadding: false
    );
  }
}
