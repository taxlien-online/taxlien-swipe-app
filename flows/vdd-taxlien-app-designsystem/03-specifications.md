# Specifications: Tax Lien App Design System

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-05-24

## Overview

Technical specifications for implementing the Design System in Flutter/Dart. All classes designed for const-constructibility and tree-shaking optimization.

---

## 1. File Structure

```
app/taxlien-app/lib/
├── design/
│   ├── design.dart              # Barrel export
│   ├── app_colors.dart          # Color constants + dark mode
│   ├── app_typography.dart      # TextStyle presets
│   ├── app_spacing.dart         # Spacing constants
│   ├── app_radius.dart          # BorderRadius presets
│   ├── app_shadows.dart         # BoxShadow presets
│   ├── app_sizes.dart           # Standard dimensions
│   ├── app_breakpoints.dart     # Responsive breakpoints
│   ├── app_theme.dart           # ThemeData builder (light + dark)
│   └── extensions/
│       ├── extensions.dart      # Barrel export
│       ├── stage_colors.dart    # Property stage colors
│       ├── risk_colors.dart     # Risk gradient
│       └── xray_colors.dart     # X-Ray insight tints
│
├── widgets/
│   ├── widgets.dart             # Barrel export
│   ├── stat_tile.dart
│   ├── app_badge.dart           # Named to avoid Flutter Badge conflict
│   ├── property_card.dart
│   ├── grade_badge.dart
│   ├── galaxy_dot.dart
│   ├── galaxy_canvas.dart
│   ├── app_top_bar.dart
│   ├── app_bottom_nav.dart
│   ├── float_panel.dart
│   ├── app_icon_button.dart
│   ├── cta_button.dart
│   ├── hud_pill.dart
│   ├── adaptive_scaffold.dart   # Responsive layout shell
│   ├── app_sidebar.dart         # Desktop sidebar nav
│   ├── app_navigation_rail.dart # Tablet rail nav
│   └── app_toast.dart           # In-app notifications
│
├── services/
│   ├── services.dart            # Barrel export
│   ├── notification_service.dart # Push + local notifications
│   └── tray_service.dart        # System tray (desktop)
│
├── platform/
│   ├── platform.dart            # Platform detection
│   ├── macos/
│   │   ├── macos_menu_bar.dart  # Native menu bar
│   │   └── macos_tray.dart      # Menu bar icon
│   ├── windows/
│   │   └── windows_tray.dart    # System tray
│   └── linux/
│       └── linux_tray.dart      # AppIndicator
```

---

## 2. Design Tokens

### 2.1 AppColors

```dart
// lib/design/app_colors.dart

import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
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

  // Neutrals (Light)
  static const Color bg = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color fg1 = Color(0xFF303F49);
  static const Color fg2 = Color(0xFFB6B6B6);
  static const Color fg3 = Color(0xFFA2A2A2);
  static const Color line = Color(0x1A9CB2C2); // rgba(156,178,194,0.1)
  static const Color disabled = Color(0xFFE0E0E0);

  // Neutrals (Dark)
  static const Color bgDark = Color(0xFF0F1419);
  static const Color surfaceDark = Color(0xFF1A2129);
  static const Color surfaceDark2 = Color(0xFF222B33);
  static const Color fg1Dark = Color(0xFFE7ECEF);
  static const Color fg2Dark = Color(0xFF8899A6);
  static const Color lineDark = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const Color switchTrackDark = Color(0xFF3A4750);

  // Semantic
  static const Color success = Color(0xFF1FB67A);
  static const Color warning = Color(0xFFFFB020);
  static const Color danger = Color(0xFFE5484D);

  // Stage
  static const Color stagePre = Color(0xFFFFB020);
  static const Color stageListed = Color(0xFF005BEA);
  static const Color stageOtc = Color(0xFF00C6FB);
  static const Color stageSold = Color(0xFFB6B6B6);

  // X-Ray
  static const Color xrayWarn = Color(0xFFE5484D);
  static const Color xrayOpp = Color(0xFF1FB67A);
  static const Color xrayEth = Color(0xFF7B5BEA);
  static const Color xrayInfo = Color(0xFF005BEA);

  // Helpers
  static Color withOpacity(Color color, double opacity) =>
      color.withOpacity(opacity);
}
```

