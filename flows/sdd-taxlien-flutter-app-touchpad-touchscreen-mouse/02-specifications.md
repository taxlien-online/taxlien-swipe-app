# Specifications: Gesture & Input Handling System

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-05-24

## Overview

Technical specifications for a unified input handling layer in Flutter. Provides gesture recognizers, input abstractions, and platform-specific adaptations.

---

## Directory Structure

```
lib/
├── core/
│   └── input/
│       ├── input.dart                    # Barrel export
│       │
│       ├── gestures/
│       │   ├── tap_gesture.dart          # Enhanced tap with double/long
│       │   ├── swipe_gesture.dart        # Directional swipe detection
│       │   ├── flick_gesture.dart        # Velocity-based flick
│       │   ├── pinch_gesture.dart        # Scale/zoom gesture
│       │   ├── pan_gesture.dart          # Two-finger pan
│       │   ├── rotate_gesture.dart       # Two-finger rotation
│       │   ├── lasso_gesture.dart        # Free-form selection
│       │   ├── multi_finger_gesture.dart # 2/3/4 finger detection
│       │   └── long_press_drag.dart      # Long press + drag combo
│       │
│       ├── recognizers/
│       │   ├── flick_recognizer.dart
│       │   ├── multi_touch_recognizer.dart
│       │   ├── lasso_recognizer.dart
│       │   └── directional_swipe_recognizer.dart
│       │
│       ├── adapters/
│       │   ├── input_adapter.dart        # Abstract adapter
│       │   ├── touch_adapter.dart        # iOS/Android touch
│       │   ├── trackpad_adapter.dart     # macOS/laptop trackpad
│       │   └── mouse_adapter.dart        # Desktop mouse
│       │
│       ├── providers/
│       │   ├── input_mode_provider.dart  # Current input mode detection
│       │   └── gesture_settings.dart     # Configurable thresholds
│       │
│       └── widgets/
│           ├── unified_gesture_detector.dart
│           ├── hover_builder.dart
│           ├── cursor_region.dart
│           └── keyboard_shortcuts.dart
```

---

## Core Types

### InputMode

```dart
/// lib/core/input/providers/input_mode_provider.dart

enum InputMode {
  touch,     // Finger on touchscreen
  trackpad,  // Laptop/macOS trackpad
  mouse,     // Desktop mouse
  stylus,    // Pen/stylus input
  keyboard,  // Keyboard-only navigation
}

class InputModeProvider extends ChangeNotifier {
  InputMode _currentMode = InputMode.touch;

  InputMode get currentMode => _currentMode;

  void updateFromPointerEvent(PointerEvent event) {
    final newMode = switch (event.kind) {
      PointerDeviceKind.touch => InputMode.touch,
      PointerDeviceKind.mouse => InputMode.mouse,
      PointerDeviceKind.trackpad => InputMode.trackpad,
      PointerDeviceKind.stylus => InputMode.stylus,
      PointerDeviceKind.invertedStylus => InputMode.stylus,
      _ => _currentMode,
    };

    if (newMode != _currentMode) {
      _currentMode = newMode;
      notifyListeners();
    }
  }

  bool get isTouch => _currentMode == InputMode.touch;
  bool get isPointer => _currentMode == InputMode.mouse || _currentMode == InputMode.trackpad;
}
```

### GestureSettings

```dart
/// lib/core/input/providers/gesture_settings.dart

class GestureSettings {
  // Timing thresholds
  static const Duration longPressDuration = Duration(milliseconds: 500);
  static const Duration doubleTapTimeout = Duration(milliseconds: 300);

  // Distance thresholds
  static const double tapSlop = 18.0;          // Max movement for tap
  static const double swipeThreshold = 50.0;   // Min distance for swipe
  static const double flickVelocity = 1000.0;  // Min velocity for flick (px/s)

  // Directional thresholds
  static const double directionalRatio = 1.5;  // Δy/Δx ratio for vertical

  // Multi-touch
  static const double pointerSpreadMin = 20.0; // Min distance between pointers

  // Platform-specific
  static double get scrollMultiplier => Platform.isMacOS ? 1.0 : 3.0;
}
```

