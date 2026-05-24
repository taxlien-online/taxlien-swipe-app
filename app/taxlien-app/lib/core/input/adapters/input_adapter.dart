import 'package:flutter/services.dart';
import '../providers/input_mode_provider.dart';

/// Types of gestures that may or may not be supported per platform.
enum GestureType {
  tap,
  doubleTap,
  longPress,
  swipe,
  flick,
  pinch,
  pan,
  rotate,
  lasso,
  twoFinger,
  threeFinger,
  fourFinger,
  hover,
  rightClick,
  scroll,
}

/// Cursor actions that can be mapped to platform cursors.
enum CursorAction {
  /// Default cursor for the platform.
  defaultCursor,

  /// Clickable element (hand pointer).
  pointer,

  /// Draggable element (open hand).
  grab,

  /// Currently dragging (closed hand).
  grabbing,

  /// Precision selection (crosshair).
  crosshair,

  /// Zoom in available.
  zoomIn,

  /// Zoom out available.
  zoomOut,

  /// Can move/pan.
  move,

  /// Action not allowed.
  notAllowed,

  /// Text can be selected.
  text,

  /// Resizing horizontally.
  resizeHorizontal,

  /// Resizing vertically.
  resizeVertical,
}

/// Abstract adapter for platform-specific input handling.
///
/// Implementations normalize scroll behavior, gesture support,
/// and cursor mappings across different input devices.
abstract class InputAdapter {
  /// The input mode this adapter handles.
  InputMode get mode;

  /// Normalize scroll delta for this platform.
  ///
  /// Different platforms report scroll in different units
  /// (lines vs pixels) and directions (natural scrolling).
  Offset normalizeScrollDelta(Offset delta);

  /// Check if a gesture type is supported by this input mode.
  bool supportsGesture(GestureType type);

  /// Get the appropriate cursor for an action.
  MouseCursor cursorForAction(CursorAction action);

  /// Factory to get appropriate adapter for current mode.
  static InputAdapter forMode(InputMode mode) {
    return switch (mode) {
      InputMode.touch => const TouchAdapter(),
      InputMode.trackpad => const TrackpadAdapter(),
      InputMode.mouse => const MouseAdapter(),
      InputMode.stylus => const TouchAdapter(), // Stylus behaves like touch
      InputMode.keyboard => const MouseAdapter(), // Fallback to mouse
    };
  }
}

/// Adapter for touch input (iOS/Android).
class TouchAdapter implements InputAdapter {
  const TouchAdapter();

  @override
  InputMode get mode => InputMode.touch;

  @override
  Offset normalizeScrollDelta(Offset delta) => delta;

  @override
  bool supportsGesture(GestureType type) {
    return switch (type) {
      GestureType.hover => false,
      GestureType.rightClick => false,
      GestureType.scroll => false, // Touch scrolls via pan
      _ => true,
    };
  }

  @override
  MouseCursor cursorForAction(CursorAction action) {
    // Touch doesn't have cursors
    return MouseCursor.defer;
  }
}

/// Adapter for trackpad input (macOS/laptops).
class TrackpadAdapter implements InputAdapter {
  const TrackpadAdapter();

  @override
  InputMode get mode => InputMode.trackpad;

  @override
  Offset normalizeScrollDelta(Offset delta) {
    // Trackpad scroll is already in natural direction on macOS
    return delta;
  }

  @override
  bool supportsGesture(GestureType type) {
    return switch (type) {
      GestureType.flick => false, // No velocity on trackpad scroll
      GestureType.fourFinger => false, // Reserved for system
      _ => true,
    };
  }

  @override
  MouseCursor cursorForAction(CursorAction action) {
    return switch (action) {
      CursorAction.defaultCursor => SystemMouseCursors.basic,
      CursorAction.pointer => SystemMouseCursors.click,
      CursorAction.grab => SystemMouseCursors.grab,
      CursorAction.grabbing => SystemMouseCursors.grabbing,
      CursorAction.crosshair => SystemMouseCursors.precise,
      CursorAction.zoomIn => SystemMouseCursors.zoomIn,
      CursorAction.zoomOut => SystemMouseCursors.zoomOut,
      CursorAction.move => SystemMouseCursors.move,
      CursorAction.notAllowed => SystemMouseCursors.forbidden,
      CursorAction.text => SystemMouseCursors.text,
      CursorAction.resizeHorizontal => SystemMouseCursors.resizeLeftRight,
      CursorAction.resizeVertical => SystemMouseCursors.resizeUpDown,
    };
  }
}

/// Adapter for mouse input (desktop).
class MouseAdapter implements InputAdapter {
  const MouseAdapter();

  @override
  InputMode get mode => InputMode.mouse;

  @override
  Offset normalizeScrollDelta(Offset delta) {
    // Mouse scroll wheel reports in "lines", multiply for smooth scroll
    return delta * 3.0;
  }

  @override
  bool supportsGesture(GestureType type) {
    return switch (type) {
      GestureType.pinch => false, // Use scroll wheel instead
      GestureType.rotate => false,
      GestureType.twoFinger => false,
      GestureType.threeFinger => false,
      GestureType.fourFinger => false,
      _ => true,
    };
  }

  @override
  MouseCursor cursorForAction(CursorAction action) {
    return switch (action) {
      CursorAction.defaultCursor => SystemMouseCursors.basic,
      CursorAction.pointer => SystemMouseCursors.click,
      CursorAction.grab => SystemMouseCursors.grab,
      CursorAction.grabbing => SystemMouseCursors.grabbing,
      CursorAction.crosshair => SystemMouseCursors.precise,
      CursorAction.zoomIn => SystemMouseCursors.zoomIn,
      CursorAction.zoomOut => SystemMouseCursors.zoomOut,
      CursorAction.move => SystemMouseCursors.move,
      CursorAction.notAllowed => SystemMouseCursors.forbidden,
      CursorAction.text => SystemMouseCursors.text,
      CursorAction.resizeHorizontal => SystemMouseCursors.resizeLeftRight,
      CursorAction.resizeVertical => SystemMouseCursors.resizeUpDown,
    };
  }
}