### 2.2 AppTypography

```dart
// lib/design/app_typography.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  static String get _fontFamily => GoogleFonts.inter().fontFamily!;

  // Timer - FVI mega-number
  static TextStyle get timer => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: -0.01 * 40,
    color: AppColors.fg1,
  );

  // Title - Screen titles
  static TextStyle get title => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.15,
    color: AppColors.fg1,
  );

  // Screen - Section headers
  static TextStyle get screen => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.fg1,
  );

  // Body - Default text
  static TextStyle get body => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.fg1,
  );

  // Button - Button labels
  static TextStyle get button => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.0,
    color: Colors.white,
  );

  // Secondary - Muted labels
  static TextStyle get secondary => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: AppColors.fg2,
  );

  // Label - Stat tile labels
  static TextStyle get label => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0.04 * 14,
    color: AppColors.fg1,
  );

  // Caption - IDs, timestamps
  static TextStyle get caption => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.fg2,
  );

  // Dark mode variants
  static TextStyle timerDark => timer.copyWith(color: AppColors.fg1Dark);
  static TextStyle titleDark => title.copyWith(color: AppColors.fg1Dark);
  static TextStyle screenDark => screen.copyWith(color: AppColors.fg1Dark);
  static TextStyle bodyDark => body.copyWith(color: AppColors.fg1Dark);
  static TextStyle secondaryDark => secondary.copyWith(color: AppColors.fg2Dark);
  static TextStyle labelDark => label.copyWith(color: AppColors.fg1Dark);
  static TextStyle captionDark => caption.copyWith(color: AppColors.fg2Dark);
}
```

### 2.3 AppSpacing

```dart
// lib/design/app_spacing.dart

abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  static const double pageGutter = 30;
  static const double rowGutter = 14;
}
```

### 2.4 AppRadius

```dart
// lib/design/app_radius.dart

import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const double smValue = 8;
  static const double mdValue = 10;
  static const double lgValue = 16;
  static const double xlValue = 20;
  static const double pillValue = 999;

  static const BorderRadius sm = BorderRadius.all(Radius.circular(smValue));
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdValue));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgValue));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(xlValue));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(pillValue));
  static const BorderRadius circle = BorderRadius.all(Radius.circular(9999));

  static BorderRadius custom(double radius) =>
      BorderRadius.all(Radius.circular(radius));
}
```

### 2.5 AppShadows

```dart
// lib/design/app_shadows.dart

import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 32,
      color: Color(0x1A9CB2C2), // rgba(156,178,194,0.10)
    ),
  ];

  static const List<BoxShadow> cardStrong = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 24,
      color: Color(0x389CB2C2), // rgba(156,178,194,0.22)
    ),
  ];

  static const List<BoxShadow> modal = [
    BoxShadow(
      offset: Offset(0, 12),
      blurRadius: 48,
      color: Color(0x33142332), // rgba(20,35,50,0.20)
    ),
  ];

  static List<BoxShadow> ctaGlow(Color color) => [
    BoxShadow(
      offset: const Offset(0, 8),
      blurRadius: 24,
      color: color.withOpacity(0.22),
    ),
  ];
}
```

### 2.6 AppSizes

```dart
// lib/design/app_sizes.dart

abstract final class AppSizes {
  static const double frameWidth = 390;
  static const double frameHeight = 844;
  static const double tileHeight = 64;
  static const double connectButton = 150;
  static const double bottomNavHeight = 92;
  static const double tabStripHeight = 58;
  static const double homeIndicator = 34;
  static const double tabIcon = 44;
  static const double iconButton = 36;
  static const double touchTarget = 44; // Minimum touch target
}
```