---

## Gesture Recognizers

### FlickRecognizer

```dart
/// lib/core/input/recognizers/flick_recognizer.dart

typedef FlickCallback = void Function(FlickDetails details);

class FlickDetails {
  final Offset velocity;
  final Offset startPosition;
  final Offset endPosition;
  final Duration duration;
  final FlickDirection direction;

  double get speed => velocity.distance;
}

enum FlickDirection { up, down, left, right, none }

class FlickRecognizer extends OneSequenceGestureRecognizer {
  FlickCallback? onFlick;
  VoidCallback? onFlickCancel;

  final double minVelocity;
  final double minDistance;

  FlickRecognizer({
    this.onFlick,
    this.onFlickCancel,
    this.minVelocity = GestureSettings.flickVelocity,
    this.minDistance = GestureSettings.swipeThreshold,
  });

  Offset? _startPosition;
  DateTime? _startTime;
  final VelocityTracker _velocityTracker = VelocityTracker.withKind(PointerDeviceKind.touch);

  @override
  void addPointer(PointerDownEvent event) {
    _startPosition = event.localPosition;
    _startTime = DateTime.now();
    _velocityTracker.addPosition(event.timeStamp, event.position);
    startTrackingPointer(event.pointer, transform: event.transform);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      _velocityTracker.addPosition(event.timeStamp, event.position);
    } else if (event is PointerUpEvent) {
      _velocityTracker.addPosition(event.timeStamp, event.position);
      _checkForFlick(event);
      stopTrackingPointer(event.pointer);
    }
  }

  void _checkForFlick(PointerUpEvent event) {
    final velocity = _velocityTracker.getVelocity();
    final distance = (event.localPosition - _startPosition!).distance;

    if (velocity.pixelsPerSecond.distance >= minVelocity && distance >= minDistance) {
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
  }

  FlickDirection _calculateDirection(Offset velocity) {
    final absX = velocity.dx.abs();
    final absY = velocity.dy.abs();

    if (absX > absY * GestureSettings.directionalRatio) {
      return velocity.dx > 0 ? FlickDirection.right : FlickDirection.left;
    } else if (absY > absX * GestureSettings.directionalRatio) {
      return velocity.dy > 0 ? FlickDirection.down : FlickDirection.up;
    }
    return FlickDirection.none;
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _startPosition = null;
    _startTime = null;
  }

  @override
  String get debugDescription => 'flick';
}
```

### MultiTouchRecognizer

```dart
/// lib/core/input/recognizers/multi_touch_recognizer.dart

typedef MultiTouchCallback = void Function(MultiTouchDetails details);

class MultiTouchDetails {
  final int pointerCount;
  final List<Offset> positions;
  final Offset centroid;
  final MultiTouchPhase phase;
  final Offset? panDelta;      // For pan gestures
  final double? scale;          // For pinch gestures
  final double? rotation;       // For rotate gestures
}

enum MultiTouchPhase { start, update, end }

class MultiTouchRecognizer extends StatefulWidget {
  final Widget child;
  final int requiredPointers;  // 2, 3, or 4
  final MultiTouchCallback? onMultiTouchStart;
  final MultiTouchCallback? onMultiTouchUpdate;
  final MultiTouchCallback? onMultiTouchEnd;

  const MultiTouchRecognizer({
    super.key,
    required this.child,
    this.requiredPointers = 2,
    this.onMultiTouchStart,
    this.onMultiTouchUpdate,
    this.onMultiTouchEnd,
  });

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
    _pointers[event.pointer] = event.localPosition;

    if (_isActive && _pointers.length == widget.requiredPointers) {
      widget.onMultiTouchUpdate?.call(_createDetails(MultiTouchPhase.update));
      _lastCentroid = _calculateCentroid();
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _pointers.remove(event.pointer);

    if (_isActive && _pointers.length < widget.requiredPointers) {
      widget.onMultiTouchEnd?.call(_createDetails(MultiTouchPhase.end));
      _isActive = false;
      _lastCentroid = null;
      _initialDistance = null;
      _initialRotation = null;
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _pointers.remove(event.pointer);
    if (_isActive && _pointers.length < widget.requiredPointers) {
      _isActive = false;
    }
  }

  Offset _calculateCentroid() {
    if (_pointers.isEmpty) return Offset.zero;
    final sum = _pointers.values.reduce((a, b) => a + b);
    return sum / _pointers.length.toDouble();
  }

  double _calculateAverageDistance() {
    if (_pointers.length < 2) return 0;
    final centroid = _calculateCentroid();
    final distances = _pointers.values.map((p) => (p - centroid).distance);
    return distances.reduce((a, b) => a + b) / distances.length;
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

    return MultiTouchDetails(
      pointerCount: _pointers.length,
      positions: _pointers.values.toList(),
      centroid: centroid,
      phase: phase,
      panDelta: _lastCentroid != null ? centroid - _lastCentroid! : null,
      scale: _initialDistance != null && _initialDistance! > 0
          ? currentDistance / _initialDistance!
          : null,
      rotation: _initialRotation != null
          ? currentRotation - _initialRotation!
          : null,
    );
  }
}
```

