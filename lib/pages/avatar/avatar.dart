import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jinshu_app/components/common-methods.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jinshu_app/pages/avatar/crop-image.dart';
import 'package:jinshu_app/request/request.dart';

class AvatarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AvatarState();
}

class AvatarState extends State<AvatarPage> {
  SharedPreferences prefs = CommonMethods.prefs;

  Request request = Request();

  Event event = new Event();

  Map user = convert.jsonDecode(CommonMethods.prefs.getString('userInfo'));

  File photoImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  handleGetImage(ctx) async {
    await ImagePicker.pickImage(source: ImageSource.camera)
        .then((image) => cropImage(image));
    Navigator.of(ctx).pop();
  }

  handleChooseImage(ctx) async {
    await ImagePicker.pickImage(source: ImageSource.gallery)
        .then((image) => cropImage(image));
    Navigator.of(ctx).pop();
  }

  void cropImage(File originalImage) async {
    if (originalImage != null) {
      File result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CropImageRoute(originalImage)));
      if (result == null) {
        print('上传失败');
      } else {
        FormData data = new FormData.fromMap({
          "file": MultipartFile.fromFileSync(result.path, filename: "photo.jpg"),
          "userId": user['id'],
        });
        var res = await request.file('passport/head/upload', data);
        print('上传成功$res');
        setState(()  {
          photoImage = result;
        });
      }
    }
  }

  Widget getAvatarImg() {
    if (photoImage != null) {
      return Image.file(photoImage);
    } else {
      return user['headUrl'] == null ? new Image.asset('images/default-pic.png', width: double.infinity, fit: BoxFit.cover) : CachedNetworkImage(
        imageUrl: 'http://118.31.126.46:8080/' + user['headUrl'],
        fit: BoxFit.fitWidth,
        width: double.infinity,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text('个人头像', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (BuildContext ctx) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          onTap: () => handleGetImage(ctx),
                          child: Container(
                            width: double.infinity,
                            height: 52.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(bottom:BorderSide(width: 2,color: Color(0xFFFAFAFB))),
                            ),
                            alignment: Alignment.center,
                            child: Text('拍照', style: TextStyle(fontSize: 14.0), textAlign: TextAlign.center,),
                          ),
                        ),
                        InkWell(
                          onTap: () => handleChooseImage(ctx),
                          child: Container(
                            height: 52.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(bottom:BorderSide(width: 2,color: Color(0xFFFAFAFB)))
                            ),
                            alignment: Alignment.center,
                            child: Text('从手机相册选择', style: TextStyle(fontSize: 14.0), textAlign: TextAlign.center,),
                          ),
                        ),
                        InkWell(
                          onTap: () {Navigator.of(ctx).pop();},
                          child: Container(
                            height: 52.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(bottom:BorderSide(width: 6,color: Color(0xFFFAFAFB)))
                            ),
                            alignment: Alignment.center,
                            child: Text('保存图片', style: TextStyle(fontSize: 14.0), textAlign: TextAlign.center,),
                          ),
                        ),
                        InkWell(
                          onTap: () {Navigator.of(ctx).pop();},
                          child: Container(
                            color: Colors.white,
                            height: 52.0,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: GestureDetector(
                              child: Text('取消', style: TextStyle(fontSize: 14.0), textAlign: TextAlign.center,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              );
            },
          )
        ]
      ),
      body: Container(
        color: Colors.black,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getAvatarImg()
          ],
        ),
      ),
    );
  }
}