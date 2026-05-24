import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../adapters/input_adapter.dart';
import '../providers/input_mode_provider.dart';
import '../recognizers/flick_recognizer.dart';
import '../recognizers/directional_swipe_recognizer.dart';
import '../recognizers/lasso_recognizer.dart';
import '../recognizers/multi_touch_recognizer.dart';

/// A unified gesture detector that handles all input types.
///
/// Combines touch, trackpad, and mouse gestures into a single widget.
/// Automatically adapts behavior based on the current input mode.
///
/// Example:
/// ```dart
/// UnifiedGestureDetector(
///   onTap: () => selectItem(),
///   onFlick: (details) => handleFlick(details),
///   onThreeFingerUpdate: (details) {
///     if (details.panDelta!.dy > 50) openCommandPalette();
///   },
///   onLassoEnd: (details) {
///     final selected = items.where(
///       (item) => details.containsPoint(item.position),
///     ).toList();
///   },
///   onSecondaryTap: () => showContextMenu(),
///   cursor: CursorAction.pointer,
///   child: MyCanvas(),
/// )
/// ```
class UnifiedGestureDetector extends StatefulWidget {
  /// The child widget.
  final Widget child;

  // ============================================
  // Single pointer gestures
  // ============================================

  /// Called on tap.
  final VoidCallback? onTap;

  /// Called on tap with position.
  final void Function(Offset position)? onTapDown;

  /// Called on double tap.
  final VoidCallback? onDoubleTap;

  /// Called on long press.
  final VoidCallback? onLongPress;

  /// Called when long press starts with position.
  final void Function(Offset position)? onLongPressStart;

  /// Called as finger moves during long press.
  final void Function(Offset position)? onLongPressMoveUpdate;

  /// Called when long press ends.
  final VoidCallback? onLongPressEnd;

  // ============================================
  // Swipe and flick
  // ============================================

  /// Called on directional swipe.
  final SwipeCallback? onSwipe;

  /// Called on velocity-based flick.
  final FlickCallback? onFlick;

  // ============================================
  // Scale / Pinch / Pan
  // ============================================

  /// Called when scale gesture starts.
  final void Function(ScaleStartDetails)? onScaleStart;

  /// Called during scale gesture.
  final void Function(ScaleUpdateDetails)? onScaleUpdate;

  /// Called when scale gesture ends.
  final void Function(ScaleEndDetails)? onScaleEnd;

  // ============================================
  // Multi-touch
  // ============================================

  /// Called when 2 fingers touch.
  final MultiTouchCallback? onTwoFingerStart;

  /// Called when 2 fingers move.
  final MultiTouchCallback? onTwoFingerUpdate;

  /// Called when 2-finger gesture ends.
  final MultiTouchCallback? onTwoFingerEnd;

  /// Called when 3 fingers touch.
  final MultiTouchCallback? onThreeFingerStart;

  /// Called when 3 fingers move.
  final MultiTouchCallback? onThreeFingerUpdate;

  /// Called when 3-finger gesture ends.
  final MultiTouchCallback? onThreeFingerEnd;

  // ============================================
  // Lasso
  // ============================================

  /// Called when lasso drawing starts.
  final LassoCallback? onLassoStart;

  /// Called as lasso is drawn.
  final LassoCallback? onLassoUpdate;

  /// Called when lasso drawing ends.
  final LassoCallback? onLassoEnd;

  // ============================================
  // Mouse-specific
  // ============================================

  /// Called when mouse hovers over widget.
  final void Function(PointerHoverEvent)? onHover;

  /// Called when mouse exits widget.
  final void Function(PointerExitEvent)? onHoverExit;

  /// Called on right-click (secondary tap).
  final VoidCallback? onSecondaryTap;

  /// Called on right-click with position.
  final void Function(Offset position)? onSecondaryTapDown;

  /// Called on mouse scroll or trackpad scroll.
  final void Function(PointerScrollEvent)? onScroll;

  // ============================================
  // Configuration
  // ============================================

  /// Cursor to display (desktop only).
  final CursorAction cursor;

  /// Whether to enable lasso mode (disables pan for lasso).
  final bool lassoMode;

  /// Hit test behavior.
  final HitTestBehavior behavior;

  const UnifiedGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onTapDown,
    this.onDoubleTap,
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onSwipe,
    this.onFlick,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.onTwoFingerStart,
    this.onTwoFingerUpdate,
    this.onTwoFingerEnd,
    this.onThreeFingerStart,
    this.onThreeFingerUpdate,
    this.onThreeFingerEnd,
    this.onLassoStart,
    this.onLassoUpdate,
    this.onLassoEnd,
    this.onHover,
    this.onHoverExit,
    this.onSecondaryTap,
    this.onSecondaryTapDown,
    this.onScroll,
    this.cursor = CursorAction.defaultCursor,
    this.lassoMode = false,
    this.behavior = HitTestBehavior.deferToChild,
  });

  @override
  State<UnifiedGestureDetector> createState() => _UnifiedGestureDetectorState();
}

