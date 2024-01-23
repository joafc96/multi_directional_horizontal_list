import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:multi_directional_horizontal_list/multi_directional_horizontal_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Directional Horizontal List Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Multi Directional Horizontal List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This is a parameter to support testing in this repo
  final MultiDirectionalHorizontalListController? testingController;

  const MyHomePage({
    super.key,
    required this.title,
    this.testingController,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MultiDirectionalHorizontalListController controller;

  @override
  initState() {
    controller =
        widget.testingController ?? MultiDirectionalHorizontalListController()
          ..addListener((event) {
            _handleCallbackEvent(event);
          });

  }

  void _handleCallbackEvent(ScrollEvent? event) {
    event?.randomCallback?.call();
    log(event!.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ColoredBox(
        color: Colors.pinkAccent,
        child: MultiDirectionalHorizontalList(
          controller: controller,
          initialScrollOffset: 200,
          itemCount: 20,
          onLeftLoaded: () {
            print("fuck you we are left");
          },
          onRightLoaded: () {
            print("fuck you we are right");
          },
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              width: 100,
              color: Colors.yellow,
              alignment: Alignment.center,
              child: Text(
                "data $index",
                textAlign: TextAlign.left,
              ),
            );
          },
        ),
      ),
    );
  }
}
