import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// macOS native menu bar configuration.
///
/// Uses macos_ui or native channels for the actual implementation.
/// This is a stub that should be connected to the real implementation.
abstract final class MacOSMenuBar {
  /// Set up the macOS menu bar.
  static Future<void> setup({
    required String appName,
    VoidCallback? onPreferences,
    VoidCallback? onNewSearch,
    VoidCallback? onExport,
    VoidCallback? onGalaxy,
    VoidCallback? onList,
    VoidCallback? onWatchlist,
    VoidCallback? onHelp,
  }) async {
    // TODO: Use PlatformMenuBar widget or macos_ui package
    // This would be called from main.dart after MaterialApp is set up

    // Example using PlatformMenuBar (Flutter 3.0+):
    // PlatformMenuBar(
    //   menus: [
    //     PlatformMenu(
    //       label: appName,
    //       menus: [
    //         PlatformMenuItemGroup(
    //           members: [
    //             PlatformMenuItem(
    //               label: 'About $appName',
    //               onSelected: () => _showAbout(),
    //             ),
    //           ],
    //         ),
    //         PlatformMenuItemGroup(
    //           members: [
    //             PlatformMenuItem(
    //               label: 'Preferences...',
    //               shortcut: SingleActivator(LogicalKeyboardKey.comma, meta: true),
    //               onSelected: onPreferences,
    //             ),
    //           ],
    //         ),
    //         PlatformMenuItemGroup(
    //           members: [
    //             PlatformMenuItem(
    //               label: 'Quit $appName',
    //               shortcut: SingleActivator(LogicalKeyboardKey.keyQ, meta: true),
    //               onSelected: () => SystemNavigator.pop(),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //     PlatformMenu(
    //       label: 'File',
    //       menus: [
    //         PlatformMenuItem(
    //           label: 'New Search',
    //           shortcut: SingleActivator(LogicalKeyboardKey.keyN, meta: true),
    //           onSelected: onNewSearch,
    //         ),
    //         PlatformMenuItem(
    //           label: 'Export...',
    //           shortcut: SingleActivator(LogicalKeyboardKey.keyE, meta: true),
    //           onSelected: onExport,
    //         ),
    //       ],
    //     ),
    //     PlatformMenu(
    //       label: 'View',
    //       menus: [
    //         PlatformMenuItem(
    //           label: 'Galaxy',
    //           shortcut: SingleActivator(LogicalKeyboardKey.digit1, meta: true),
    //           onSelected: onGalaxy,
    //         ),
    //         PlatformMenuItem(
    //           label: 'List',
    //           shortcut: SingleActivator(LogicalKeyboardKey.digit2, meta: true),
    //           onSelected: onList,
    //         ),
    //         PlatformMenuItem(
    //           label: 'Watchlist',
    //           shortcut: SingleActivator(LogicalKeyboardKey.digit3, meta: true),
    //           onSelected: onWatchlist,
    //         ),
    //       ],
    //     ),
    //     PlatformMenu(
    //       label: 'Window',
    //       menus: [
    //         PlatformMenuItem(
    //           label: 'Minimize',
    //           shortcut: SingleActivator(LogicalKeyboardKey.keyM, meta: true),
    //           onSelected: () => _minimize(),
    //         ),
    //         PlatformMenuItem(
    //           label: 'Zoom',
    //           onSelected: () => _zoom(),
    //         ),
    //       ],
    //     ),
    //     PlatformMenu(
    //       label: 'Help',
    //       menus: [
    //         PlatformMenuItem(
    //           label: 'Deal Detective Help',
    //           onSelected: onHelp,
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }
}

/// Keyboard shortcuts for macOS.
abstract final class MacOSShortcuts {
  /// Cmd+, for preferences.
  static const preferences = SingleActivator(
    LogicalKeyboardKey.comma,
    meta: true,
  );

  /// Cmd+N for new search.
  static const newSearch = SingleActivator(
    LogicalKeyboardKey.keyN,
    meta: true,
  );

  /// Cmd+E for export.
  static const export = SingleActivator(
    LogicalKeyboardKey.keyE,
    meta: true,
  );

  /// Cmd+1 for galaxy view.
  static const galaxyView = SingleActivator(
    LogicalKeyboardKey.digit1,
    meta: true,
  );

  /// Cmd+2 for list view.
  static const listView = SingleActivator(
    LogicalKeyboardKey.digit2,
    meta: true,
  );

  /// Cmd+3 for watchlist.
  static const watchlist = SingleActivator(
    LogicalKeyboardKey.digit3,
    meta: true,
  );

  /// Cmd+F for find/search.
  static const find = SingleActivator(
    LogicalKeyboardKey.keyF,
    meta: true,
  );

  /// Cmd+W to close window/tab.
  static const closeWindow = SingleActivator(
    LogicalKeyboardKey.keyW,
    meta: true,
  );
}
