import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:roller_list/roller_list.dart';

class SlotMachine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SlotMachineState();
  }
}

class _SlotMachineState extends State<SlotMachine> {
  static const _ROTATION_DURATION = Duration(milliseconds: 300);
  final List<Widget> slots = _getSlots();
  final List<String> slotNames = [
    "grape",
    "apple",
    "banana",
    "tree",
    "carrot",
    "lemon",
    "pineapple",
    "seven",
    "orange",
    "watermelon",
  ];
  int first, second, third;
  final leftRoller = new GlobalKey<RollerListState>();
  final rightRoller = new GlobalKey<RollerListState>();
  Timer rotator;
  Random _random = new Random();

  @override
  void initState() {
    first = 0;
    second = 0;
    third = 0;
    super.initState();
  }

  @override
  void dispose() {
    rotator?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
                          onSelectedIndexChanged: (value) {
                            setState(() {
                              first = value - 1;
                            });
                          },
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
                          scrollType: ScrollType.goesOnlyBottom,
                          onSelectedIndexChanged: (value) {
                            setState(() {
                              second = value - 1;
                            });
                            _finishRotating();
                          },
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
                          onSelectedIndexChanged: (value) {
                            setState(() {
                              third = value - 1;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Text(
            "Result: ${slotNames[first]}-${slotNames[second]}-${slotNames[third]}"),
        (first == second && first == third) ? Text("WIN!!!") : Container(),
      ],
    );
  }

  void _startRotating() {
    rotator = Timer.periodic(_ROTATION_DURATION, _rotateRoller);
  }

  void _rotateRoller(_) {
    final leftRotationTarget = _random.nextInt(3 * slots.length);
    final rightRotationTarget = _random.nextInt(3 * slots.length);
    leftRoller.currentState?.smoothScrollToIndex(leftRotationTarget,
        duration: _ROTATION_DURATION, curve: Curves.linear);
    rightRoller.currentState?.smoothScrollToIndex(rightRotationTarget,
        duration: _ROTATION_DURATION, curve: Curves.linear);
  }

  void _finishRotating() {
    rotator?.cancel();
  }

  static List<Widget> _getSlots() {
    List<Widget> result = new List();
    for (int i = 0; i <= 9; i++) {
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
