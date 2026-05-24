import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Direction of a vertical swipe.
enum SwipeVerticalDirection {
  up,
  down,
}

/// Details about a vertical swipe gesture.
class SwipeVerticalDetails {
  const SwipeVerticalDetails({
    required this.direction,
    required this.velocity,
    required this.distance,
  });

  final SwipeVerticalDirection direction;
  final double velocity;
  final double distance;
}

/// Callback for vertical swipe events.
typedef SwipeVerticalCallback = void Function(SwipeVerticalDetails details);

/// Gesture recognizer for vertical swipe gestures (dig deeper/go back).
class SwipeVerticalGestureRecognizer extends OneSequenceGestureRecognizer {
  SwipeVerticalGestureRecognizer({
    this.onSwipe,
    this.minVelocity = 300.0,
    this.minDistance = 50.0,
  });

  SwipeVerticalCallback? onSwipe;
  final double minVelocity;
  final double minDistance;

  Offset? _startPosition;
  final _velocityTracker = VelocityTracker.withKind(PointerDeviceKind.touch);

  @override
  void addPointer(PointerDownEvent event) {
    _startPosition = event.position;
    startTrackingPointer(event.pointer);
    resolve(GestureDisposition.accepted);
  }

  @override
  void handleEvent(PointerEvent event) {
    _velocityTracker.addPosition(event.timeStamp, event.position);

    if (event is PointerUpEvent && _startPosition != null) {
      _checkSwipe(event);
      _startPosition = null;
    }
  }

  void _checkSwipe(PointerUpEvent event) {
    final velocity = _velocityTracker.getVelocity();
    final endPosition = event.position;
    final delta = endPosition - _startPosition!;

    // Check if primarily vertical
    if (delta.dy.abs() < delta.dx.abs()) return;

    final verticalVelocity = velocity.pixelsPerSecond.dy.abs();
    final verticalDistance = delta.dy.abs();

    if (verticalVelocity >= minVelocity || verticalDistance >= minDistance) {
      final direction =
          delta.dy > 0 ? SwipeVerticalDirection.down : SwipeVerticalDirection.up;

      onSwipe?.call(SwipeVerticalDetails(
        direction: direction,
        velocity: verticalVelocity,
        distance: verticalDistance,
      ));
    }
  }

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  String get debugDescription => 'swipe_vertical';
}

/// A widget that detects vertical swipe gestures.
class SwipeVerticalDetector extends StatelessWidget {
  const SwipeVerticalDetector({
    super.key,
    required this.child,
    this.onSwipeUp,
    this.onSwipeDown,
    this.minVelocity = 300.0,
    this.minDistance = 50.0,
  });

  final Widget child;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;
  final double minVelocity;
  final double minDistance;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        SwipeVerticalGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<SwipeVerticalGestureRecognizer>(
          () => SwipeVerticalGestureRecognizer(
            minVelocity: minVelocity,
            minDistance: minDistance,
          ),
          (instance) {
            instance.onSwipe = (details) {
              switch (details.direction) {
                case SwipeVerticalDirection.up:
                  onSwipeUp?.call();
                case SwipeVerticalDirection.down:
                  onSwipeDown?.call();
              }
            };
          },
        ),
      },
      child: child,
    );
  }
}
