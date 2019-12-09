import 'package:example_roller_list/slot_machine.dart';
import 'package:flutter/material.dart';

import 'clock_selector.dart';

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

class MyHomePage extends StatelessWidget {
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
              ClockSelector(),
              SizedBox(
                height: 16.0,
              ),
              Divider(),
              SizedBox(
                height: 16.0,
              ),
              SlotMachine(),
            ],
          ),
        ),
      ),
    );
  }
}
