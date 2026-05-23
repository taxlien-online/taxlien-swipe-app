import 'package:flutter/material.dart';

/// Responsive breakpoint definitions for adaptive layouts.
enum AppBreakpoint {
  /// < 600px - Phone (single column, bottom nav)
  compact,

  /// 600-839px - Small tablet (two column possible, rail nav)
  medium,

  /// 840-1199px - Large tablet / small desktop (sidebar + content)
  expanded,

  /// 1200-1599px - Desktop (sidebar + content + panel)
  large,

  /// >= 1600px - Wide desktop (three column)
  extraLarge,
}

/// Breakpoint width thresholds and utilities.
abstract final class AppBreakpoints {
  /// Compact breakpoint start (0px)
  static const double compact = 0;

  /// Medium breakpoint start (600px)
  static const double medium = 600;

  /// Expanded breakpoint start (840px)
  static const double expanded = 840;

  /// Large breakpoint start (1200px)
  static const double large = 1200;

  /// Extra large breakpoint start (1600px)
  static const double extraLarge = 1600;

  /// Returns the breakpoint for a given width.
  static AppBreakpoint fromWidth(double width) {
    if (width >= extraLarge) return AppBreakpoint.extraLarge;
    if (width >= large) return AppBreakpoint.large;
    if (width >= expanded) return AppBreakpoint.expanded;
    if (width >= medium) return AppBreakpoint.medium;
    return AppBreakpoint.compact;
  }

  /// Returns the breakpoint for the current context.
  static AppBreakpoint of(BuildContext context) {
    return fromWidth(MediaQuery.sizeOf(context).width);
  }
}

/// Extension methods for breakpoint queries.
extension AppBreakpointExtension on AppBreakpoint {
  /// True if compact (phone).
  bool get isCompact => this == AppBreakpoint.compact;

  /// True if compact or medium (mobile).
  bool get isMobile =>
      this == AppBreakpoint.compact || this == AppBreakpoint.medium;

  /// True if expanded or larger (desktop).
  bool get isDesktop => index >= AppBreakpoint.expanded.index;

  /// True if should show sidebar navigation.
  bool get showSidebar => isDesktop;

  /// True if should show bottom navigation.
  bool get showBottomNav => this == AppBreakpoint.compact;

  /// True if should show navigation rail.
  bool get showRail => this == AppBreakpoint.medium;

  /// True if should show side panel.
  bool get showSidePanel => index >= AppBreakpoint.large.index;

  /// Number of columns for grid layouts.
  int get gridColumns {
    switch (this) {
      case AppBreakpoint.compact:
        return 1;
      case AppBreakpoint.medium:
        return 2;
      case AppBreakpoint.expanded:
        return 2;
      case AppBreakpoint.large:
        return 3;
      case AppBreakpoint.extraLarge:
        return 4;
    }
  }
}
