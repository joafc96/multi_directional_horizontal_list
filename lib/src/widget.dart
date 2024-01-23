import 'dart:developer';

import "package:flutter/material.dart";

import 'index.dart';

class MultiDirectionalHorizontalList extends StatefulWidget {
  // @required
  final int itemCount;

  // @optional
  final int delta;

  /// A function that converts a context and an index to a Widget to be rendered
  final IndexedWidgetBuilder itemBuilder;

  // @optional
  final double startScrollPosition;

  // @optional
  final Duration duration;

  // @optional
  final double height;

  /// @optional
  /// An optional controller to request changes and to notify consumers of changes
  /// via an optional listener
  final MultiDirectionalHorizontalListController? controller;

  const MultiDirectionalHorizontalList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.height = 40,
    this.delta = 50,
    this.startScrollPosition = 0,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<MultiDirectionalHorizontalList> createState() =>
      _MultiDirectionalHorizontalListState();
}

class _MultiDirectionalHorizontalListState
    extends State<MultiDirectionalHorizontalList> {
  final List<int> left = [];
  final List<int> right = [];

  @override
  void initState() {
    widget.controller?.attach()?.listen((event) {
      switch (event.command) {
        case ControllerCommandTypes.jumpToPosition:
          // _jumpToPosition(event.data as int);
          break;
        case ControllerCommandTypes.animateToPosition:
          // _animateToPosition(event.data as int);
          break;
      }
      log(event.toString());
    });

    populateLeftAndRightList(widget.itemCount);

    super.initState();
  }

  populateLeftAndRightList(int count) {
    // Ensure count is an odd number to have 0 in the middle
    if (count.isEven) {
      count++;
    }

    int middleIndex = count ~/ 2;

    // Add numbers to the left of 0
    for (int i = 1; i < middleIndex; i++) {
      left.add(-i);
    }

    // Add numbers to the right of 0
    for (int i = 0; i < middleIndex; i++) {
      right.add(i);
    }
  }

  @override
  void dispose() {
    widget.controller?.disposeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.greenAccent,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        center: const ValueKey('right-sliver-list'),
        slivers: <Widget>[
          SliverList(
            key: const ValueKey('left-sliver-list'),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return widget.itemBuilder(context, left[index]);
              },
              childCount: left.length,
            ),
          ),
          SliverList(
            key: const ValueKey('right-sliver-list'),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return widget.itemBuilder(context, right[index]);
              },
              childCount: right.length,
            ),
          ),
        ],
      ),
    );
  }
}
