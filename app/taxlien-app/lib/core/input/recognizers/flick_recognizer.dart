import 'package:flutter/gestures.dart';
import '../providers/gesture_settings.dart';

/// Direction of a flick gesture.
enum FlickDirection {
  up,
  down,
  left,
  right,

  /// Diagonal or no clear direction.
  none,
}

/// Details about a completed flick gesture.
class FlickDetails {
  /// The velocity of the flick in pixels per second.
  final Offset velocity;

  /// Where the gesture started.
  final Offset startPosition;

  /// Where the gesture ended.
  final Offset endPosition;

  /// Duration of the gesture.
  final Duration duration;

  /// The primary direction of the flick.
  final FlickDirection direction;

  const FlickDetails({
    required this.velocity,
    required this.startPosition,
    required this.endPosition,
    required this.duration,
    required this.direction,
  });

  /// The speed of the flick in pixels per second.
  double get speed => velocity.distance;

  /// The distance traveled.
  double get distance => (endPosition - startPosition).distance;

  /// The angle of the flick in radians.
  double get angle {
    final delta = endPosition - startPosition;
    return delta.direction;
  }
}

/// Callback for flick gesture events.
typedef FlickCallback = void Function(FlickDetails details);

/// Recognizes flick gestures based on velocity.
///
/// A flick is a fast swipe that exceeds a velocity threshold.
/// Use this for actions like sending cards to zones (Orbit Favorites).
///
/// Example:
/// ```dart
/// RawGestureDetector(
///   gestures: {
///     FlickRecognizer: GestureRecognizerFactoryWithHandlers<FlickRecognizer>(
///       () => FlickRecognizer(),
///       (recognizer) => recognizer.onFlick = (details) {
///         print('Flicked ${details.direction} at ${details.speed} px/s');
///       },
///     ),
///   },
///   child: MyWidget(),
/// )
/// ```
class FlickRecognizer extends OneSequenceGestureRecognizer {
  /// Called when a flick gesture is detected.
  FlickCallback? onFlick;

  /// Called when gesture is cancelled or rejected.
  VoidCallback? onFlickCancel;

  /// Minimum velocity (px/s) to trigger a flick.
  final double minVelocity;

  /// Minimum distance (px) to trigger a flick.
  final double minDistance;

  FlickRecognizer({
    this.onFlick,
    this.onFlickCancel,
    this.minVelocity = GestureSettings.flickVelocity,
    this.minDistance = GestureSettings.swipeThreshold,
  });

  Offset? _startPosition;
  DateTime? _startTime;
  VelocityTracker? _velocityTracker;

  @override
  void addPointer(PointerDownEvent event) {
    _startPosition = event.localPosition;
    _startTime = DateTime.now();
    _velocityTracker = VelocityTracker.withKind(event.kind);
    _velocityTracker!.addPosition(event.timeStamp, event.position);
    startTrackingPointer(event.pointer, transform: event.transform);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (_velocityTracker == null) return;

    if (event is PointerMoveEvent) {
      _velocityTracker!.addPosition(event.timeStamp, event.position);
    } else if (event is PointerUpEvent) {
      _velocityTracker!.addPosition(event.timeStamp, event.position);
      _checkForFlick(event);
      stopTrackingPointer(event.pointer);
    } else if (event is PointerCancelEvent) {
      _reset();
      stopTrackingPointer(event.pointer);
    }
  }

  void _checkForFlick(PointerUpEvent event) {
    final velocity = _velocityTracker?.getVelocity();
    if (velocity == null || _startPosition == null || _startTime == null) {
      resolve(GestureDisposition.rejected);
      onFlickCancel?.call();
      return;
    }

    final distance = (event.localPosition - _startPosition!).distance;
    final speed = velocity.pixelsPerSecond.distance;

    if (speed >= minVelocity && distance >= minDistance) {
      final direction = _calculateDirection(velocity.pixelsPerSecond);
      onFlick?.call(FlickDetails(
        velocity: velocity.pixelsPerSecond,
        startPosition: _startPosition!,
        endPosition: event.localPosition,
        duration: DateTime.now().difference(_startTime!),
        direction: direction,
      ));
      resolve(GestureDisposition.accepted);
    } else {
      resolve(GestureDisposition.rejected);
      onFlickCancel?.call();
    }

    _reset();
  }

  FlickDirection _calculateDirection(Offset velocity) {
    final absX = velocity.dx.abs();
    final absY = velocity.dy.abs();

    if (absY > absX * GestureSettings.directionalRatio) {
      return velocity.dy < 0 ? FlickDirection.up : FlickDirection.down;
    } else if (absX > absY * GestureSettings.directionalRatio) {
      return velocity.dx < 0 ? FlickDirection.left : FlickDirection.right;
    }
    return FlickDirection.none;
  }

  void _reset() {
    _startPosition = null;
    _startTime = null;
    _velocityTracker = null;
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _reset();
  }

  @override
  String get debugDescription => 'flick';
}
