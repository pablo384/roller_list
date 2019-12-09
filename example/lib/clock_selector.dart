import 'package:flutter/material.dart';
import 'package:roller_list/roller_list.dart';

class ClockSelector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClockSelectorState();
  }
}

class _ClockSelectorState extends State<ClockSelector> {
  static const TIME_ITEM_WIDTH = 80.0;
  TimeOfDay time;
  final List<Widget> hours = _getTimeWidgetsArray(24);
  final List<Widget> minutes = _getTimeWidgetsArray(60);

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
            items: hours,
            width: TIME_ITEM_WIDTH,
            onSelectedIndexChanged: _changeHours,
            initialIndex: time.hour,
          ),
          SizedBox(
            width: 1.0,
          ),
          RollerList(
            items: minutes,
            width: TIME_ITEM_WIDTH,
            onSelectedIndexChanged: _changeMinutes,
            initialIndex: time.minute,
          )
        ]),
        Text("Selected time is ${time.format(context)}"),
      ],
    );
  }

  static List<Widget> _getTimeWidgetsArray(int maxValue) {
    List<Widget> result = new List();
    for (int i = 0; i < maxValue; i++) {
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

  void _changeHours(int value) {
    setState(() {
      time = new TimeOfDay(hour: value + 1, minute: time.minute);
    });
  }

  void _changeMinutes(int value) {
    setState(() {
      time = new TimeOfDay(hour: time.hour, minute: value + 1);
    });
  }
}
