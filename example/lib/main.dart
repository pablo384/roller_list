import 'package:flutter/material.dart';
import 'package:roller_list/roller_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RollerList Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("RollerList Demo"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Clock inspiration',
              textScaleFactor: 1.5,
              style: TextStyle(fontWeight: FontWeight.bold),
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
        ),
      ),
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
      time = new TimeOfDay(hour: value, minute: time.minute);
    });
  }

  void _changeMinutes(int value) {
    setState(() {
      time = new TimeOfDay(hour: time.hour, minute: value);
    });
  }
}
