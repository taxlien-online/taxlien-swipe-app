import 'package:flutter/material.dart';

/// Border radius tokens from VPN Client Pro design system
class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 10;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double pill = 999;

  static BorderRadius get cardRadius => BorderRadius.circular(md);
  static BorderRadius get buttonRadius => BorderRadius.circular(pill);
  static BorderRadius get sheetRadius => const BorderRadius.vertical(
        top: Radius.circular(xl),
      );
  static BorderRadius get badgeRadius => BorderRadius.circular(sm);
  static BorderRadius get chipRadius => BorderRadius.circular(pill);

  // Specific components
  static BorderRadius get floatingPanelRadius => BorderRadius.circular(lg);
  static BorderRadius get insightBadgeRadius => BorderRadius.circular(sm);
}
