import 'package:flutter/material.dart';
import 'package:multi_directional_horizontal_list/multi_directional_horizontal_list.dart';
import 'package:intl/intl.dart';

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
  DateTime _selectedDateStart = DateTime.now();
  int _activeIndex = 0;

  late double middle = -(MediaQuery.sizeOf(context).width) / 2 + 100 / 2;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: MultiDirectionalHorizontalList.builder(
        controller: controller,
        initialScrollOffset: middle,
        itemCount: 20,
        height: 50,
        onLeftLoaded: () {},
        onRightLoaded: () {},
        itemBuilder: (context, index) {
          DateTime currentDateTime = DateTime(DateTime.now().year,
              DateTime.now().month, DateTime.now().day + index);

          bool isSelected = _selectedDateStart.month == currentDateTime.month &&
              _selectedDateStart.year == currentDateTime.year &&
              _selectedDateStart.day == currentDateTime.day;

          bool isToday = currentDateTime.day == DateTime.now().day &&
              currentDateTime.month == DateTime.now().month &&
              currentDateTime.year == DateTime.now().year;

          return InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onTap: () {
              setState(() {
                _selectedDateStart = currentDateTime;
                _activeIndex = index;
              });
            },
            child: SizedBox(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NotificationListener(
                    onNotification:
                        (SizeChangedLayoutNotification notification) {
                      controller
                          .animateTo(middle + (_activeIndex - 1) * 100 + 100);

                      return true;
                    },
                    child: SizeChangedLayoutNotifier(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isSelected
                            ? Text(
                                getDay(currentDateTime, abbreviate: true),
                                key: const ValueKey(0),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  overflow: TextOverflow.clip,
                                ),
                              )
                            : Text(
                                getDay(currentDateTime, abbreviate: true),
                                key: const ValueKey(1),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black38,
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                      ),
                    ),
                  ),
                  DateTime.now().year == currentDateTime.year
                      ? AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isSelected
                              ? Text(
                                  getDayInNo(currentDateTime),
                                  key: const ValueKey(0),
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  getDayInNo(currentDateTime),
                                  key: const ValueKey(1),
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.black38,
                                  ),
                                ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String getMonth(DateTime dateTime, {bool includeYear = false}) {
  if (includeYear) {
    return DateFormat.yMMMM().format(dateTime);
  }
  return DateFormat.MMMM().format(dateTime);
}

String getDay(DateTime dateTime,
    {bool abbreviate = false, bool alphabet = false}) {
  if (alphabet) {
    return DateFormat.EEEEE().format(dateTime);
  }
  if (abbreviate) {
    return DateFormat.E().format(dateTime);
  }
  return DateFormat.EEEE().format(dateTime);
}

String getDayInNo(DateTime dateTime) {
  return DateFormat.d().format(dateTime);
}
