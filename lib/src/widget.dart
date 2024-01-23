import "package:flutter/material.dart";

class MultiDirectionalHorizontalList extends StatefulWidget {
  // @required
  final int itemCount;

  // @optional
  final int delta;

  // @required
  final Function(BuildContext context, int index) itemBuilder;

  // @optional
  final double startScrollPosition;

  // @optional
  final Duration duration;

  // @optional
  final double height;

  // @optional
  final Function? onTopLoaded;

  // @optional
  final Function? onBottomLoaded;

  // @optional
  final Function? onScroll;

  const MultiDirectionalHorizontalList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onTopLoaded,
    this.onBottomLoaded,
    this.onScroll,
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

    print("left: $left");
    print("right: $right");
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
