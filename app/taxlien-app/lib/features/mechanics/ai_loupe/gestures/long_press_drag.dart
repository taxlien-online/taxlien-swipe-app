import 'dart:async';

import 'package:flutter/material.dart';

/// Details about a long-press drag gesture.
class LongPressDragDetails {
  const LongPressDragDetails({
    required this.position,
    required this.localPosition,
    this.delta = Offset.zero,
  });

  final Offset position;
  final Offset localPosition;
  final Offset delta;
}

/// Callback types for long-press drag events.
typedef LongPressDragStartCallback = void Function(LongPressDragDetails details);
typedef LongPressDragUpdateCallback = void Function(LongPressDragDetails details);
typedef LongPressDragEndCallback = void Function();

/// A widget that detects long-press followed by drag gestures.
class LongPressDragDetector extends StatefulWidget {
  const LongPressDragDetector({
    super.key,
    required this.child,
    this.onLongPressStart,
    this.onLongPressDrag,
    this.onLongPressEnd,
    this.longPressDuration = const Duration(milliseconds: 500),
    this.movementThreshold = 10.0,
  });

  final Widget child;
  final LongPressDragStartCallback? onLongPressStart;
  final LongPressDragUpdateCallback? onLongPressDrag;
  final LongPressDragEndCallback? onLongPressEnd;
  final Duration longPressDuration;
  final double movementThreshold;

  @override
  State<LongPressDragDetector> createState() => _LongPressDragDetectorState();
}

class _LongPressDragDetectorState extends State<LongPressDragDetector> {
  Timer? _longPressTimer;
  Offset? _initialPosition;
  Offset? _lastPosition;
  bool _isLongPressActive = false;
  bool _isDragging = false;

  void _onPointerDown(PointerDownEvent event) {
    _initialPosition = event.position;
    _lastPosition = event.position;

    _longPressTimer?.cancel();
    _longPressTimer = Timer(widget.longPressDuration, () {
      if (_initialPosition != null) {
        final box = context.findRenderObject() as RenderBox?;
        final localPosition = box?.globalToLocal(event.position) ?? event.position;

        setState(() {
          _isLongPressActive = true;
        });

        widget.onLongPressStart?.call(LongPressDragDetails(
          position: event.position,
          localPosition: localPosition,
        ));
      }
    });
  }

  void _onPointerMove(PointerMoveEvent event) {
    // Cancel long press if moved too much before activation
    if (!_isLongPressActive && _initialPosition != null) {
      final distance = (event.position - _initialPosition!).distance;
      if (distance > widget.movementThreshold) {
        _cancelLongPress();
        return;
      }
    }

    // Handle drag after long press activated
    if (_isLongPressActive) {
      final box = context.findRenderObject() as RenderBox?;
      final localPosition = box?.globalToLocal(event.position) ?? event.position;
      final delta = event.position - (_lastPosition ?? event.position);
      _lastPosition = event.position;

      setState(() {
        _isDragging = true;
      });

      widget.onLongPressDrag?.call(LongPressDragDetails(
        position: event.position,
        localPosition: localPosition,
        delta: delta,
      ));
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _cancelLongPress();

    if (_isLongPressActive) {
      widget.onLongPressEnd?.call();
    }

    setState(() {
      _isLongPressActive = false;
      _isDragging = false;
    });

    _initialPosition = null;
    _lastPosition = null;
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _cancelLongPress();

    if (_isLongPressActive) {
      widget.onLongPressEnd?.call();
    }

    setState(() {
      _isLongPressActive = false;
      _isDragging = false;
    });

    _initialPosition = null;
    _lastPosition = null;
  }

  void _cancelLongPress() {
    _longPressTimer?.cancel();
    _longPressTimer = null;
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      behavior: HitTestBehavior.opaque,
      child: widget.child,
    );
  }
}