class _UnifiedGestureDetectorState extends State<UnifiedGestureDetector> {
  final InputModeProvider _inputMode = InputModeProvider();

  InputAdapter get _adapter => InputAdapter.forMode(_inputMode.currentMode);

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    // Layer 1: Mouse region for hover and cursor (desktop)
    if (widget.onHover != null ||
        widget.onHoverExit != null ||
        widget.cursor != CursorAction.defaultCursor) {
      child = MouseRegion(
        cursor: _adapter.cursorForAction(widget.cursor),
        onHover: widget.onHover,
        onExit: widget.onHoverExit,
        child: child,
      );
    }

    // Layer 2: Listener for scroll and input mode detection
    child = Listener(
      onPointerDown: (e) => _inputMode.updateFromPointerEvent(e),
      onPointerSignal: _handlePointerSignal,
      behavior: HitTestBehavior.translucent,
      child: child,
    );

    // Layer 3: Three-finger gesture (wraps child)
    if (_hasThreeFingerCallbacks) {
      child = MultiTouchRecognizer(
        requiredPointers: 3,
        onMultiTouchStart: widget.onThreeFingerStart,
        onMultiTouchUpdate: widget.onThreeFingerUpdate,
        onMultiTouchEnd: widget.onThreeFingerEnd,
        child: child,
      );
    }

    // Layer 4: Two-finger gesture (separate from scale)
    if (_hasTwoFingerCallbacks) {
      child = MultiTouchRecognizer(
        requiredPointers: 2,
        onMultiTouchStart: widget.onTwoFingerStart,
        onMultiTouchUpdate: widget.onTwoFingerUpdate,
        onMultiTouchEnd: widget.onTwoFingerEnd,
        child: child,
      );
    }

    // Layer 5: Raw gesture detector for custom recognizers
    final gestures = _buildGestureMap();
    if (gestures.isNotEmpty) {
      child = RawGestureDetector(
        gestures: gestures,
        behavior: widget.behavior,
        child: child,
      );
    }

    // Layer 6: Standard GestureDetector for common gestures
    return GestureDetector(
      behavior: widget.behavior,
      onTap: widget.onTap,
      onTapDown: widget.onTapDown != null
          ? (d) => widget.onTapDown!(d.localPosition)
          : null,
      onDoubleTap: widget.onDoubleTap,
      onLongPress: widget.onLongPress,
      onLongPressStart: widget.onLongPressStart != null
          ? (d) => widget.onLongPressStart!(d.localPosition)
          : null,
      onLongPressMoveUpdate: widget.onLongPressMoveUpdate != null
          ? (d) => widget.onLongPressMoveUpdate!(d.localPosition)
          : null,
      onLongPressEnd: widget.onLongPressEnd != null
          ? (_) => widget.onLongPressEnd!()
          : null,
      onScaleStart: widget.onScaleStart,
      onScaleUpdate: widget.onScaleUpdate,
      onScaleEnd: widget.onScaleEnd,
      onSecondaryTap: widget.onSecondaryTap,
      onSecondaryTapDown: widget.onSecondaryTapDown != null
          ? (d) => widget.onSecondaryTapDown!(d.localPosition)
          : null,
      child: child,
    );
  }

  bool get _hasThreeFingerCallbacks =>
      widget.onThreeFingerStart != null ||
      widget.onThreeFingerUpdate != null ||
      widget.onThreeFingerEnd != null;

  bool get _hasTwoFingerCallbacks =>
      widget.onTwoFingerStart != null ||
      widget.onTwoFingerUpdate != null ||
      widget.onTwoFingerEnd != null;

  Map<Type, GestureRecognizerFactory> _buildGestureMap() {
    final gestures = <Type, GestureRecognizerFactory>{};

    // Flick recognizer
    if (widget.onFlick != null) {
      gestures[FlickRecognizer] =
          GestureRecognizerFactoryWithHandlers<FlickRecognizer>(
        () => FlickRecognizer(),
        (recognizer) => recognizer.onFlick = widget.onFlick,
      );
    }

    // Directional swipe recognizer
    if (widget.onSwipe != null) {
      gestures[DirectionalSwipeRecognizer] =
          GestureRecognizerFactoryWithHandlers<DirectionalSwipeRecognizer>(
        () => DirectionalSwipeRecognizer(),
        (recognizer) => recognizer.onSwipe = widget.onSwipe,
      );
    }

    // Lasso recognizer (only in lasso mode)
    if (widget.lassoMode &&
        (widget.onLassoStart != null ||
            widget.onLassoUpdate != null ||
            widget.onLassoEnd != null)) {
      gestures[LassoRecognizer] =
          GestureRecognizerFactoryWithHandlers<LassoRecognizer>(
        () => LassoRecognizer(),
        (recognizer) {
          recognizer.onLassoStart = widget.onLassoStart;
          recognizer.onLassoUpdate = widget.onLassoUpdate;
          recognizer.onLassoEnd = widget.onLassoEnd;
        },
      );
    }

    return gestures;
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent && widget.onScroll != null) {
      widget.onScroll!(event);
    }
  }
}