### LassoRecognizer

```dart
/// lib/core/input/recognizers/lasso_recognizer.dart

typedef LassoCallback = void Function(LassoDetails details);

class LassoDetails {
  final List<Offset> points;
  final Rect bounds;
  final LassoPhase phase;

  bool containsPoint(Offset point) {
    // Ray casting algorithm for point-in-polygon
    if (points.length < 3) return false;

    var inside = false;
    var j = points.length - 1;

    for (var i = 0; i < points.length; i++) {
      if (((points[i].dy > point.dy) != (points[j].dy > point.dy)) &&
          (point.dx < (points[j].dx - points[i].dx) *
           (point.dy - points[i].dy) / (points[j].dy - points[i].dy) + points[i].dx)) {
        inside = !inside;
      }
      j = i;
    }
    return inside;
  }
}

enum LassoPhase { start, update, end, cancel }

class LassoRecognizer extends OneSequenceGestureRecognizer {
  LassoCallback? onLassoStart;
  LassoCallback? onLassoUpdate;
  LassoCallback? onLassoEnd;
  LassoCallback? onLassoCancel;

  final double minDistance;
  final int simplifyThreshold;

  LassoRecognizer({
    this.onLassoStart,
    this.onLassoUpdate,
    this.onLassoEnd,
    this.onLassoCancel,
    this.minDistance = 5.0,
    this.simplifyThreshold = 100,
  });

  final List<Offset> _points = [];
  bool _isActive = false;

  @override
  void addPointer(PointerDownEvent event) {
    _points.clear();
    _points.add(event.localPosition);
    _isActive = true;
    startTrackingPointer(event.pointer, transform: event.transform);

    onLassoStart?.call(_createDetails(LassoPhase.start));
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent && _isActive) {
      final lastPoint = _points.last;
      final newPoint = event.localPosition;

      // Only add point if moved enough (reduce density)
      if ((newPoint - lastPoint).distance >= minDistance) {
        _points.add(newPoint);

        // Simplify if too many points
        if (_points.length > simplifyThreshold) {
          _simplifyPath();
        }

        onLassoUpdate?.call(_createDetails(LassoPhase.update));
      }
    } else if (event is PointerUpEvent) {
      _closePath();
      onLassoEnd?.call(_createDetails(LassoPhase.end));
      resolve(GestureDisposition.accepted);
      _isActive = false;
    }
  }

  void _closePath() {
    if (_points.length > 2) {
      _points.add(_points.first); // Close the loop
    }
  }

  void _simplifyPath() {
    // Ramer-Douglas-Peucker simplification
    // Keep every Nth point for now (simple approach)
    final simplified = <Offset>[];
    for (var i = 0; i < _points.length; i += 2) {
      simplified.add(_points[i]);
    }
    _points.clear();
    _points.addAll(simplified);
  }

  LassoDetails _createDetails(LassoPhase phase) {
    return LassoDetails(
      points: List.unmodifiable(_points),
      bounds: _calculateBounds(),
      phase: phase,
    );
  }

  Rect _calculateBounds() {
    if (_points.isEmpty) return Rect.zero;

    var minX = double.infinity;
    var minY = double.infinity;
    var maxX = double.negativeInfinity;
    var maxY = double.negativeInfinity;

    for (final point in _points) {
      minX = min(minX, point.dx);
      minY = min(minY, point.dy);
      maxX = max(maxX, point.dx);
      maxY = max(maxY, point.dy);
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _points.clear();
    _isActive = false;
  }

  @override
  String get debugDescription => 'lasso';
}
```

