# multi_directional_horizontal_list

[![pub package](https://img.shields.io/pub/v/sticky_grouped_list.svg)](https://pub.dev/packages/sticky_grouped_list)
[![package publisher](https://img.shields.io/pub/publisher/sticky_grouped_list.svg)](https://pub.dev/packages/sticky_grouped_list)

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
  final MultiDirectionalHorizontalListController controller = MultiDirectionalHorizontalListController();

   MultiDirectionalHorizontalList(
        controller: controller,
        initialScrollOffset: 200,
        itemCount: 20,
         onLeftLoaded: () {
            print("Reached left end");
         },
         onRightLoaded: () {
            print("Reached right end");
         },
         itemBuilder: (context, index) {
            return SizedBox();
         }
     );
```

If you are using the `MultiDirectionalHorizontalListController` you can animate or jump to an specific position in the list programmatically:

By using the index, which will scroll to the element at position [index]:
```Dart
  final MultiDirectionalHorizontalListController controller = MultiDirectionalHorizontalListController();

  controller.animateTo(4);
  controller.jumpTo(4);
```

If you are using the `MultiDirectionalHorizontalListController` you can attach a listener and listen to scroll events like direction or position:

By using the listener, we can grab hold of position and direction:
```Dart
  final MultiDirectionalHorizontalListController controller = MultiDirectionalHorizontalListController();

    controller()
    ..addListener((event) {});
```