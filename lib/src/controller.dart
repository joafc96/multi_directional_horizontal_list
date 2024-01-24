import 'dart:async';
import 'dart:developer';

import 'types.dart';

/// Allows a consumer to control the list position and track current page
/// and any emitted events through a [ScrollEventCallback].
/// Track page and scroll events without further configuration. For control
/// of the Scroller, use the [attach] method.
class MultiDirectionalHorizontalListController {
  List<ScrollEventCallback> _listeners = [];
  StreamController<ControllerFeedback>? _feedback;

  /// Called to provide a stream of [ControllerFeedback] events
  /// into the [TikTokStyleFullPageScroller] such as [jumpToPosition]
  /// and [animateToPosition] along with their associated data..
  Stream<ControllerFeedback>? attach() {
    _feedback = StreamController<ControllerFeedback>.broadcast(onListen: () {
      log("Someone is listening to the stream of feedback events");
    }, onCancel: () {
      log("onCancel has been called");
    });
    return _feedback?.stream;
  }

  /// Allows a consumer to listen to events by registering a [ScrollEventCallback]
  /// to the controller. Remember to use [disposeListeners] when disposing parent
  /// widgets
  void addListener(ScrollEventCallback listener) {
    _listeners.add(listener);
  }

  /// Send [ScrollEvent] notifications to all registered listeners
  void notifyListeners(ScrollEvent? event) {
    for (var listener in _listeners) {
      listener.call(event);
    }
  }

  /// Remove all listeners to ensure there are no memory leaks.
  void disposeListeners() {
    _listeners = [];
  }

  /// Command the list to switch to the given [position] in a synchronous and
  /// immediate manner. There will be no animation. To animate, use
  /// [animateTo] instead.
  void jumpTo(double position) {
    _feedback?.sink.add(ControllerFeedback(
      ControllerCommandTypes.jumpToPosition,
      data: position,
    ));
  }

  /// Command the list to move to the given [position] in an animated manner.
  /// To ignore animation, use [jumpTo] instead
  Future<void> animateTo(double position) async {
    _feedback?.sink.add(ControllerFeedback(
      ControllerCommandTypes.animateToPosition,
      data: position,
    ));
  }
}
