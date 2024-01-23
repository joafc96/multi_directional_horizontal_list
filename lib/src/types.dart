/// Enum describing commands that cam sent into the controller
enum ControllerCommandTypes {
  jumpToPosition,
  animateToPosition,
}

class ControllerFeedback {
  final ControllerCommandTypes command;
  final Object? data;

  const ControllerFeedback(
    this.command, {
    this.data,
  });

  @override
  String toString() {
    return "ControllerFeedback with command: $command, and ${data.toString()}";
  }
}

/// Sent as part of a [ScrollEventCallback] to track progress of swipe events
/// [left] is emitted when the user swipes left,
/// [right] is emitted when the user swipes right.
enum ScrollDirection {
  left,
  right,
}

/// The type used to encapsulate events related to scrolling
typedef ScrollEventCallback = void Function(ScrollEvent event);

class ScrollEvent {
  final ScrollDirection direction;
  final double? scrollPosition;
  final Function? onTopLoaded;

  final Function? onBottomLoaded;

  final Function? onScroll;

  const ScrollEvent(
    this.direction, {
    this.scrollPosition,
    this.onTopLoaded,
    this.onBottomLoaded,
    this.onScroll,
  });

  @override
  toString() {
    return "ScrollEvent: Direction: $direction";
  }

  @override
  bool operator ==(Object other) {
    if (other is! ScrollEvent) {
      return false;
    }
    return direction == other.direction;
  }

  @override
  int get hashCode => super.hashCode;
}