---

## 3. Theme Integration

### 3.1 AppTheme

```dart
// lib/design/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.light(
      primary: AppColors.brandBlue,
      secondary: AppColors.brandCyan,
      surface: AppColors.surface,
      background: AppColors.bg,
      error: AppColors.danger,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.fg1,
      onBackground: AppColors.fg1,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: AppTypography.timer,
      headlineLarge: AppTypography.title,
      headlineMedium: AppTypography.screen,
      bodyLarge: AppTypography.body,
      bodyMedium: AppTypography.secondary,
      labelLarge: AppTypography.button,
      labelMedium: AppTypography.label,
      labelSmall: AppTypography.caption,
    ),
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.fg1,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.line,
      thickness: 1,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgDark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.brandBlue,
      secondary: AppColors.brandCyan,
      surface: AppColors.surfaceDark,
      background: AppColors.bgDark,
      error: AppColors.danger,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.fg1Dark,
      onBackground: AppColors.fg1Dark,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: AppTypography.timerDark,
      headlineLarge: AppTypography.titleDark,
      headlineMedium: AppTypography.screenDark,
      bodyLarge: AppTypography.bodyDark,
      bodyMedium: AppTypography.secondaryDark,
      labelLarge: AppTypography.button,
      labelMedium: AppTypography.labelDark,
      labelSmall: AppTypography.captionDark,
    ),
    cardTheme: CardTheme(
      color: AppColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bgDark,
      foregroundColor: AppColors.fg1Dark,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.lineDark,
      thickness: 1,
    ),
  );
}
```

---

## 4. Color Extensions

### 4.1 StageColors

```dart
// lib/design/extensions/stage_colors.dart

import 'package:flutter/material.dart';
import '../app_colors.dart';

enum PropertyStage { preAuction, listed, otc, sold }

extension StageColorsExtension on PropertyStage {
  Color get color => switch (this) {
    PropertyStage.preAuction => AppColors.stagePre,
    PropertyStage.listed => AppColors.stageListed,
    PropertyStage.otc => AppColors.stageOtc,
    PropertyStage.sold => AppColors.stageSold,
  };

  Color get backgroundColor => color.withOpacity(0.12);

  String get label => switch (this) {
    PropertyStage.preAuction => 'PRE-AUCTION',
    PropertyStage.listed => 'LISTED',
    PropertyStage.otc => 'OTC',
    PropertyStage.sold => 'SOLD',
  };
}
```

### 4.2 RiskColors

```dart
// lib/design/extensions/risk_colors.dart

import 'package:flutter/material.dart';
import '../app_colors.dart';

enum RiskLevel { low, medium, high }

extension RiskColorsExtension on RiskLevel {
  Color get color => switch (this) {
    RiskLevel.low => AppColors.success,
    RiskLevel.medium => AppColors.warning,
    RiskLevel.high => AppColors.danger,
  };

  String get label => switch (this) {
    RiskLevel.low => 'LOW RISK',
    RiskLevel.medium => 'MED RISK',
    RiskLevel.high => 'HIGH RISK',
  };
}

abstract final class RiskColors {
  /// Returns interpolated color for risk score 0-100
  static Color fromScore(double score) {
    if (score < 33) {
      return Color.lerp(AppColors.success, AppColors.warning, score / 33)!;
    } else if (score < 66) {
      return Color.lerp(AppColors.warning, AppColors.danger, (score - 33) / 33)!;
    } else {
      return AppColors.danger;
    }
  }

  static RiskLevel levelFromScore(double score) {
    if (score < 33) return RiskLevel.low;
    if (score < 66) return RiskLevel.medium;
    return RiskLevel.high;
  }
}
```

### 4.3 XRayColors

