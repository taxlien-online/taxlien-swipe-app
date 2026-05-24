import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Common keyboard shortcuts used throughout the app.
///
/// Uses Cmd on macOS, Ctrl on other platforms.
class AppShortcuts {
  AppShortcuts._();

  // ============================================
  // Global shortcuts
  // ============================================

  /// Open command palette (Cmd/Ctrl + K).
  static final SingleActivator commandPalette = SingleActivator(
    LogicalKeyboardKey.keyK,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );

  /// Search / Find (Cmd/Ctrl + F).
  static final SingleActivator search = SingleActivator(
    LogicalKeyboardKey.keyF,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );

  /// Close / Cancel.
  static const SingleActivator escape = SingleActivator(LogicalKeyboardKey.escape);

  /// Confirm / Activate.
  static const SingleActivator enter = SingleActivator(LogicalKeyboardKey.enter);

  /// Alternative activate.
  static const SingleActivator space = SingleActivator(LogicalKeyboardKey.space);

  // ============================================
  // Navigation
  // ============================================

  static const SingleActivator arrowUp = SingleActivator(LogicalKeyboardKey.arrowUp);
  static const SingleActivator arrowDown = SingleActivator(LogicalKeyboardKey.arrowDown);
  static const SingleActivator arrowLeft = SingleActivator(LogicalKeyboardKey.arrowLeft);
  static const SingleActivator arrowRight = SingleActivator(LogicalKeyboardKey.arrowRight);

  static const SingleActivator pageUp = SingleActivator(LogicalKeyboardKey.pageUp);
  static const SingleActivator pageDown = SingleActivator(LogicalKeyboardKey.pageDown);
  static const SingleActivator home = SingleActivator(LogicalKeyboardKey.home);
  static const SingleActivator end = SingleActivator(LogicalKeyboardKey.end);

  static const SingleActivator tab = SingleActivator(LogicalKeyboardKey.tab);
  static final SingleActivator shiftTab = SingleActivator(
    LogicalKeyboardKey.tab,
    shift: true,
  );

  // ============================================
  // Zoom
  // ============================================

  /// Zoom in (Cmd/Ctrl + =).
  static final SingleActivator zoomIn = SingleActivator(
    LogicalKeyboardKey.equal,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );

  /// Zoom out (Cmd/Ctrl + -).
  static final SingleActivator zoomOut = SingleActivator(
    LogicalKeyboardKey.minus,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );

  /// Reset zoom (Cmd/Ctrl + 0).
  static final SingleActivator zoomReset = SingleActivator(
    LogicalKeyboardKey.digit0,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );

  // ============================================
  // Selection
  // ============================================

  /// Select all (Cmd/Ctrl + A).
  static final SingleActivator selectAll = SingleActivator(
    LogicalKeyboardKey.keyA,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );

  /// Deselect / Clear selection.
  static final SingleActivator deselect = SingleActivator(
    LogicalKeyboardKey.keyD,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );

  // ============================================
  // Actions
  // ============================================

  /// Save / Bookmark (Cmd/Ctrl + S).
  static final SingleActivator save = SingleActivator(
    LogicalKeyboardKey.keyS,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );

  /// Refresh (Cmd/Ctrl + R).
  static final SingleActivator refresh = SingleActivator(
    LogicalKeyboardKey.keyR,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );

  /// Undo (Cmd/Ctrl + Z).
  static final SingleActivator undo = SingleActivator(
    LogicalKeyboardKey.keyZ,
    meta: Platform.isMacOS,
    control: !Platform.isMacOS,
  );

  /// Delete / Remove.
  static const SingleActivator delete = SingleActivator(LogicalKeyboardKey.delete);
  static const SingleActivator backspace = SingleActivator(LogicalKeyboardKey.backspace);
}

/// Widget that wraps a child with keyboard shortcut handling.
///
/// Example:
/// ```dart
/// KeyboardShortcutWrapper(
///   shortcuts: {
///     AppShortcuts.commandPalette: openCommandPalette,
///     AppShortcuts.escape: closeOverlay,
///     AppShortcuts.zoomIn: () => zoomBy(0.1),
///   },
///   child: MyScreen(),
/// )
/// ```
class KeyboardShortcutWrapper extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// Map of shortcuts to callbacks.
  final Map<ShortcutActivator, VoidCallback> shortcuts;

  /// Whether shortcuts are enabled.
  final bool enabled;

  /// Whether to autofocus this widget.
  final bool autofocus;

  const KeyboardShortcutWrapper({
    super.key,
    required this.child,
    required this.shortcuts,
    this.enabled = true,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled || shortcuts.isEmpty) {
      return child;
    }

    return CallbackShortcuts(
      bindings: shortcuts,
      child: Focus(
        autofocus: autofocus,
        child: child,
      ),
    );
  }
}

/// Widget that handles arrow key navigation in a list.
///
/// Example:
/// ```dart
/// ArrowKeyNavigator(
///   itemCount: items.length,
///   currentIndex: selectedIndex,
///   onIndexChanged: (index) => setState(() => selectedIndex = index),
///   onSelect: (index) => selectItem(items[index]),
///   child: ListView.builder(...),
/// )
/// ```
class ArrowKeyNavigator extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// Total number of items.
  final int itemCount;

  /// Currently selected index.
  final int currentIndex;

  /// Called when index changes via arrow keys.
  final ValueChanged<int> onIndexChanged;

  /// Called when Enter/Space is pressed on current item.
  final ValueChanged<int>? onSelect;

  /// Called when Escape is pressed.
  final VoidCallback? onEscape;

  /// Whether navigation wraps around.
  final bool wrapAround;

  const ArrowKeyNavigator({
    super.key,
    required this.child,
    required this.itemCount,
    required this.currentIndex,
    required this.onIndexChanged,
    this.onSelect,
    this.onEscape,
    this.wrapAround = false,
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcutWrapper(
      autofocus: true,
      shortcuts: {
        AppShortcuts.arrowUp: _moveUp,
        AppShortcuts.arrowDown: _moveDown,
        if (onSelect != null) AppShortcuts.enter: _select,
        if (onSelect != null) AppShortcuts.space: _select,
        if (onEscape != null) AppShortcuts.escape: onEscape!,
      },
      child: child,
    );
  }

  void _moveUp() {
    if (itemCount == 0) return;

    var newIndex = currentIndex - 1;
    if (newIndex < 0) {
      newIndex = wrapAround ? itemCount - 1 : 0;
    }
    onIndexChanged(newIndex);
  }

  void _moveDown() {
    if (itemCount == 0) return;

    var newIndex = currentIndex + 1;
    if (newIndex >= itemCount) {
      newIndex = wrapAround ? 0 : itemCount - 1;
    }
    onIndexChanged(newIndex);
  }

  void _select() {
    if (currentIndex >= 0 && currentIndex < itemCount) {
      onSelect?.call(currentIndex);
    }
  }
}
