import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      home: const MyHomePage(title: ''),
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

  final double itemWidth = 85;

  late double middle = -(MediaQuery.sizeOf(context).width) / 2 + itemWidth / 2;

  @override
  initState() {
    controller =
        widget.testingController ?? MultiDirectionalHorizontalListController()
          ..addListener((event) {
            _handleCallbackEvent(event);
          });
    super.initState();
  }

  void _handleCallbackEvent(ScrollEvent? event) {
    event?.randomCallback?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month and Year
          Text(
            _selectedDateStart.monthAndDay,
            key: const ValueKey(0),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              textStyle: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          MultiDirectionalHorizontalList.builder(
            controller: controller,
            initialScrollOffset: middle,
            itemCount: 100,
            height: 60,
            onLeftLoaded: () {},
            onRightLoaded: () {},
            itemBuilder: (context, index) {
              // Current Date Time
              DateTime currentDateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + index,
              );

              bool isSelected = currentDateTime.isSelected(_selectedDateStart);

              bool isToday = currentDateTime.isToday;

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
                  width: itemWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NotificationListener(
                        onNotification:
                            (SizeChangedLayoutNotification notification) {
                          controller.animateTo(
                            middle + (_activeIndex - 1) * itemWidth + itemWidth,
                          );
                          return true;
                        },
                        child: SizeChangedLayoutNotifier(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: isSelected
                                ? Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: isToday
                                            ? const RedDot()
                                            : const SizedBox.shrink(),
                                      ),
                                      Text(
                                        currentDateTime.getDay(
                                            abbreviate: false),
                                        key: const ValueKey(0),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    ],
                                  )
                                : Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: isToday
                                            ? const RedDot()
                                            : const SizedBox.shrink(),
                                      ),
                                      Text(
                                        currentDateTime.getDay(
                                            abbreviate: true),
                                        key: const ValueKey(1),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                color: Colors.black54,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isSelected
                            ? Text(
                                currentDateTime.dayInNo,
                                key: const ValueKey(0),
                                style: GoogleFonts.lato(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(color: Colors.black),
                                ),
                              )
                            : Text(
                                currentDateTime.dayInNo,
                                key: const ValueKey(1),
                                style: GoogleFonts.lato(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: Colors.black54),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      AnimatedScale(
                        duration: const Duration(milliseconds: 600),
                        scale: isSelected ? 1 : 0,
                        curve: isSelected
                            ? Curves.decelerate
                            : Curves.easeOutQuart,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40),
                            ),
                            color: Colors.black54,
                          ),
                          width: itemWidth,
                          height: 4,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

extension DateUtils on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day &&
        tomorrow.month == month &&
        tomorrow.year == year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  bool isSelected(DateTime selected) {
    return selected.day == day &&
        selected.month == month &&
        selected.year == year;
  }

  String get monthAndDay {
    return DateFormat.yMMMM().format(this);
  }

  String get dayInNo {
    return DateFormat.d().format(this);
  }

  String getMonth({bool includeYear = false}) {
    if (includeYear) {
      return DateFormat.yMMMM().format(this);
    }
    return DateFormat.MMMM().format(this);
  }

  String getDay({bool abbreviate = false, bool alphabet = false}) {
    if (alphabet) {
      return DateFormat.EEEEE().format(this);
    }
    if (abbreviate) {
      return DateFormat.E().format(this);
    }
    return DateFormat.EEEE().format(this);
  }
}

class RedDot extends StatelessWidget {
  const RedDot({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(1.0, -1.0),
      child: Container(
        height: 5,
        width: 5,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
