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
  TimeOfDay time = new TimeOfDay(hour: 1, minute: 0);
  final List<Widget> hours = _getHoursArray();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RollerList Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Clock inspiration', 
              textScaleFactor: 1.5,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RollerList(
              items: hours,
              width: 100,
              onSelectedIndexChanged: _changeTime,
                          ),
                          Text("Selected time is ${time.format(context)}"),
                        ],
                      ),
                    ),
                  );
                }
              
                static List<Widget> _getHoursArray() {
                  List<Widget> result = new List();
                  for (int i = 0; i < 24; i++) {
                    result.add(Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text("$i",
                            textScaleFactor: 1.3,
                            textAlign: TextAlign.center,
                            ),
                    ));
                  }
                  return result;
                }
              
                void _changeTime(int value) {
                  setState(() {
                    time = new TimeOfDay(hour: value, minute: time.minute);
                  });
  }
}