```dart
// lib/design/extensions/xray_colors.dart

import 'package:flutter/material.dart';
import '../app_colors.dart';

enum XRayInsightType { warning, opportunity, ethical, info }

extension XRayColorsExtension on XRayInsightType {
  Color get color => switch (this) {
    XRayInsightType.warning => AppColors.xrayWarn,
    XRayInsightType.opportunity => AppColors.xrayOpp,
    XRayInsightType.ethical => AppColors.xrayEth,
    XRayInsightType.info => AppColors.xrayInfo,
  };

  Color get backgroundColor => color.withOpacity(0.12);

  IconData get icon => switch (this) {
    XRayInsightType.warning => Icons.warning_amber_rounded,
    XRayInsightType.opportunity => Icons.trending_up_rounded,
    XRayInsightType.ethical => Icons.favorite_rounded,
    XRayInsightType.info => Icons.info_outline_rounded,
  };
}
```

---

## 5. Widget Specifications

### 5.1 StatTile

```dart
// lib/widgets/stat_tile.dart

import 'package:flutter/material.dart';

enum StatTileSize { standard, compact }

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.delta,
    this.deltaPositive,
    this.accentColor,
    this.size = StatTileSize.standard,
  });

  final String label;
  final String value;
  final IconData? icon;
  final String? delta;
  final bool? deltaPositive;
  final Color? accentColor;
  final StatTileSize size;

  // Dimensions
  // standard: flex, padding 12, gap 4
  // compact: min-width 80, padding 8

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

### 5.2 AppBadge

```dart
// lib/widgets/app_badge.dart

import 'package:flutter/material.dart';

enum BadgeTone { hot, good, info, warn, purple, cyan, neutral, none }

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.tone = BadgeTone.none,
    this.icon,
  });

  final String label;
  final BadgeTone tone;
  final IconData? icon;

  // Style:
  // fontSize: 10, fontWeight: 600
  // textTransform: uppercase
  // letterSpacing: 0.04em
  // padding: 4h 8v
  // borderRadius: pill (999)

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

### 5.3 PropertyCard

```dart
// lib/widgets/property_card.dart

import 'package:flutter/material.dart';

enum PropertyCardVariant { mini, compact, full }

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.variant,
    required this.address,
    this.county,
    this.parcelId,
    this.imageUrl,
    this.value,
    this.roi,
    this.fvi,
    this.stage,
    this.type,
    this.auctionDate,
    this.riskLevel,
    this.isWatchlisted = false,
    this.onTap,
    this.onWatchlistTap,
    this.onShareTap,
    this.onDetailsTap,
  });

  final PropertyCardVariant variant;
  final String address;
  final String? county;
  final String? parcelId;
  final String? imageUrl;
  final double? value;
  final double? roi;
  final double? fvi;
  final PropertyStage? stage;
  final String? type; // LIEN, DEED, FORECLOSURE
  final DateTime? auctionDate;
  final RiskLevel? riskLevel;
  final bool isWatchlisted;
  final VoidCallback? onTap;
  final VoidCallback? onWatchlistTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onDetailsTap;

  // mini: 100x40, no image
  // compact: height 64, small image
  // full: flexible, large image, all fields

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

### 5.4 GradeBadge

```dart
// lib/widgets/grade_badge.dart

import 'package:flutter/material.dart';

enum GradeBadgeSize { sm, md, lg }

class GradeBadge extends StatelessWidget {
  const GradeBadge({
    super.key,
    required this.grade,
    this.size = GradeBadgeSize.md,
  });

  final String grade; // A+, A, B, C, D, F
  final GradeBadgeSize size;

  // Sizes: sm=20, md=28, lg=36
  // Colors: A/A+=success, B=cyan, C=warning, D=danger, F=darkRed

