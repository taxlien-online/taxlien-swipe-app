import 'package:flutter/material.dart';

/// Direction of a three-finger gesture.
enum ThreeFingerDirection {
  pullDown,
  pushUp,
}

/// Details about a three-finger gesture.
class ThreeFingerDetails {
  const ThreeFingerDetails({
    required this.direction,
    required this.distance,
  });

  final ThreeFingerDirection direction;
  final double distance;
}

/// Callback for three-finger gesture events.
typedef ThreeFingerCallback = void Function(ThreeFingerDetails details);

/// A widget that detects three-finger pull/push gestures.
class ThreeFingerGestureDetector extends StatefulWidget {
  const ThreeFingerGestureDetector({
    super.key,
    required this.child,
    this.onThreeFingerPullDown,
    this.onThreeFingerPushUp,
    this.onThreeFingerUpdate,
    this.threshold = 50.0,
  });

  final Widget child;
  final VoidCallback? onThreeFingerPullDown;
  final VoidCallback? onThreeFingerPushUp;
  final ThreeFingerCallback? onThreeFingerUpdate;
  final double threshold;

  @override
  State<ThreeFingerGestureDetector> createState() =>
      _ThreeFingerGestureDetectorState();
}

class _ThreeFingerGestureDetectorState
    extends State<ThreeFingerGestureDetector> {
  final Map<int, Offset> _pointers = {};
  Offset? _startCenter;
  bool _gestureStarted = false;

  Offset _calculateCenter() {
    if (_pointers.isEmpty) return Offset.zero;
    var sum = Offset.zero;
    for (final pos in _pointers.values) {
      sum += pos;
    }
    return sum / _pointers.length.toDouble();
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointers[event.pointer] = event.position;

    if (_pointers.length == 3 && !_gestureStarted) {
      _gestureStarted = true;
      _startCenter = _calculateCenter();
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_pointers.containsKey(event.pointer)) return;
    _pointers[event.pointer] = event.position;

    if (_pointers.length == 3 && _gestureStarted && _startCenter != null) {
      final currentCenter = _calculateCenter();
      final delta = currentCenter - _startCenter!;

      widget.onThreeFingerUpdate?.call(ThreeFingerDetails(
        direction:
            delta.dy > 0 ? ThreeFingerDirection.pullDown : ThreeFingerDirection.pushUp,
        distance: delta.dy.abs(),
      ));
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_pointers.length == 3 && _gestureStarted && _startCenter != null) {
      final currentCenter = _calculateCenter();
      final delta = currentCenter - _startCenter!;

      if (delta.dy.abs() >= widget.threshold) {
        if (delta.dy > 0) {
          widget.onThreeFingerPullDown?.call();
        } else {
          widget.onThreeFingerPushUp?.call();
        }
      }
    }

    _pointers.remove(event.pointer);

    if (_pointers.isEmpty) {
      _gestureStarted = false;
      _startCenter = null;
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _pointers.remove(event.pointer);

    if (_pointers.isEmpty) {
      _gestureStarted = false;
      _startCenter = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: widget.child,
    );
  }
}
