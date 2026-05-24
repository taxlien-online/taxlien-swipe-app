import 'package:flutter/material.dart';

/// Details about a two-finger drag gesture.
class TwoFingerDragDetails {
  const TwoFingerDragDetails({
    required this.center,
    required this.delta,
    required this.spread,
    required this.spreadDelta,
  });

  final Offset center;
  final Offset delta;
  final double spread; // Distance between fingers
  final double spreadDelta; // Change in spread (for pinch)
}

/// Callback types for two-finger drag events.
typedef TwoFingerDragStartCallback = void Function(TwoFingerDragDetails details);
typedef TwoFingerDragUpdateCallback = void Function(TwoFingerDragDetails details);
typedef TwoFingerDragEndCallback = void Function();

/// A widget that detects two-finger drag gestures.
class TwoFingerDragDetector extends StatefulWidget {
  const TwoFingerDragDetector({
    super.key,
    required this.child,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
  });

  final Widget child;
  final TwoFingerDragStartCallback? onDragStart;
  final TwoFingerDragUpdateCallback? onDragUpdate;
  final TwoFingerDragEndCallback? onDragEnd;

  @override
  State<TwoFingerDragDetector> createState() => _TwoFingerDragDetectorState();
}

class _TwoFingerDragDetectorState extends State<TwoFingerDragDetector> {
  final Map<int, Offset> _pointers = {};
  Offset? _lastCenter;
  double? _lastSpread;
  bool _gestureActive = false;

  Offset _calculateCenter() {
    if (_pointers.length < 2) return Offset.zero;
    final positions = _pointers.values.toList();
    return (positions[0] + positions[1]) / 2;
  }

  double _calculateSpread() {
    if (_pointers.length < 2) return 0;
    final positions = _pointers.values.toList();
    return (positions[0] - positions[1]).distance;
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointers[event.pointer] = event.position;

    if (_pointers.length == 2 && !_gestureActive) {
      _gestureActive = true;
      _lastCenter = _calculateCenter();
      _lastSpread = _calculateSpread();

      widget.onDragStart?.call(TwoFingerDragDetails(
        center: _lastCenter!,
        delta: Offset.zero,
        spread: _lastSpread!,
        spreadDelta: 0,
      ));
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_pointers.containsKey(event.pointer)) return;
    _pointers[event.pointer] = event.position;

    if (_pointers.length == 2 && _gestureActive) {
      final center = _calculateCenter();
      final spread = _calculateSpread();

      final delta = center - (_lastCenter ?? center);
      final spreadDelta = spread - (_lastSpread ?? spread);

      _lastCenter = center;
      _lastSpread = spread;

      widget.onDragUpdate?.call(TwoFingerDragDetails(
        center: center,
        delta: delta,
        spread: spread,
        spreadDelta: spreadDelta,
      ));
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    final wasActive = _gestureActive && _pointers.length == 2;
    _pointers.remove(event.pointer);

    if (wasActive && _pointers.length < 2) {
      _gestureActive = false;
      _lastCenter = null;
      _lastSpread = null;
      widget.onDragEnd?.call();
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    final wasActive = _gestureActive && _pointers.length == 2;
    _pointers.remove(event.pointer);

    if (wasActive && _pointers.length < 2) {
      _gestureActive = false;
      _lastCenter = null;
      _lastSpread = null;
      widget.onDragEnd?.call();
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

/// Detects a "connect" gesture where two fingers are placed on different items.
class TwoFingerConnectDetector extends StatefulWidget {
  const TwoFingerConnectDetector({
    super.key,
    required this.child,
    this.onConnect,
    this.hitTestCallback,
  });

  final Widget child;
  final void Function(String? itemA, String? itemB)? onConnect;
  final String? Function(Offset position)? hitTestCallback;

  @override
  State<TwoFingerConnectDetector> createState() =>
      _TwoFingerConnectDetectorState();
}

class _TwoFingerConnectDetectorState extends State<TwoFingerConnectDetector> {
  final Map<int, Offset> _pointers = {};
  String? _itemA;
  String? _itemB;

  void _onPointerDown(PointerDownEvent event) {
    _pointers[event.pointer] = event.position;

    // Check if this pointer is on an item
    final item = widget.hitTestCallback?.call(event.position);

    if (_pointers.length == 1) {
      _itemA = item;
      _itemB = null;
    } else if (_pointers.length == 2) {
      _itemB = item;

      // Trigger connect if both are on items
      if (_itemA != null && _itemB != null && _itemA != _itemB) {
        widget.onConnect?.call(_itemA, _itemB);
      }
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _pointers.remove(event.pointer);

    if (_pointers.isEmpty) {
      _itemA = null;
      _itemB = null;
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _pointers.remove(event.pointer);

    if (_pointers.isEmpty) {
      _itemA = null;
      _itemB = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: widget.child,
    );
  }
}