  Color get _color { /* ... */ }
  double get _size { /* ... */ }

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

### 5.5 GalaxyDot

```dart
// lib/widgets/galaxy_dot.dart

import 'package:flutter/material.dart';

enum GalaxyDotState { normal, selected, hovered, watchlisted }

class GalaxyDot extends StatelessWidget {
  const GalaxyDot({
    super.key,
    required this.x,
    required this.y,
    this.size = 8,
    this.color,
    this.state = GalaxyDotState.normal,
    this.onTap,
  });

  final double x; // 0-100 percentage
  final double y; // 0-100 percentage
  final double size; // 4-16 based on value
  final Color? color;
  final GalaxyDotState state;
  final VoidCallback? onTap;

  // normal: solid circle
  // selected: solid + ring
  // hovered: solid + glow
  // watchlisted: solid + halo

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

### 5.6 GalaxyCanvas

```dart
// lib/widgets/galaxy_canvas.dart

import 'package:flutter/material.dart';

class GalaxyCanvas extends StatelessWidget {
  const GalaxyCanvas({
    super.key,
    required this.dots,
    this.showGrid = true,
    this.onDotTap,
    this.onLassoComplete,
  });

  final List<GalaxyDot> dots;
  final bool showGrid;
  final void Function(int index)? onDotTap;
  final void Function(List<int> indices)? onLassoComplete;

  // Background: linear-gradient(180deg, #F1F4F8 0%, #F8F9FA 60%)
  // Grid: radial-gradient dots, 24px spacing
  // Border-radius: lg (16)
  // Margin: 16 horizontal

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

### 5.7 AppTopBar

```dart
// lib/widgets/app_top_bar.dart

import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

### 5.8 AppBottomNav

```dart
// lib/widgets/app_bottom_nav.dart

import 'package:flutter/material.dart';
import 'dart:ui';

enum AppNavTab { galaxy, list, watchlist, profile }

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  final AppNavTab currentTab;
  final ValueChanged<AppNavTab> onTabChanged;

  // Height: 58px (+ safe area)
  // Background: frosted glass
  // Active: brandBlue fill
  // Inactive: fg2 stroke

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

### 5.9 FloatPanel

```dart
// lib/widgets/float_panel.dart

import 'package:flutter/material.dart';

class FloatPanel extends StatelessWidget {
  const FloatPanel({
    super.key,
    required this.child,
    this.onDismiss,
  });

  final Widget child;
  final VoidCallback? onDismiss;

  // Background: surface
  // Radius: lg (16)
  // Shadow: modal
  // Padding: 14

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

### 5.10 CtaButton

```dart
// lib/widgets/cta_button.dart

import 'package:flutter/material.dart';

enum CtaButtonVariant { primary, ghost }
enum CtaButtonSize { standard, small }

class CtaButton extends StatelessWidget {
  const CtaButton({
    super.key,
    required this.label,
    this.icon,
    this.variant = CtaButtonVariant.primary,
    this.size = CtaButtonSize.standard,
    this.onPressed,
  });

  final String label;
  final IconData? icon;
  final CtaButtonVariant variant;
  final CtaButtonSize size;
  final VoidCallback? onPressed;

  // primary: gradient bg, white text, glow shadow
  // ghost: surface bg, fg1 text, card shadow
  // standard: padding 14v 18h, radius 12
  // small: padding 6v 10h, fontSize 11

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

### 5.11 HudPill

```dart
// lib/widgets/hud_pill.dart

import 'package:flutter/material.dart';
import 'dart:ui';

class HudPill extends StatelessWidget {
  const HudPill({
    super.key,
    required this.label,
    this.dotColor,
    this.icon,
  });

  final String label;
  final Color? dotColor;
  final IconData? icon;

  // Background: frosted (white 86% + blur 20)
  // Radius: pill
  // Shadow: card
  // Dot: 8x8 circle

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

### 5.12 AppIconButton

```dart
// lib/widgets/app_icon_button.dart

import 'package:flutter/material.dart';

enum IconButtonVariant { standard, accent, active }

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.variant = IconButtonVariant.standard,
    this.onPressed,
    this.semanticLabel,
  });

