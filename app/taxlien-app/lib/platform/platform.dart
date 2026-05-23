import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

/// Detected platform type.
enum AppPlatform {
  /// iOS device (iPhone, iPad)
  ios,

  /// Android device
  android,

  /// Web browser
  web,

  /// macOS desktop
  macos,

  /// Windows desktop
  windows,

  /// Linux desktop
  linux,

  /// Unknown platform
  unknown,
}

/// Platform detection and capabilities.
abstract final class AppPlatformInfo {
  /// The current platform.
  static AppPlatform get current {
    if (kIsWeb) return AppPlatform.web;
    if (Platform.isIOS) return AppPlatform.ios;
    if (Platform.isAndroid) return AppPlatform.android;
    if (Platform.isMacOS) return AppPlatform.macos;
    if (Platform.isWindows) return AppPlatform.windows;
    if (Platform.isLinux) return AppPlatform.linux;
    return AppPlatform.unknown;
  }

  /// Whether we're on a mobile device (iOS or Android).
  static bool get isMobile =>
      current == AppPlatform.ios || current == AppPlatform.android;

  /// Whether we're on a desktop platform (macOS, Windows, Linux).
  static bool get isDesktop =>
      current == AppPlatform.macos ||
      current == AppPlatform.windows ||
      current == AppPlatform.linux;

  /// Whether we're on the web.
  static bool get isWeb => current == AppPlatform.web;

  /// Whether push notifications are supported.
  static bool get supportsPushNotifications =>
      current == AppPlatform.ios ||
      current == AppPlatform.android ||
      current == AppPlatform.macos;

  /// Whether local notifications are supported.
  static bool get supportsLocalNotifications =>
      current == AppPlatform.ios ||
      current == AppPlatform.android ||
      current == AppPlatform.macos ||
      current == AppPlatform.windows ||
      current == AppPlatform.linux;

  /// Whether system tray is supported.
  static bool get supportsSystemTray =>
      current == AppPlatform.macos ||
      current == AppPlatform.windows ||
      current == AppPlatform.linux;

  /// Whether app badges are supported.
  static bool get supportsAppBadge =>
      current == AppPlatform.ios || current == AppPlatform.macos;

  /// Whether window management is supported.
  static bool get supportsWindowManagement => isDesktop;

  /// Whether the app can run in the background.
  static bool get supportsBackgroundExecution =>
      current == AppPlatform.ios ||
      current == AppPlatform.android ||
      isDesktop;

  /// Whether deep links are supported.
  static bool get supportsDeepLinks =>
      current == AppPlatform.ios ||
      current == AppPlatform.android ||
      current == AppPlatform.macos;

  /// The platform name for display.
  static String get displayName => switch (current) {
        AppPlatform.ios => 'iOS',
        AppPlatform.android => 'Android',
        AppPlatform.web => 'Web',
        AppPlatform.macos => 'macOS',
        AppPlatform.windows => 'Windows',
        AppPlatform.linux => 'Linux',
        AppPlatform.unknown => 'Unknown',
      };
}

/// Extension methods for AppPlatform enum.
extension AppPlatformExtension on AppPlatform {
  /// Whether this is a mobile platform.
  bool get isMobile => this == AppPlatform.ios || this == AppPlatform.android;

  /// Whether this is a desktop platform.
  bool get isDesktop =>
      this == AppPlatform.macos ||
      this == AppPlatform.windows ||
      this == AppPlatform.linux;

  /// Whether this is web.
  bool get isWeb => this == AppPlatform.web;

  /// Whether this is Apple platform (iOS or macOS).
  bool get isApple => this == AppPlatform.ios || this == AppPlatform.macos;
}
