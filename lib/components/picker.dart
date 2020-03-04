import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:date_format/date_format.dart';

typedef void EventCallback(int y, int m, int d);

class PickerData extends StatefulWidget {
  final BuildContext ctx;

  final EventCallback callback;

  PickerData(this.ctx, this.callback);

  @override
  State<StatefulWidget> createState() => PickerDataState();
}

enum PICKER_TYPE {
  PICKER_YEAR,
  PICKER_MONTH,
  PICKER_DAY
}

class PickerDataState extends State<PickerData> {
  /*最下年份*/
  int _minYear = 1900;

  /*最大年份*/
  int _maxYear = int.parse(formatDate(DateTime.now(), [yyyy]));

  /*当前选中年份*/
  int _selectYear = int.parse(formatDate(DateTime.now(), [yyyy]));

  /*最小月份*/
  int _minMonth = 1;

  /*最大月份*/
  int _maxMonth = 12;

  /*当前选中月份*/
  int _selectMonth = int.parse(formatDate(DateTime.now(), [mm]));

  /*最小日*/
  int _minDay = 1;

  /*最大日*/
  int _maxDay = 30;

  /*当前选中日*/
  int _selectDay = int.parse(formatDate(DateTime.now(), [dd]));

  /*当前年份*/
  int _currentYear = int.parse(formatDate(DateTime.now(), [yyyy]));

  /*当前月份*/
  int _currentMonth = int.parse(formatDate(DateTime.now(), [mm]));

  /*当前日*/
  int _currentDay = int.parse(formatDate(DateTime.now(), [dd]));

  /*根据年份月份获取当前月有多少天*/
  int getDaysNum(int y, int m) {
    if (m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12) {
      return 31;
    } else if (m == 2) {
      if (((y % 4 == 0) && (y % 100 != 0)) || (y % 400 == 0)) {
        //闰年 2月29
        return 29;
      } else {
        //平年 2月28
        return 28;
      }
    } else {
      return 30;
    }
  }

  handleSelectChange(num, type) {
    setState(() {
      if (type == PICKER_TYPE.PICKER_YEAR) {
        _selectYear = num;
        _maxDay = getDaysNum(_selectYear, _selectMonth);
        if (_selectDay > _maxDay) {
          _selectDay = _maxDay;
        }
      } else if (type == PICKER_TYPE.PICKER_MONTH) {
        _selectMonth = num;
        _maxDay = getDaysNum(_selectYear, _selectMonth);
        if (_selectDay > _maxDay) {
          _selectDay = _maxDay;
        }
      } else if (type == PICKER_TYPE.PICKER_DAY) {
        _selectDay = num;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom:BorderSide(width: 2,color: Color(0xFFFAFAFB))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 14),
                  child: GestureDetector(
                    onTap: () => Navigator.of(widget.ctx).pop(),
                    child: Text('取消', style: TextStyle(fontSize: 14, color: Color(0xFF007AFF))),
                  ),
                ),
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 14),
                  child: GestureDetector(
                    onTap: () => widget.callback(_selectYear, _selectMonth, _selectDay),
                    child: Text('确认', style: TextStyle(fontSize: 14, color: Color(0xFF007AFF))),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumberPicker.integer(
                  initialValue: _selectYear,
                  minValue: _minYear,
                  maxValue: _maxYear,
                  lastStr: '年',
                  itemExtent: 50,
                  infiniteLoop: false,
                  onChanged: (n) => handleSelectChange(n, PICKER_TYPE.PICKER_YEAR)
              ),
              NumberPicker.integer(
                  initialValue: _selectMonth,
                  minValue: _minMonth,
                  maxValue: _maxMonth,
                  lastStr: '月',
                  itemExtent: 50,
                  infiniteLoop: false,
                  onChanged: (n) => handleSelectChange(n, PICKER_TYPE.PICKER_MONTH)
              ),
              NumberPicker.integer(
                  initialValue: _selectDay,
                  minValue: _minDay,
                  maxValue: _maxDay,
                  lastStr: '日',
                  itemExtent: 50,
                  infiniteLoop: false,
                  onChanged: (n) => handleSelectChange(n, PICKER_TYPE.PICKER_DAY)
              ),
            ],
          )
        ],
      ),
    );
  }
}
