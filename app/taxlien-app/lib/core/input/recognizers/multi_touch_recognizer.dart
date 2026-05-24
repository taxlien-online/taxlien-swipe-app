import 'dart:math';
import 'package:flutter/widgets.dart';

/// Phase of a multi-touch gesture.
enum MultiTouchPhase {
  /// Required number of pointers just made contact.
  start,

  /// Pointers are moving.
  update,

  /// Gesture ended (pointers lifted).
  end,
}

/// Details about a multi-touch gesture.
class MultiTouchDetails {
  /// Number of active pointers.
  final int pointerCount;

  /// Positions of all active pointers.
  final List<Offset> positions;

  /// Center point of all pointers.
  final Offset centroid;

  /// Current phase of the gesture.
  final MultiTouchPhase phase;

  /// Pan delta since last update (for 2+ finger pan).
  final Offset? panDelta;

  /// Scale factor relative to initial spread (for pinch).
  final double? scale;

  /// Rotation in radians relative to initial angle.
  final double? rotation;

  const MultiTouchDetails({
    required this.pointerCount,
    required this.positions,
    required this.centroid,
    required this.phase,
    this.panDelta,
    this.scale,
    this.rotation,
  });
}

/// Callback for multi-touch gesture events.
typedef MultiTouchCallback = void Function(MultiTouchDetails details);

/// Widget that recognizes multi-touch gestures.
///
/// Use this for 2-finger, 3-finger, or 4-finger gestures that
/// aren't covered by standard [GestureDetector].
///
/// Example:
/// ```dart
/// MultiTouchRecognizer(
///   requiredPointers: 3,
///   onMultiTouchStart: (details) {
///     // 3 fingers touched
///   },
///   onMultiTouchUpdate: (details) {
///     // 3 fingers moved - check panDelta for direction
///     if (details.panDelta!.dy > 50) {
///       openCommandPalette();
///     }
///   },
///   child: GalaxyCanvas(),
/// )
/// ```
class MultiTouchRecognizer extends StatefulWidget {
  /// The child widget to wrap.
  final Widget child;

  /// Number of pointers required to trigger gesture (2, 3, or 4).
  final int requiredPointers;

  /// Called when required pointers first make contact.
  final MultiTouchCallback? onMultiTouchStart;

  /// Called when pointers move while gesture is active.
  final MultiTouchCallback? onMultiTouchUpdate;

  /// Called when gesture ends (pointers lifted).
  final MultiTouchCallback? onMultiTouchEnd;

  const MultiTouchRecognizer({
    super.key,
    required this.child,
    this.requiredPointers = 2,
    this.onMultiTouchStart,
    this.onMultiTouchUpdate,
    this.onMultiTouchEnd,
  }) : assert(requiredPointers >= 2 && requiredPointers <= 4);

  @override
  State<MultiTouchRecognizer> createState() => _MultiTouchRecognizerState();
}

class _MultiTouchRecognizerState extends State<MultiTouchRecognizer> {
  final Map<int, Offset> _pointers = {};
  bool _isActive = false;
  Offset? _lastCentroid;
  double? _initialDistance;
  double? _initialRotation;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointers[event.pointer] = event.localPosition;

    if (_pointers.length == widget.requiredPointers && !_isActive) {
      _isActive = true;
      _lastCentroid = _calculateCentroid();
      _initialDistance = _calculateAverageDistance();
      _initialRotation = _calculateRotation();

      widget.onMultiTouchStart?.call(_createDetails(MultiTouchPhase.start));
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_pointers.containsKey(event.pointer)) return;

    final oldPosition = _pointers[event.pointer];
    _pointers[event.pointer] = event.localPosition;

    if (_isActive && _pointers.length >= widget.requiredPointers) {
      widget.onMultiTouchUpdate?.call(_createDetails(MultiTouchPhase.update));
      _lastCentroid = _calculateCentroid();
    } else if (oldPosition != null) {
      // Restore position if not active
      _pointers[event.pointer] = oldPosition;
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    final wasActive = _isActive;
    _pointers.remove(event.pointer);

    if (wasActive && _pointers.length < widget.requiredPointers) {
      widget.onMultiTouchEnd?.call(_createDetails(MultiTouchPhase.end));
      _reset();
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _pointers.remove(event.pointer);

    if (_isActive && _pointers.length < widget.requiredPointers) {
      _reset();
    }
  }

  void _reset() {
    _isActive = false;
    _lastCentroid = null;
    _initialDistance = null;
    _initialRotation = null;
  }

  Offset _calculateCentroid() {
    if (_pointers.isEmpty) return Offset.zero;

    var sumX = 0.0;
    var sumY = 0.0;

    for (final position in _pointers.values) {
      sumX += position.dx;
      sumY += position.dy;
    }

    return Offset(
      sumX / _pointers.length,
      sumY / _pointers.length,
    );
  }

  double _calculateAverageDistance() {
    if (_pointers.length < 2) return 0;

    final centroid = _calculateCentroid();
    var totalDistance = 0.0;

    for (final position in _pointers.values) {
      totalDistance += (position - centroid).distance;
    }

    return totalDistance / _pointers.length;
  }

  double _calculateRotation() {
    if (_pointers.length < 2) return 0;

    final positions = _pointers.values.toList();
    final delta = positions[1] - positions[0];
    return atan2(delta.dy, delta.dx);
  }

  MultiTouchDetails _createDetails(MultiTouchPhase phase) {
    final centroid = _calculateCentroid();
    final currentDistance = _calculateAverageDistance();
    final currentRotation = _calculateRotation();

    Offset? panDelta;
    if (_lastCentroid != null) {
      panDelta = centroid - _lastCentroid!;
    }

    double? scale;
    if (_initialDistance != null && _initialDistance! > 0) {
      scale = currentDistance / _initialDistance!;
    }

    double? rotation;
    if (_initialRotation != null) {
      rotation = currentRotation - _initialRotation!;
    }

    return MultiTouchDetails(
      pointerCount: _pointers.length,
      positions: _pointers.values.toList(),
      centroid: centroid,
      phase: phase,
      panDelta: panDelta,
      scale: scale,
      rotation: rotation,
    );
  }
}