### DirectionalSwipeRecognizer

```dart
/// lib/core/input/recognizers/directional_swipe_recognizer.dart

enum SwipeDirection { up, down, left, right }

typedef SwipeCallback = void Function(SwipeDirection direction, double distance);

class DirectionalSwipeRecognizer extends OneSequenceGestureRecognizer {
  SwipeCallback? onSwipe;
  final double minDistance;
  final double directionalRatio;

  DirectionalSwipeRecognizer({
    this.onSwipe,
    this.minDistance = GestureSettings.swipeThreshold,
    this.directionalRatio = GestureSettings.directionalRatio,
  });

  Offset? _startPosition;

  @override
  void addPointer(PointerDownEvent event) {
    _startPosition = event.localPosition;
    startTrackingPointer(event.pointer);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent) {
      final delta = event.localPosition - _startPosition!;
      final distance = delta.distance;

      if (distance >= minDistance) {
        final direction = _calculateDirection(delta);
        if (direction != null) {
          onSwipe?.call(direction, distance);
          resolve(GestureDisposition.accepted);
          return;
        }
      }
      resolve(GestureDisposition.rejected);
    }
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
  void didStopTrackingLastPointer(int pointer) => _startPosition = null;

  @override
  String get debugDescription => 'directional_swipe';
}
```

---

## Platform Adapters

### InputAdapter Interface

```dart
/// lib/core/input/adapters/input_adapter.dart

abstract class InputAdapter {
  InputMode get mode;

  // Normalize scroll delta across platforms
  Offset normalizeScrollDelta(Offset delta);

  // Check if gesture is supported
  bool supportsGesture(GestureType type);

  // Get platform-specific cursor for action
  MouseCursor cursorForAction(CursorAction action);
}

enum GestureType {
  tap, doubleTap, longPress,
  swipe, flick,
  pinch, pan, rotate,
  lasso,
  twoFinger, threeFinger,
  hover, rightClick,
}

enum CursorAction {
  defaultCursor,
  pointer,     // Clickable element
  grab,        // Draggable element
  grabbing,    // Currently dragging
  crosshair,   // Lasso/selection mode
  zoomIn,
  zoomOut,
  move,        // Pan
  notAllowed,
}
```

### TouchAdapter

```dart
/// lib/core/input/adapters/touch_adapter.dart

class TouchAdapter implements InputAdapter {
  @override
  InputMode get mode => InputMode.touch;

  @override
  Offset normalizeScrollDelta(Offset delta) => delta;

  @override
  bool supportsGesture(GestureType type) {
    return switch (type) {
      GestureType.hover => false,
      GestureType.rightClick => false,
      _ => true,
    };
  }

  @override
  MouseCursor cursorForAction(CursorAction action) {
    // Touch doesn't have cursors
    return MouseCursor.defer;
  }
}
```

### TrackpadAdapter

