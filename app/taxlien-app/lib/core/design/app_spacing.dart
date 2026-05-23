import 'package:flutter/material.dart';

/// Spacing tokens from VPN Client Pro design system
class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  static const double pageGutter = 30;
  static const double rowGutter = 14;

  // Common EdgeInsets
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalPage = EdgeInsets.symmetric(horizontal: pageGutter);

  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);

  // Galaxy-specific
  static const double galaxyPointMinRadius = 8;
  static const double galaxyPointMaxRadius = 48;
  static const double galaxyClusterMinDistance = 20;
  static const double galaxyLassoTolerance = 10;
  static const double galaxyMinFingerSeparation = 50;
}
