import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

/// A menu item for the system tray.
class TrayMenuItem {
  const TrayMenuItem({
    required this.id,
    required this.label,
    this.enabled = true,
    this.isSeparator = false,
  });

  /// Unique identifier for the menu item.
  final String id;

  /// Display label.
  final String label;

  /// Whether the item is enabled.
  final bool enabled;

  /// Whether this is a separator line.
  final bool isSeparator;

  /// Creates a separator menu item.
  static const separator = TrayMenuItem(
    id: '__separator__',
    label: '',
    isSeparator: true,
  );
}

/// Abstract system tray service for desktop platforms.
///
/// Only works on macOS, Windows, and Linux.
abstract class TrayService {
  /// Initialize the tray service.
  Future<void> initialize();

  /// Update the tray menu items.
  Future<void> updateMenu(List<TrayMenuItem> items);

  /// Update the tray tooltip text.
  Future<void> updateTooltip(String tooltip);

  /// Set a badge count on the tray icon.
  ///
  /// Pass null to remove the badge.
  Future<void> setBadge(int? count);

  /// Set the tray icon image.
  Future<void> setIcon(String assetPath);

  /// Show the app window.
  Future<void> showWindow();

  /// Hide the app to tray.
  Future<void> hideToTray();

  /// Stream of menu item clicks.
  Stream<String> get onMenuItemClicked;

  /// Dispose of resources.
  Future<void> dispose();

  /// Factory to get the appropriate implementation.
  factory TrayService() {
    if (kIsWeb) {
      return _NoOpTrayService();
    }
    if (!_isDesktop) {
      return _NoOpTrayService();
    }
    // On real implementation, return platform-specific service
    return _NoOpTrayService();
  }

  static bool get _isDesktop {
    if (kIsWeb) return false;
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }
}

/// No-op implementation for unsupported platforms.
class _NoOpTrayService implements TrayService {
  final _controller = StreamController<String>.broadcast();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> updateMenu(List<TrayMenuItem> items) async {}

  @override
  Future<void> updateTooltip(String tooltip) async {}

  @override
  Future<void> setBadge(int? count) async {}

  @override
  Future<void> setIcon(String assetPath) async {}

  @override
  Future<void> showWindow() async {}

  @override
  Future<void> hideToTray() async {}

  @override
  Stream<String> get onMenuItemClicked => _controller.stream;

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}

/// Default tray menu items for the app.
List<TrayMenuItem> defaultTrayMenu({bool hasNewItems = false}) {
  return [
    TrayMenuItem(
      id: 'show_window',
      label: 'Show Deal Detective',
    ),
    TrayMenuItem.separator,
    TrayMenuItem(
      id: 'galaxy',
      label: 'Open Galaxy View',
    ),
    TrayMenuItem(
      id: 'watchlist',
      label: hasNewItems ? 'Watchlist (New!)' : 'Watchlist',
    ),
    TrayMenuItem.separator,
    TrayMenuItem(
      id: 'preferences',
      label: 'Preferences...',
    ),
    TrayMenuItem.separator,
    TrayMenuItem(
      id: 'quit',
      label: 'Quit',
    ),
  ];
}