```dart
/// lib/core/input/adapters/trackpad_adapter.dart

class TrackpadAdapter implements InputAdapter {
  @override
  InputMode get mode => InputMode.trackpad;

  @override
  Offset normalizeScrollDelta(Offset delta) {
    // macOS trackpad has inverted natural scrolling by default
    return Platform.isMacOS ? delta : Offset(delta.dx, -delta.dy);
  }

  @override
  bool supportsGesture(GestureType type) {
    return switch (type) {
      GestureType.flick => false,  // No velocity on trackpad scroll
      GestureType.lasso => true,   // Via click+drag
      _ => true,
    };
  }

  @override
  MouseCursor cursorForAction(CursorAction action) {
    return switch (action) {
      CursorAction.pointer => SystemMouseCursors.click,
      CursorAction.grab => SystemMouseCursors.grab,
      CursorAction.grabbing => SystemMouseCursors.grabbing,
      CursorAction.crosshair => SystemMouseCursors.precise,
      CursorAction.zoomIn => SystemMouseCursors.zoomIn,
      CursorAction.zoomOut => SystemMouseCursors.zoomOut,
      CursorAction.move => SystemMouseCursors.move,
      CursorAction.notAllowed => SystemMouseCursors.forbidden,
      _ => SystemMouseCursors.basic,
    };
  }
}
```

### MouseAdapter

```dart
/// lib/core/input/adapters/mouse_adapter.dart

class MouseAdapter implements InputAdapter {
  @override
  InputMode get mode => InputMode.mouse;

  @override
  Offset normalizeScrollDelta(Offset delta) {
    // Mouse scroll is typically in "lines" not pixels
    return delta * GestureSettings.scrollMultiplier;
  }

  @override
  bool supportsGesture(GestureType type) {
    return switch (type) {
      GestureType.pinch => false,      // Use scroll wheel instead
      GestureType.rotate => false,     // Not available
      GestureType.twoFinger => false,
      GestureType.threeFinger => false,
      _ => true,
    };
  }

  @override
  MouseCursor cursorForAction(CursorAction action) {
    return switch (action) {
      CursorAction.pointer => SystemMouseCursors.click,
      CursorAction.grab => SystemMouseCursors.grab,
      CursorAction.grabbing => SystemMouseCursors.grabbing,
      CursorAction.crosshair => SystemMouseCursors.precise,
      CursorAction.zoomIn => SystemMouseCursors.zoomIn,
      CursorAction.zoomOut => SystemMouseCursors.zoomOut,
      CursorAction.move => SystemMouseCursors.move,
      CursorAction.notAllowed => SystemMouseCursors.forbidden,
      _ => SystemMouseCursors.basic,
    };
  }
}
```

---

## Unified Widgets

### UnifiedGestureDetector

