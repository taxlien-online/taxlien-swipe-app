/// Tax Lien App Widget Library
///
/// Reusable UI components built on the design system.
///
/// Usage:
/// ```dart
/// import 'package:taxlien_swipe_app/widgets/widgets.dart';
///
/// // Use components
/// StatTile(label: 'Value', value: '\$125K');
/// AppBadge(label: 'PRE-AUCTION', tone: BadgeTone.warn);
/// PropertyCard(variant: PropertyCardVariant.compact, ...);
/// ```
library;

// Core components
export 'stat_tile.dart';
export 'app_badge.dart';
export 'grade_badge.dart';
export 'cta_button.dart';
export 'app_icon_button.dart';
export 'hud_pill.dart';
export 'float_panel.dart';

// Galaxy visualization
export 'galaxy_dot.dart';
export 'galaxy_canvas.dart';

// Property display
export 'property_card.dart';

// Navigation
export 'app_top_bar.dart';
export 'app_bottom_nav.dart';

// Notifications
export 'app_toast.dart';

// Adaptive layout
export 'adaptive_scaffold.dart';
export 'app_sidebar.dart';
export 'app_navigation_rail.dart';
