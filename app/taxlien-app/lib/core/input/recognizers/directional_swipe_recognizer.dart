import 'package:flutter/gestures.dart';
import '../providers/gesture_settings.dart';

/// Direction of a swipe gesture.
enum SwipeDirection {
  up,
  down,
  left,
  right,
}

/// Callback for swipe gesture events.
typedef SwipeCallback = void Function(SwipeDirection direction, double distance);

/// Recognizes directional swipe gestures.
///
/// Unlike [FlickRecognizer], this does not require high velocity.
/// Use for navigation swipes like expanding/collapsing layers.
///
/// Example:
/// ```dart
/// RawGestureDetector(
///   gestures: {
///     DirectionalSwipeRecognizer: GestureRecognizerFactoryWithHandlers<DirectionalSwipeRecognizer>(
///       () => DirectionalSwipeRecognizer(),
///       (recognizer) => recognizer.onSwipe = (direction, distance) {
///         if (direction == SwipeDirection.down) {
///           expandLayer();
///         }
///       },
///     ),
///   },
///   child: MyWidget(),
/// )
/// ```
class DirectionalSwipeRecognizer extends OneSequenceGestureRecognizer {
  /// Called when a swipe is detected.
  SwipeCallback? onSwipe;

  /// Called when swipe is cancelled or doesn't meet threshold.
  VoidCallback? onSwipeCancel;

  /// Minimum distance to trigger a swipe.
  final double minDistance;

  /// Ratio for determining primary direction.
  final double directionalRatio;

  DirectionalSwipeRecognizer({
    this.onSwipe,
    this.onSwipeCancel,
    this.minDistance = GestureSettings.swipeThreshold,
    this.directionalRatio = GestureSettings.directionalRatio,
  });

  Offset? _startPosition;

  @override
  void addPointer(PointerDownEvent event) {
    _startPosition = event.localPosition;
    startTrackingPointer(event.pointer, transform: event.transform);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent) {
      _checkForSwipe(event);
      stopTrackingPointer(event.pointer);
    } else if (event is PointerCancelEvent) {
      _startPosition = null;
      stopTrackingPointer(event.pointer);
    }
  }

  void _checkForSwipe(PointerUpEvent event) {
    if (_startPosition == null) {
      resolve(GestureDisposition.rejected);
      onSwipeCancel?.call();
      return;
    }

    final delta = event.localPosition - _startPosition!;
    final distance = delta.distance;

    if (distance >= minDistance) {
      final direction = _calculateDirection(delta);
      if (direction != null) {
        onSwipe?.call(direction, distance);
        resolve(GestureDisposition.accepted);
        _startPosition = null;
        return;
      }
    }

    resolve(GestureDisposition.rejected);
    onSwipeCancel?.call();
    _startPosition = null;
  }

  SwipeDirection? _calculateDirection(Offset delta) {
    final absX = delta.dx.abs();
    final absY = delta.dy.abs();

    if (absY > absX * directionalRatio) {
      return delta.dy < 0 ? SwipeDirection.up : SwipeDirection.down;
    } else if (absX > absY * directionalRatio) {
      return delta.dx < 0 ? SwipeDirection.left : SwipeDirection.right;
    }
    return null; // Diagonal - no clear direction
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _startPosition = null;
  }

  @override
  String get debugDescription => 'directional_swipe';
}