```dart
/// lib/core/input/widgets/unified_gesture_detector.dart

class UnifiedGestureDetector extends StatefulWidget {
  final Widget child;

  // Single pointer
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final void Function(Offset position)? onLongPressStart;
  final void Function(Offset position)? onLongPressMoveUpdate;
  final VoidCallback? onLongPressEnd;

  // Swipe/Flick
  final SwipeCallback? onSwipe;
  final FlickCallback? onFlick;

  // Scale
  final void Function(ScaleStartDetails)? onScaleStart;
  final void Function(ScaleUpdateDetails)? onScaleUpdate;
  final void Function(ScaleEndDetails)? onScaleEnd;

  // Multi-touch
  final MultiTouchCallback? onTwoFingerStart;
  final MultiTouchCallback? onTwoFingerUpdate;
  final MultiTouchCallback? onTwoFingerEnd;
  final MultiTouchCallback? onThreeFingerStart;
  final MultiTouchCallback? onThreeFingerUpdate;
  final MultiTouchCallback? onThreeFingerEnd;

  // Lasso
  final LassoCallback? onLassoStart;
  final LassoCallback? onLassoUpdate;
  final LassoCallback? onLassoEnd;

  // Mouse-specific
  final void Function(PointerHoverEvent)? onHover;
  final void Function(PointerHoverEvent)? onHoverExit;
  final VoidCallback? onSecondaryTap;  // Right click
  final void Function(Offset)? onSecondaryTapDown;
  final void Function(PointerScrollEvent)? onScroll;

  // Cursor
  final CursorAction cursor;

  const UnifiedGestureDetector({
    super.key,
    required this.child,
    this.onTap,
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
  });

  @override
  State<UnifiedGestureDetector> createState() => _UnifiedGestureDetectorState();
}

class _UnifiedGestureDetectorState extends State<UnifiedGestureDetector> {
  late final InputModeProvider _inputMode;
  late final InputAdapter _adapter;

  @override
  void initState() {
    super.initState();
    _inputMode = InputModeProvider();
    _updateAdapter();
  }

  void _updateAdapter() {
    _adapter = switch (_inputMode.currentMode) {
      InputMode.touch => TouchAdapter(),
      InputMode.trackpad => TrackpadAdapter(),
      InputMode.mouse => MouseAdapter(),
      _ => TouchAdapter(),
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    // Wrap with mouse region for hover/cursor (desktop only)
    if (_inputMode.isPointer) {
      child = MouseRegion(
        cursor: _adapter.cursorForAction(widget.cursor),
        onHover: widget.onHover,
        onExit: widget.onHoverExit,
        child: child,
      );
    }

    // Wrap with listener for scroll and input mode detection
    child = Listener(
      onPointerDown: (e) => _inputMode.updateFromPointerEvent(e),
      onPointerSignal: (event) {
        if (event is PointerScrollEvent && widget.onScroll != null) {
          widget.onScroll!(event);
        }
      },
      child: child,
    );

    // Multi-touch (3-finger)
    if (widget.onThreeFingerStart != null ||
        widget.onThreeFingerUpdate != null ||
        widget.onThreeFingerEnd != null) {
      child = MultiTouchRecognizer(
        requiredPointers: 3,
        onMultiTouchStart: widget.onThreeFingerStart,
        onMultiTouchUpdate: widget.onThreeFingerUpdate,
        onMultiTouchEnd: widget.onThreeFingerEnd,
        child: child,
      );
    }

    // Multi-touch (2-finger) - separate from scale
    if (widget.onTwoFingerStart != null ||
        widget.onTwoFingerUpdate != null ||
        widget.onTwoFingerEnd != null) {
      child = MultiTouchRecognizer(
        requiredPointers: 2,
        onMultiTouchStart: widget.onTwoFingerStart,
        onMultiTouchUpdate: widget.onTwoFingerUpdate,
        onMultiTouchEnd: widget.onTwoFingerEnd,
        child: child,
      );
    }

    // Build gesture map for RawGestureDetector
    final gestures = <Type, GestureRecognizerFactory>{};

    if (widget.onFlick != null) {
      gestures[FlickRecognizer] = GestureRecognizerFactoryWithHandlers<FlickRecognizer>(
        () => FlickRecognizer(),
        (recognizer) => recognizer.onFlick = widget.onFlick,
      );
    }

    if (widget.onSwipe != null) {
      gestures[DirectionalSwipeRecognizer] = GestureRecognizerFactoryWithHandlers<DirectionalSwipeRecognizer>(
        () => DirectionalSwipeRecognizer(),
        (recognizer) => recognizer.onSwipe = widget.onSwipe,
      );
    }

    if (widget.onLassoStart != null || widget.onLassoUpdate != null || widget.onLassoEnd != null) {
      gestures[LassoRecognizer] = GestureRecognizerFactoryWithHandlers<LassoRecognizer>(
        () => LassoRecognizer(),
        (recognizer) {
          recognizer.onLassoStart = widget.onLassoStart;
          recognizer.onLassoUpdate = widget.onLassoUpdate;
          recognizer.onLassoEnd = widget.onLassoEnd;
        },
      );
    }

    if (gestures.isNotEmpty) {
      child = RawGestureDetector(
        gestures: gestures,
        child: child,
      );
    }

    // Standard GestureDetector for common gestures
    return GestureDetector(
      onTap: widget.onTap,
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
}
```

### HoverBuilder

