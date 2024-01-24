# multi_directional_horizontal_list

[![Pub Version](https://img.shields.io/pub/v/multi_directional_horizontal_list?logoColor=5BBF0F)](https://pub.dev/packages/multi_directional_horizontal_list)

A `ListView` in which list items can be horizontally scrolled in multi direction.

<img src="https://github.com/joafc96/multi_directional_horizontal_list/blob/main/gifs/example_multi_directional_horizontal_list.gif" width="300">

## Features
* Easy creation of horizontal timeline-like interfaces.
* Back and Forth communication at ease
* Opportunity to jump or animate to an index programmatically

## Getting Started

Add the package to your pubspec.yaml:

 ```yaml
 multi_directional_horizontal_list: ^0.0.1-beta.1
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