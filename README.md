# multi_directional_horizontal_list

[![pub package](https://img.shields.io/pub/v/sticky_grouped_list.svg)](https://pub.dev/packages/sticky_grouped_list)
[![package publisher](https://img.shields.io/pub/publisher/sticky_grouped_list.svg)](https://pub.dev/packages/sticky_grouped_list)
![build](https://github.com/Dimibe/sticky_grouped_list/actions/workflows/main.yaml/badge.svg??branch=main)

A `ListView` in which list items can be horizontally scrolled in multi direction.

<img src="https://raw.githubusercontent.com/Dimibe/sticky_grouped_list/master/assets/new-screenshot-for-readme.png" width="300"> <img src="https://raw.githubusercontent.com/Dimibe/sticky_grouped_list/master/assets/chat.png" width="300">

## Features
* Easy creation of chat-like interfaces.
* List items can be separated in groups.
* For the groups an individual header can be set.
* Sticky headers with floating option.
* All fields from `ScrollablePositionedList` available.

## Getting Started

Add the package to your pubspec.yaml:

 ```yaml
 multi_directional_horizontal_list: ^0.0.1
 ```

In your dart file, import the library:

 ```Dart
import 'package:multi_directional_horizontal_list/multi_directional_horizontal_list.dart';
 ``` 

Create a `MultiDirectionalHorizontalList` Widget:

 ```Dart
  final GroupedItemScrollController itemScrollController = GroupedItemScrollController();

  StickyGroupedListView<dynamic, String>(
    elements: _elements,
    groupBy: (dynamic element) => element['group'],
    groupSeparatorBuilder: (dynamic element) => Text(element['group']),
    itemBuilder: (context, dynamic element) => Text(element['name']),
    itemComparator: (e1, e2) => e1['name'].compareTo(e2['name']), // optional
    elementIdentifier: (element) => element.name // optional - see below for usage
    itemScrollController: itemScrollController, // optional
    order: StickyGroupedListOrder.ASC, // optional
  );
```

If you are using the `GroupedItemScrollController` you can scroll or jump to an specific position in the list programatically:

1. By using the index, which will scroll to the element at position [index]:
```dart
  itemScrollController.scrollTo(index: 4, duration: Duration(seconds: 2));
  itemScrollController.jumpTo(index: 4);
```

2. By using a pre defined element identifier. The identifier is defined by a `Function` which takes one element and returns a unique identifier of any type.
   The methods `scrollToElement` and `jumpToElement` can be used to jump to an element by providing the elements identifier instead of the index:
```dart
  final GroupedItemScrollController itemScrollController = GroupedItemScrollController();

  StickyGroupedListView<dynamic, String>(
    elements: _elements,
    elementIdentifier: (element) => element.name
    itemScrollController: itemScrollController, 
    [...]
  );

  itemScrollController.scrollToElement(identifier: 'item-1', duration: Duration(seconds: 2));
  itemScrollController.jumpToElement(identifier: 'item-2');
```