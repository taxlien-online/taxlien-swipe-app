import 'package:flutter/material.dart';

/// Design system border radius tokens for Tax Lien App.
/// Source: designsystem/colors_and_type.css
abstract final class AppRadius {
  // ─── Raw Values ──────────────────────────────────────────────

  /// 8px - Small elements
  static const double smValue = 8;

  /// 10px - Cards (Figma uses 10)
  static const double mdValue = 10;

  /// 16px - Large cards, panels
  static const double lgValue = 16;

  /// 20px - Modals
  static const double xlValue = 20;

  /// 999px - Badges, pills
  static const double pillValue = 999;

  // ─── BorderRadius Presets ────────────────────────────────────

  /// 8px radius - Small elements
  static const BorderRadius sm = BorderRadius.all(Radius.circular(smValue));

  /// 10px radius - Cards
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdValue));

  /// 16px radius - Large cards, panels, galaxy canvas
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgValue));

  /// 20px radius - Modals
  static const BorderRadius xl = BorderRadius.all(Radius.circular(xlValue));

  /// 999px radius - Badges, pills, HUD elements
  static const BorderRadius pill =
      BorderRadius.all(Radius.circular(pillValue));

  /// 50% radius - Circular buttons, dots
  static const BorderRadius circle =
      BorderRadius.all(Radius.circular(9999));

  /// Custom radius helper
  static BorderRadius custom(double radius) =>
      BorderRadius.all(Radius.circular(radius));
}
