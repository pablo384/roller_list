library roller_list;

import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';

class RollerList extends StatefulWidget {
  final int initialIndex;
  final double visibilityRadius;
  final ValueChanged<int> onSelectedIndexChanged;
  final List<Widget> items;
  final double width, height;
  final Color dividerColor;

  const RollerList({
    @required this.items,
    this.onSelectedIndexChanged,
    this.initialIndex = 0,
    this.visibilityRadius = 1,
    this.width,
    this.height,
    this.dividerColor = Colors.black,
    Key key,
  })  : assert(items != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RollerListState();
  }
}

class _RollerListState extends State<RollerList> {
  InfiniteScrollController scrollController = new InfiniteScrollController();
  int _currentIndex;
  bool _programedJump = false;
  double _itemHeight;
  double _itemWidth;

  @override
  void initState() {
    super.initState();
    _itemWidth = widget.width;
    _itemHeight = widget.height;
    _currentIndex = widget.initialIndex;
    if (_itemHeight == null) {
      WidgetsBinding.instance.addPostFrameCallback(_calculateHeight);
    } else {
      if (_currentIndex != 0)
        WidgetsBinding.instance.addPostFrameCallback(_scrollAfterBuild);
    }
  }

  void _calculateHeight(_) {
    setState(() {
      _itemHeight = context.size.height;
      if (_itemWidth == null) {
        _itemWidth = context.size.width;
      }
    });
    if (_currentIndex != 0)
      WidgetsBinding.instance.addPostFrameCallback(_scrollAfterBuild);
  }

  void _scrollAfterBuild(_) {
    _programedJump = true;
    setState(() {
      _currentIndex = widget.initialIndex;
    });
    scrollController.jumpTo((widget.initialIndex - 1) * _itemHeight);
  }

  @override
  Widget build(BuildContext context) {
    if (_itemHeight == null) {
      return widget.items[_currentIndex];
    } else {
      return NotificationListener(
        child: Container(
          height: _itemHeight * (1 + widget.visibilityRadius * 2) + 2,
          width: _itemWidth,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: InfiniteListView.builder(
                  controller: scrollController,
                  itemExtent: _itemHeight,
                  itemBuilder: (BuildContext context, int index) {
                    int inListIndex = index % widget.items.length;
                    return widget.items[inListIndex];
                  },
                ),
              ),
              Positioned(
                bottom: widget.visibilityRadius * _itemHeight,
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  width: _itemWidth,
                  color: widget.dividerColor,
                ),
              ),
              Positioned(
                top: widget.visibilityRadius * _itemHeight,
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  width: _itemWidth,
                  color: widget.dividerColor,
                ),
              ),
            ],
          ),
        ),
        onNotification: _onNotification,
      );
    }
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollEndNotification) {
      if (_programedJump) {
        _programedJump = false;
        return true;
      } else {
        setState(() {
          _currentIndex = findSelectedItem(notification.metrics.pixels);
        });
        if (widget.onSelectedIndexChanged != null) {
          widget.onSelectedIndexChanged(_currentIndex);
        }
        double offsetDifference = scrollController.offset % _itemHeight;
        if (offsetDifference.abs() > 1.0) {
          _programedJump = true;
          double jumpLength = (_currentIndex - 1) * _itemHeight;
          scrollController.jumpTo(jumpLength);
        }
        return true;
      }
    } else {
      return false;
    }
  }

  double getOffsetForSelection(int index) {
    return (index - widget.visibilityRadius) * _itemHeight;
  }

  int findSelectedItem(double offset) {
    int indexOffset = offset ~/ _itemHeight;
    int borderMovement =
        (offset - indexOffset * _itemHeight) ~/ (_itemHeight / 2);
    indexOffset += borderMovement;
    return (1 + indexOffset) % widget.items.length;
  }

  double getFullListHeight() {
    return widget.items.length * _itemHeight;
  }
}
