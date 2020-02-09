import 'package:flutter/material.dart';
import 'package:roller_list/roller_list.dart';

class DateTimeSelector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DateTimeSelectorState();
  }
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  static const TIME_ITEM_WIDTH = 80.0;
  TimeOfDay time;
  String selectedMonth = "February";
  int selectedDay = 10;
  static const MONTHS = {
    "January": 31,
    "February": 29,
    "March": 31,
    "April": 30,
    "May": 31,
    "June": 30,
    "July": 31,
    "August": 31,
    "September": 30,
    "October": 31,
    "November": 30,
    "December": 31
  };

  final List<Widget> months = MONTHS.keys
      .map((month) => Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              month,
              textScaleFactor: 1.3,
              textAlign: TextAlign.center,
            ),
          ))
      .toList();

  @override
  void initState() {
    DateTime now = DateTime.now();
    time = new TimeOfDay(hour: now.hour, minute: now.minute);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Clock inspiration',
          textScaleFactor: 1.5,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 16.0,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          RollerList(
            length: 24,
            builder: (BuildContext context, int index) {
              int hour = index % 24;
              return Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  hour.toString().padLeft(2, '0'),
                  textScaleFactor: 1.3,
                  textAlign: TextAlign.center,
                ),
              );
            },
            width: TIME_ITEM_WIDTH,
            onSelectedIndexChanged: _changeHours,
            initialIndex: time.hour,
          ),
          SizedBox(
            width: 2.0,
          ),
          RollerList(
            length: 60,
            builder: (BuildContext context, int index) {
              int minute = index % 60;
              return Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  minute.toString().padLeft(2, '0'),
                  textScaleFactor: 1.3,
                  textAlign: TextAlign.center,
                ),
              );
            },
            width: TIME_ITEM_WIDTH,
            onSelectedIndexChanged: _changeMinutes,
            initialIndex: time.minute,
          )
        ]),
        Text("Selected time is ${time.format(context)}"),
        SizedBox(
          height: 20.0,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          RollerList(
            items: months,
            onSelectedIndexChanged: _changeMonths,
            initialIndex: 1,
          ),
          SizedBox(
            width: 2.0,
          ),
          RollerList(
            items: _getDaysForMonth(selectedMonth),
            width: TIME_ITEM_WIDTH,
            onSelectedIndexChanged: _changeDays,
            initialIndex: selectedDay,
          )
        ]),
        Text("Selected date is $selectedMonth, $selectedDay"),
      ],
    );
  }

  void _changeHours(int value) {
    setState(() {
      time = new TimeOfDay(hour: value, minute: time.minute);
    });
  }

  void _changeMinutes(int value) {
    setState(() {
      time = new TimeOfDay(hour: time.hour, minute: value);
    });
  }

  List<Widget> _getDaysForMonth(String selectedMonth) {
    List<Widget> result = new List();
    for (int i = 1; i <= MONTHS[selectedMonth]; i++) {
      result.add(Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          "$i",
          textScaleFactor: 1.3,
          textAlign: TextAlign.center,
        ),
      ));
    }
    return result;
  }

  void _changeMonths(int value) {
    setState(() {
      selectedMonth = MONTHS.keys.toList()[value];
    });
  }

  void _changeDays(int value) {
    setState(() {
      selectedDay = value + 1;
    });
  }
}
