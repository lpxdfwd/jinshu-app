import 'package:flutter/material.dart';
import 'package:jinshu_app/request/request.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:jinshu_app/utils/normalUtils.dart';

class EditName extends StatefulWidget {
  final Map user;

  EditName(this.user);

  @override
  State<StatefulWidget> createState() => EditNameState();
}

class EditNameState extends State<EditName> {
  final TextEditingController _inputController = TextEditingController();

  Event event = new Event();

  handleClearValue() {
    _inputController.text = '';
    setState(() {
      nickName = '';
    });
  }

  handleInputChange(value) {
    setState(() {
      nickName = value;
    });
  }

  static String nickName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nickName = widget.user['userName'];
    _inputController.text = nickName;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _inputController.dispose();
  }

  handleUpdateUser() async {
    var res = await request.post('/passport/detail/update', {'id': widget.user['id'], 'userName': nickName});
    requestDoneShowToast(res, '', () {
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
        title: Text('修改昵称', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: handleUpdateUser,
              child: Text('完成', style: TextStyle(fontSize: 14, color: Color(0xFF007AFF))),
            ),
          )
        ]
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 6),
        child: new TextField(
          controller: _inputController,
          onChanged: handleInputChange,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '昵称',
            contentPadding: EdgeInsets.all(14),
            suffixIcon:  nickName.isEmpty ? Text('') : Container(
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
