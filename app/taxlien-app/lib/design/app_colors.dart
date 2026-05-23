import 'package:flutter/material.dart';

/// Design system color tokens for Tax Lien App.
/// Source: designsystem/colors_and_type.css + designlayouts/styles/app.css
abstract final class AppColors {
  // ─── Brand ───────────────────────────────────────────────────
  static const Color brandCyan = Color(0xFF00C6FB);
  static const Color brandBlue = Color(0xFF005BEA);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [brandCyan, brandBlue],
  );

  static const LinearGradient brandGradientSoft = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE6F8FF), Color(0xFFE6EEFD)],
  );

  // ─── Neutrals (Light) ────────────────────────────────────────
  static const Color bg = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color fg1 = Color(0xFF303F49);
  static const Color fg2 = Color(0xFFB6B6B6);
  static const Color fg3 = Color(0xFFA2A2A2);
  static const Color line = Color(0x1A9CB2C2); // rgba(156,178,194,0.1)
  static const Color disabled = Color(0xFFE0E0E0);

  // ─── Neutrals (Dark) ─────────────────────────────────────────
  static const Color bgDark = Color(0xFF0F1419);
  static const Color surfaceDark = Color(0xFF1A2129);
  static const Color surfaceDark2 = Color(0xFF222B33);
  static const Color fg1Dark = Color(0xFFE7ECEF);
  static const Color fg2Dark = Color(0xFF8899A6);
  static const Color lineDark = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const Color switchTrackDark = Color(0xFF3A4750);

  // ─── Semantic ────────────────────────────────────────────────
  static const Color success = Color(0xFF1FB67A);
  static const Color warning = Color(0xFFFFB020);
  static const Color danger = Color(0xFFE5484D);

  // ─── Stage (Property listing stages) ─────────────────────────
  static const Color stagePre = Color(0xFFFFB020);
  static const Color stageListed = Color(0xFF005BEA);
  static const Color stageOtc = Color(0xFF00C6FB);
  static const Color stageSold = Color(0xFFB6B6B6);

  // ─── X-Ray Insight Tints ─────────────────────────────────────
  static const Color xrayWarn = Color(0xFFE5484D);
  static const Color xrayOpp = Color(0xFF1FB67A);
  static const Color xrayEth = Color(0xFF7B5BEA);
  static const Color xrayInfo = Color(0xFF005BEA);

  // ─── Helpers ─────────────────────────────────────────────────

  /// Returns color with specified opacity.
  static Color withOpacity(Color color, double opacity) =>
      color.withOpacity(opacity);

  /// Returns background color for badges based on foreground color.
  static Color badgeBackground(Color foreground) =>
      foreground.withOpacity(0.12);
}
