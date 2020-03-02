import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:jinshu_app/components/common-methods.dart';
import 'package:jinshu_app/pages/login/login.dart';

class FirstSwiperPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FirstSwiper();
}

class FirstSwiper extends State<FirstSwiperPage> {
  static List<Widget> swiperList = [];

  FirstSwiper() {
    createSwiperList();
  }

  static SwiperController control = new SwiperController();

  createSwiperList () {
    swiperList
      ..add(
        SwiperItem(imgPath: 'images/swiper-1.png', control: control, isConfirm: false)
      )
      ..add(
        SwiperItem(imgPath: 'images/start-bg.png', control: control, isConfirm: false)
      )
      ..add(
        SwiperItem(imgPath: 'images/swiper-2.png', control: control, isConfirm: true)
      );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return swiperList[index];
        },
        itemCount: 3,
        loop: false,
        autoplay: false,
        onIndexChanged: (int index) {},
        pagination: new SwiperPagination(
            margin: new EdgeInsets.all(5.0)
        ),
        controller: control
      ),
    );
  }
}

class SwiperItem extends StatelessWidget {
  final String imgPath;

  final bool isConfirm;

  final SwiperController control;

//  SwiperItem(a, b, c) {
//    imgPath = a;
//    control = b;
//    isConfirm = c;
//  }

  void handleNext(context) {
    if (isConfirm == true) {
      CommonMethods.prefs.setBool('showLogin', true);
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      control.next();
    }
  }

  const SwiperItem({Key key, this.imgPath, this.control, this.isConfirm}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        alignment: const Alignment(0.0, 1.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imgPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Align (
          alignment: FractionalOffset(0.5, 0.92),
          child: Container(
            child: GestureDetector(
              onTap: () {handleNext(context);},
            ),
            width: isConfirm ? 103.0 : 92.0,
            height: 31.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: isConfirm ? AssetImage("images/swiper-confirm-btn.png") : AssetImage("images/swiper-btn.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
    );
  }
}