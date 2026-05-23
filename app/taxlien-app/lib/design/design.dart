/// Tax Lien App Design System
///
/// Unified design tokens and theme for the Tax Lien App.
/// Based on VPN Client Pro design system, adapted for tax lien domain.
///
/// Usage:
/// ```dart
/// import 'package:taxlien_swipe_app/design/design.dart';
///
/// // Access colors
/// Container(color: AppColors.brandBlue);
///
/// // Access typography
/// Text('Hello', style: AppTypography.title);
///
/// // Access spacing
/// Padding(padding: EdgeInsets.all(AppSpacing.md));
///
/// // Use theme
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
/// ```
library;

export 'app_colors.dart';
export 'app_typography.dart';
export 'app_spacing.dart';
export 'app_radius.dart';
export 'app_shadows.dart';
export 'app_sizes.dart';
export 'app_breakpoints.dart';
export 'app_theme.dart';
export 'extensions/extensions.dart';