  final IconData icon;
  final IconButtonVariant variant;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  // Size: 36x36
  // Radius: circle
  // standard: surface bg, fg1 icon
  // accent: gradient bg, white icon
  // active: danger bg, white icon

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

---

## 6. Adaptive Layout System

### 6.1 Breakpoints

```dart
// lib/design/app_breakpoints.dart

enum AppBreakpoint { compact, medium, expanded, large, extraLarge }

abstract final class AppBreakpoints {
  static const double compact = 0;
  static const double medium = 600;
  static const double expanded = 840;
  static const double large = 1200;
  static const double extraLarge = 1600;

  static AppBreakpoint fromWidth(double width) {
    if (width >= extraLarge) return AppBreakpoint.extraLarge;
    if (width >= large) return AppBreakpoint.large;
    if (width >= expanded) return AppBreakpoint.expanded;
    if (width >= medium) return AppBreakpoint.medium;
    return AppBreakpoint.compact;
  }
}

extension AppBreakpointExtension on AppBreakpoint {
  bool get isCompact => this == AppBreakpoint.compact;
  bool get isMobile => this == AppBreakpoint.compact || this == AppBreakpoint.medium;
  bool get isDesktop => index >= AppBreakpoint.expanded.index;
  bool get showSidebar => isDesktop;
  bool get showBottomNav => isMobile;
  bool get showRail => this == AppBreakpoint.medium;
}
```

### 6.2 AdaptiveScaffold

```dart
// lib/widgets/adaptive_scaffold.dart

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.currentIndex = 0,
    this.onDestinationSelected,
    this.destinations = const [],
    this.sidePanel,
    this.floatingActionButton,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int>? onDestinationSelected;
  final List<AdaptiveDestination> destinations;
  final Widget? sidePanel;
  final Widget? floatingActionButton;

  // Behavior:
  // compact: BottomNav + body
  // medium: NavigationRail + body
  // expanded+: Sidebar + body + optional sidePanel

  @override
  Widget build(BuildContext context) {
    final breakpoint = AppBreakpoints.fromWidth(
      MediaQuery.sizeOf(context).width,
    );
    // ... adaptive layout logic
  }
}

class AdaptiveDestination {
  const AdaptiveDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badge,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int? badge;
}
```

### 6.3 AppSidebar

```dart
// lib/widgets/app_sidebar.dart

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.collapsed = false,
    this.header,
    this.footer,
  });

  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool collapsed;
  final Widget? header;
  final Widget? footer;

  // Widths: expanded=240, collapsed=72
  // Background: surface
  // Active item: brandBlue bg with opacity

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

### 6.4 AppNavigationRail

```dart
// lib/widgets/app_navigation_rail.dart

class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  // Width: 72
  // Icons centered
  // No labels (tooltip on hover)

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

---

## 7. Notification Components

### 7.1 AppToast

```dart
// lib/widgets/app_toast.dart

enum ToastType { success, error, warning, info }

class AppToast extends StatelessWidget {
  const AppToast({
    super.key,
    required this.message,
    this.type = ToastType.info,
    this.action,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final ToastType type;
  final IconData? action;
  final String? actionLabel;
  final VoidCallback? onAction;

  // Position: bottom center
  // Duration: 4s default
  // Style: surface bg, rounded, shadow

  static void show(BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) { /* ... */ }

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

### 7.2 NotificationService

```dart
// lib/services/notification_service.dart

abstract class NotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<void> showLocal({
    required String title,
    required String body,
    String? payload,
  });
  Future<String?> getToken(); // For push
  Stream<NotificationPayload> get onNotificationTapped;
}

class NotificationPayload {
  final String? propertyId;
  final String? route;
  final Map<String, dynamic>? data;
}
```

---

## 8. System Tray / Menu Bar

### 8.1 TrayService (Desktop only)

```dart
// lib/services/tray_service.dart

import 'dart:io' show Platform;

abstract class TrayService {
  Future<void> initialize();
  Future<void> updateMenu(List<TrayMenuItem> items);
  Future<void> updateTooltip(String tooltip);
  Future<void> setBadge(int? count);
  Stream<String> get onMenuItemClicked;
}

