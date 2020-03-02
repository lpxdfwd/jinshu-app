import 'dart:convert';
import 'dart:async';
import 'package:common_utils/common_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

String  queryString(Map params) {
  String str = '?';
  params.forEach((key, value) {
    str += key + '=' + value.toString() + '&';
  });
  return str.substring(0, str.length -1);
}

typedef void TimerCallback(Timer timer);

typedef void TimerOutCallback();

typedef void TimerDownCallback(int tick);

typedef void TimerDoneCallback();

void createTimeInterVal (TimerCallback timerCb, int s) {
  Duration period = Duration(milliseconds: s);
  Timer.periodic(period, (timer) {
    timerCb(timer);
  });
}

void createTimeOut (TimerOutCallback timerCb, int s) {
  Duration period = Duration(milliseconds: s);
  Timer(period, () {
    timerCb();
  });
}

TimerUtil createDownTimer (TimerDownCallback timerCb, TimerDoneCallback doneCb, int s) {
  int totalTime = s * 1000;
  TimerUtil  _timerUtil = new TimerUtil();
  _timerUtil.setInterval(1000);
  _timerUtil.setTotalTime(totalTime);
  _timerUtil.setOnTimerTickCallback((int tick) {
    int _tick = tick;
    timerCb(s - _tick);
    if (_tick == s) {
      _timerUtil.cancel();
      doneCb();
    }
  });
  _timerUtil.startTimer();
  return _timerUtil;
}

typedef void RequestCallback();

void requestDoneShowToast(Map result, String successText, RequestCallback callback) {
  if (result['errno'] == 0) {
    callback();
    if (successText != '') {
      Fluttertoast.showToast(
        msg: successText,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
      );
    }
  } else {
    Fluttertoast.showToast(
      msg: result['frontMsg'],
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 3,
    );
  }
}
