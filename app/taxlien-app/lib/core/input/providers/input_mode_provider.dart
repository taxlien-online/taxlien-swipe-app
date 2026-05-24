import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

/// The current input mode based on the most recent pointer device.
enum InputMode {
  /// Finger on touchscreen (iOS/Android).
  touch,

  /// Laptop/macOS trackpad.
  trackpad,

  /// Desktop mouse.
  mouse,

  /// Pen/stylus input.
  stylus,

  /// Keyboard-only navigation (no pointer events).
  keyboard,
}

/// Extension methods for [InputMode].
extension InputModeExtension on InputMode {
  /// Whether this mode is a pointing device (not keyboard).
  bool get isPointing => this != InputMode.keyboard;

  /// Whether this mode supports hover states.
  bool get supportsHover =>
      this == InputMode.mouse || this == InputMode.trackpad;

  /// Whether this mode supports multi-touch gestures.
  bool get supportsMultiTouch =>
      this == InputMode.touch || this == InputMode.trackpad;

  /// Whether this mode has a visible cursor.
  bool get hasCursor =>
      this == InputMode.mouse || this == InputMode.trackpad;
}

/// Tracks the current input mode based on pointer events.
///
/// Use this to adapt UI based on whether user is using touch, trackpad,
/// or mouse. For example, show hover states only for pointer devices.
///
/// Example:
/// ```dart
/// final inputMode = InputModeProvider();
///
/// Listener(
///   onPointerDown: (e) => inputMode.updateFromPointerEvent(e),
///   child: Builder(
///     builder: (context) {
///       if (inputMode.supportsHover) {
///         return HoverableWidget();
///       }
///       return TouchWidget();
///     },
///   ),
/// )
/// ```
class InputModeProvider extends ChangeNotifier {
  InputMode _currentMode = InputMode.touch;

  /// The current input mode.
  InputMode get currentMode => _currentMode;

  /// Whether current mode is touch.
  bool get isTouch => _currentMode == InputMode.touch;

  /// Whether current mode is a pointer device (mouse or trackpad).
  bool get isPointer =>
      _currentMode == InputMode.mouse || _currentMode == InputMode.trackpad;

  /// Whether current mode supports hover states.
  bool get supportsHover => _currentMode.supportsHover;

  /// Whether current mode supports multi-touch.
  bool get supportsMultiTouch => _currentMode.supportsMultiTouch;

  /// Update the input mode based on a pointer event.
  ///
  /// Call this from a [Listener.onPointerDown] or similar.
  void updateFromPointerEvent(PointerEvent event) {
    final newMode = _modeFromPointerKind(event.kind);

    if (newMode != _currentMode) {
      _currentMode = newMode;
      notifyListeners();
    }
  }

  /// Set mode to keyboard (e.g., when Tab key is pressed).
  void setKeyboardMode() {
    if (_currentMode != InputMode.keyboard) {
      _currentMode = InputMode.keyboard;
      notifyListeners();
    }
  }

  /// Convert [PointerDeviceKind] to [InputMode].
  InputMode _modeFromPointerKind(PointerDeviceKind kind) {
    return switch (kind) {
      PointerDeviceKind.touch => InputMode.touch,
      PointerDeviceKind.mouse => InputMode.mouse,
      PointerDeviceKind.trackpad => InputMode.trackpad,
      PointerDeviceKind.stylus => InputMode.stylus,
      PointerDeviceKind.invertedStylus => InputMode.stylus,
      PointerDeviceKind.unknown => _currentMode, // Keep current
    };
  }
}