class TrayMenuItem {
  const TrayMenuItem({
    required this.id,
    required this.label,
    this.enabled = true,
    this.isSeparator = false,
  });

  final String id;
  final String label;
  final bool enabled;
  final bool isSeparator;
}

// Platform implementations:
// - MacOSTrayService (system_tray + macos_ui)
// - WindowsTrayService (system_tray)
// - LinuxTrayService (system_tray)
```

### 8.2 Menu Bar Items (macOS)

```dart
// lib/widgets/macos_menu_bar.dart (macOS only)

// Uses macos_ui package for native menu bar
// Menu structure:
// - App name > About, Preferences, Quit
// - File > New Search, Export...
// - View > Galaxy, List, Watchlist
// - Window > Minimize, Zoom
// - Help > Documentation, Support
```

---

## 9. Barrel Exports

### 9.1 design.dart

```dart
// lib/design/design.dart

export 'app_colors.dart';
export 'app_typography.dart';
export 'app_spacing.dart';
export 'app_radius.dart';
export 'app_shadows.dart';
export 'app_sizes.dart';
export 'app_breakpoints.dart';
export 'app_theme.dart';
export 'extensions/extensions.dart';
```

### 9.2 widgets.dart

```dart
// lib/widgets/widgets.dart

// Core components
export 'stat_tile.dart';
export 'app_badge.dart';
export 'property_card.dart';
export 'grade_badge.dart';
export 'galaxy_dot.dart';
export 'galaxy_canvas.dart';
export 'app_top_bar.dart';
export 'app_bottom_nav.dart';
export 'float_panel.dart';
export 'cta_button.dart';
export 'hud_pill.dart';
export 'app_icon_button.dart';

// Adaptive layout
export 'adaptive_scaffold.dart';
export 'app_sidebar.dart';
export 'app_navigation_rail.dart';

// Notifications
export 'app_toast.dart';
```

### 9.3 services.dart

```dart
// lib/services/services.dart

export 'notification_service.dart';
export 'tray_service.dart';
```

---

## 10. Dependencies

```yaml
# pubspec.yaml additions

dependencies:
  google_fonts: ^6.1.0

  # Notifications
  flutter_local_notifications: ^17.0.0
  firebase_messaging: ^14.7.0

  # System tray (desktop)
  system_tray: ^2.0.3

  # macOS specific
  macos_ui: ^2.0.0  # For native macOS widgets

  # Window management (desktop)
  window_manager: ^0.3.7

  # Deep links
  app_links: ^3.5.0
```

---

## 11. Testing Strategy

Each widget requires:
1. **Golden tests** - Visual regression for light/dark themes
2. **Semantic tests** - Accessibility labels present
3. **Interaction tests** - Tap handlers fire correctly
4. **Variant tests** - All enum variants render
5. **Breakpoint tests** - Layout at each breakpoint
6. **Platform tests** - Platform-specific behavior

---

## 12. Edge Cases

| Component | Edge Case | Handling |
|-----------|-----------|----------|
| StatTile | Long value text | Truncate with ellipsis |
| AppBadge | Long label | Max width 120, truncate |
| PropertyCard | Missing image | Show placeholder gradient |
| GalaxyDot | Overlapping dots | Z-index by selection state |
| GalaxyCanvas | 500+ dots | Use CustomPainter for performance |
| AppBottomNav | System dark mode | Respect system preference |
| FloatPanel | Keyboard open | Adjust position above keyboard |
| AdaptiveScaffold | Window resize | Smooth transition between layouts |
| AppSidebar | Very long labels | Truncate, show tooltip |
| Notifications | Permission denied | Graceful fallback, in-app only |
| SystemTray | Not supported (web) | Skip initialization silently |
| DeepLinks | Invalid route | Show 404 or redirect to home |

---

## Approval

- [x] Reviewed by: Anton
- [x] Approved on: 2026-05-24
- [x] Notes: Full adaptive design + notifications + system tray approved