```dart
/// lib/core/input/widgets/hover_builder.dart

class HoverBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool isHovered) builder;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;
  final MouseCursor cursor;

  const HoverBuilder({
    super.key,
    required this.builder,
    this.onEnter,
    this.onExit,
    this.cursor = SystemMouseCursors.basic,
  });

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) {
        setState(() => _isHovered = true);
        widget.onEnter?.call();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        widget.onExit?.call();
      },
      child: widget.builder(context, _isHovered),
    );
  }
}
```

### KeyboardShortcuts

```dart
/// lib/core/input/widgets/keyboard_shortcuts.dart

class AppShortcuts {
  // Global shortcuts
  static final commandPalette = SingleActivator(
    LogicalKeyboardKey.keyK,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );

  static const escape = SingleActivator(LogicalKeyboardKey.escape);
  static const enter = SingleActivator(LogicalKeyboardKey.enter);
  static const space = SingleActivator(LogicalKeyboardKey.space);

  // Navigation
  static const arrowUp = SingleActivator(LogicalKeyboardKey.arrowUp);
  static const arrowDown = SingleActivator(LogicalKeyboardKey.arrowDown);
  static const arrowLeft = SingleActivator(LogicalKeyboardKey.arrowLeft);
  static const arrowRight = SingleActivator(LogicalKeyboardKey.arrowRight);

  // Zoom
  static final zoomIn = SingleActivator(
    LogicalKeyboardKey.equal,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );
  static final zoomOut = SingleActivator(
    LogicalKeyboardKey.minus,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );
  static final zoomReset = SingleActivator(
    LogicalKeyboardKey.digit0,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );

  // Selection
  static final selectAll = SingleActivator(
    LogicalKeyboardKey.keyA,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );
}

class KeyboardShortcutWrapper extends StatelessWidget {
  final Widget child;
  final Map<ShortcutActivator, VoidCallback> shortcuts;

  const KeyboardShortcutWrapper({
    super.key,
    required this.child,
    required this.shortcuts,
  });

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: shortcuts,
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }
}
```

---

## Testing Utilities

```dart
/// lib/core/input/testing/gesture_test_helpers.dart

extension GestureTestExtensions on WidgetTester {
  /// Simulate a flick gesture
  Future<void> flick(Finder finder, Offset delta, {Duration duration = const Duration(milliseconds: 100)}) async {
    final center = getCenter(finder);
    await fling(finder, delta, delta.distance / (duration.inMilliseconds / 1000));
  }

  /// Simulate a two-finger gesture
  Future<void> twoFingerDrag(Finder finder, Offset delta) async {
    final center = getCenter(finder);
    final pointer1 = TestPointer(1);
    final pointer2 = TestPointer(2);

    await sendEventToBinding(pointer1.down(center + const Offset(-20, 0)));
    await sendEventToBinding(pointer2.down(center + const Offset(20, 0)));
    await pump();

    await sendEventToBinding(pointer1.move(center + const Offset(-20, 0) + delta));
    await sendEventToBinding(pointer2.move(center + const Offset(20, 0) + delta));
    await pump();

    await sendEventToBinding(pointer1.up());
    await sendEventToBinding(pointer2.up());
    await pump();
  }

  /// Simulate a three-finger pull-down
  Future<void> threeFingerPullDown(Finder finder) async {
    final center = getCenter(finder);
    final pointers = [TestPointer(1), TestPointer(2), TestPointer(3)];
    final offsets = [const Offset(-30, 0), Offset.zero, const Offset(30, 0)];

    // Down
    for (var i = 0; i < 3; i++) {
      await sendEventToBinding(pointers[i].down(center + offsets[i]));
    }
    await pump();

    // Move down
    for (var i = 0; i < 3; i++) {
      await sendEventToBinding(pointers[i].move(center + offsets[i] + const Offset(0, 100)));
    }
    await pump();

    // Up
    for (var i = 0; i < 3; i++) {
      await sendEventToBinding(pointers[i].up());
    }
    await pump();
  }
}
```

---

## Approval

- [x] Reviewed by: Anton
- [x] Approved on: 2026-05-24
- [x] Notes: Foundation for extended mechanics gestures
