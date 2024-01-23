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
enum UserScrollDirection {
  left,
  right,
  idle,
}

/// The type used to encapsulate events related to scrolling
typedef ScrollEventCallback = void Function(ScrollEvent? event);

class ScrollEvent {
  final UserScrollDirection direction;
  final double? position;
  final Function? randomCallback;

  const ScrollEvent(
    this.direction, {
    this.position,
    this.randomCallback,
  });

  @override
  toString() {
    return "ScrollEvent: Direction: $direction - Position: $position";
  }

  @override
  bool operator ==(Object other) {
    if (other is! ScrollEvent) {
      return false;
    }
    return direction == other.direction && position == other.position;
  }

  @override
  int get hashCode => super.hashCode;
}
