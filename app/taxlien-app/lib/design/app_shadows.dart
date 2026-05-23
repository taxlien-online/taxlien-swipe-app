import 'package:flutter/material.dart';

/// Design system shadow/elevation tokens for Tax Lien App.
/// Source: designsystem/colors_and_type.css
abstract final class AppShadows {
  /// Standard card shadow - soft, cool, low-opacity halo
  /// Used for: Cards, tiles, bottom nav
  static const List<BoxShadow> card = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 32,
      color: Color(0x1A9CB2C2), // rgba(156,178,194,0.10)
    ),
  ];

  /// Strong card shadow - elevated state
  /// Used for: Floating cards, drag states
  static const List<BoxShadow> cardStrong = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 24,
      color: Color(0x389CB2C2), // rgba(156,178,194,0.22)
    ),
  ];

  /// Modal shadow - dialogs, sheets
  /// Used for: Bottom sheets, modals, command palette
  static const List<BoxShadow> modal = [
    BoxShadow(
      offset: Offset(0, 12),
      blurRadius: 48,
      color: Color(0x33142332), // rgba(20,35,50,0.20)
    ),
  ];

  /// CTA button glow - colored shadow based on button color
  /// Used for: Primary CTA buttons
  static List<BoxShadow> ctaGlow(Color color) => [
        BoxShadow(
          offset: const Offset(0, 8),
          blurRadius: 24,
          color: color.withOpacity(0.22),
        ),
      ];

  /// No shadow
  static const List<BoxShadow> none = [];
}
