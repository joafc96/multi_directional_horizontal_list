import 'package:flutter/material.dart';

class MultiDirectionalHorizontalList extends StatefulWidget {
  const MultiDirectionalHorizontalList({super.key});

  @override
  State<MultiDirectionalHorizontalList> createState() =>
      _MultiDirectionalHorizontalListState();
}

class _MultiDirectionalHorizontalListState
    extends State<MultiDirectionalHorizontalList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      height: 100,
      width: MediaQuery.of(context).size.width,
    );
  }
}
