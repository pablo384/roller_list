import 'dart:async';
import 'dart:math';

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
  static const _ROTATION_DURATION = Duration(milliseconds: 300);
  TimeOfDay time;
  final List<Widget> hours = _getTimeWidgetsArray(24);
  final List<Widget> minutes = _getTimeWidgetsArray(60);
  final List<Widget> slots = _getSlots();
  int first, second, third;
  final leftRoller = new GlobalKey<RollerListState>();
  final rightRoller = new GlobalKey<RollerListState>();
  Timer rotator;
  Random _random = new Random();

  @override
  void initState() {
    DateTime now = DateTime.now();
    time = new TimeOfDay(hour: now.hour, minute: now.minute);
    super.initState();
  }

  @override
  void dispose() {
    rotator?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RollerList Demo"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Clock inspiration',
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
              SizedBox(
                height: 16.0,
              ),
              Divider(),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Slot Machine',
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                width: 300,
                child: Stack(
                  children: <Widget>[
                    Image.asset('assets/images/slot-machine.jpg'),
                    Positioned(
                      left: 94,
                      right: 94,
                      bottom: 90,
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: RollerList(
                                items: slots,
                                enabled: false,
                                key: leftRoller,
                              ),
                            ),
                            VerticalDivider(
                              width: 2,
                              color: Colors.black,
                            ),
                            Expanded(
                              flex: 1,
                              child: RollerList(
                                items: slots,
                                onSelectedIndexChanged: _finishRotating,
                                onScrollStarted: _startRotating,
                              ),
                            ),
                            VerticalDivider(
                              width: 2,
                              color: Colors.black,
                            ),
                            Expanded(
                              flex: 1,
                              child: RollerList(
                                enabled: false,
                                items: slots,
                                key: rightRoller,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   color: Colors.red,
              //   padding: EdgeInsets.all(8.0),
              //   alignment: Alignment.center,
              //   child:
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _startRotating() {
    rotator = Timer.periodic(_ROTATION_DURATION, _rotateRoller);
  }

  void _rotateRoller(_) {
    final leftRotationTarget = _random.nextDouble() * 1000;
    final rightRotationTarget = _random.nextDouble() * 1000;
    leftRoller.currentState.smoothScrollTo(leftRotationTarget);
    rightRoller.currentState.smoothScrollTo(rightRotationTarget);
  }

  void _finishRotating(int value) {
    second = value;
    rotator?.cancel();
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

  static List<Widget> _getSlots() {
    List<Widget> result = new List();
    for (int i = 0; i < 9; i++) {
      result.add(Container(
        padding: EdgeInsets.all(4.0),
        color: Colors.white,
        child: Image.asset(
          "assets/images/$i.png",
          width: double.infinity,
          height: double.infinity,
        ),
      ));
    }
    return result;
  }
}
