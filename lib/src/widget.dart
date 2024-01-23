import "package:flutter/material.dart";
import 'package:flutter/scheduler.dart';

import 'index.dart';

class MultiDirectionalHorizontalList extends StatefulWidget {
  /// @required
  final int itemCount;

  /// A function that converts a context and an index to a Widget to be rendered
  final IndexedWidgetBuilder itemBuilder;

  /// @optional
  final int delta;

  /// @optional
  final double initialScrollOffset;

  /// @optional
  final Duration duration;

  /// @optional
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
    this.initialScrollOffset = 0,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<MultiDirectionalHorizontalList> createState() =>
      _MultiDirectionalHorizontalListState();
}

class _MultiDirectionalHorizontalListState
    extends State<MultiDirectionalHorizontalList> {
  late final ScrollController _scrollController;

  final List<int> left = [];
  final List<int> right = [];

  @override
  void initState() {
    initialiseScrollController();
    initialiseFeedBackController();
    populateLeftAndRightList(widget.itemCount);

    super.initState();
  }

  initialiseScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        widget.initialScrollOffset,
        duration: widget.duration,
        curve: const ElasticOutCurve(0.7),
      );
    });
  }

  initialiseFeedBackController() {
    widget.controller?.attach()?.listen((event) {
      switch (event.command) {
        case ControllerCommandTypes.jumpToPosition:
          _jumpToPosition(event.data as double);
          break;
        case ControllerCommandTypes.animateToPosition:
          _animateToPosition(
            widget.duration,
            position: event.data as double,
          );
          break;
      }
    });
  }

  @override
  void dispose() {
    widget.controller?.disposeListeners();
    super.dispose();
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

  _jumpToPosition(double? position) {
    _scrollController.jumpTo(
      position ?? widget.initialScrollOffset,
    );
  }

  _animateToPosition(Duration duration, {double? position}) {
    _scrollController.animateTo(
      position ?? widget.initialScrollOffset,
      duration: duration,
      curve: Curves.fastOutSlowIn,
    );
  }

  _scrollListener() {
  //   if (_scrollController.offset >=
  //       _scrollController.position.maxScrollExtent - widget.delta) {
  //     _onEndReached();
  //     if (widget.onTopLoaded != null) {
  //       widget.onTopLoaded!();
  //     }
  //   }
  //   if (_scrollController.offset <=
  //       _scrollController.position.minScrollExtent + widget.delta) {
  //     _onStartReached();
  //     if (widget.onBottomLoaded != null) {
  //       widget.onBottomLoaded!();
  //     }
  //   }
  //   if (widget.controller != null) {
  //     widget.onScroll!(_scrollController.offset);
  //   }
  // }
  //
  // _onEndReached() {
  //   setState(() {
  //     bottom.add(bottom.length);
  //   });
  // }
  //
  // _onStartReached() {
  //   setState(() {
  //     top.add(-top.length - 1);
  //   });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: CustomScrollView(
        key: const Key("CustomScrollView"),
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        center: const ValueKey('right-sliver-list'),
        slivers: <Widget>[
          SliverList(
            // key: const ValueKey('left-sliver-list'),
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
