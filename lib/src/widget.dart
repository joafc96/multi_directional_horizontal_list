import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import 'index.dart';

class MultiDirectionalHorizontalList extends StatefulWidget {
  /// @required
  /// [itemCount] Total number of widgets to be rendered (includes both left, right and also center)
  final int itemCount;

  /// @required
  /// [itemBuilder] Function that converts a context and an index to a Widget to be rendered
  final IndexedWidgetBuilder itemBuilder;

  /// @optional
  /// [delta] The offset required to detect the ends before the last offset (left/right)
  final int delta;

  /// @optional
  /// [initialScrollOffset] The offset provided to be where the scroll controller has to be scrolled
  final double initialScrollOffset;

  /// @optional
  /// [duration] Duration for the animateTo method
  final Duration duration;

  /// @optional
  /// [height] As horizontal requires a definite height to be provided to stop unbounded height exception
  final double height;

  /// @optional
  /// [onLeftLoaded]  An optional callback triggered when scroll reaches left most end
  final VoidCallback? onLeftLoaded;

  /// @optional
  /// [onRightLoaded] An optional callback triggered when scroll reaches right most end
  final VoidCallback? onRightLoaded;

  /// @optional
  /// [controller] An optional controller to request changes and to notify consumers of changes
  /// via an optional listener
  final MultiDirectionalHorizontalListController? controller;

  const MultiDirectionalHorizontalList.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.onLeftLoaded,
    this.onRightLoaded,
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
  /// Scroll controller to handle the scrollview
  late final ScrollController _scrollController;

  /// Left and Right temp variables to hold the values
  final List<int> left = [];
  final List<int> right = [];

  /// Event tracking between functions
  ScrollEvent? _pendingEvent;

  @override
  void initState() {
    initialiseScrollController();
    initialiseFeedBackController();
    populateLeftAndRightList(widget.itemCount);

    super.initState();
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

  _jumpToPosition(double? position) {
    _scrollController.jumpTo(
      position ?? widget.initialScrollOffset,
    );
  }

  _animateToPosition(Duration duration, {double? position}) {
    _scrollController.animateTo(
      position ?? widget.initialScrollOffset,
      duration: duration,
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }

  _scrollListener() {
    if (widget.controller == null) return;

    late final UserScrollDirection userScrollDirection;

    ScrollDirection scrollDirection =
        _scrollController.position.userScrollDirection;

    switch (scrollDirection) {
      case ScrollDirection.idle:
        userScrollDirection = UserScrollDirection.idle;
        break;
      case ScrollDirection.forward:
        userScrollDirection = UserScrollDirection.left;
        break;
      case ScrollDirection.reverse:
        userScrollDirection = UserScrollDirection.right;
        break;
    }

    _pendingEvent = ScrollEvent(
      userScrollDirection,
      position: _scrollController.offset,
      randomCallback: () {},
    );
    widget.controller?.notifyListeners(_pendingEvent);

    if (_scrollController.offset <=
        _scrollController.position.minScrollExtent + widget.delta) {
      widget.onLeftLoaded?.call();
      return;
    }

    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent - widget.delta) {
      widget.onRightLoaded?.call();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: CustomScrollView(
        key: const Key("CustomScrollView"),
        controller: _scrollController,
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
