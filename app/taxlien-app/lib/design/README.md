# Tax Lien App Design System

A unified design system for the Tax Lien App, based on VPN Client Pro and extended for tax lien domain specifics.

## Quick Start

```dart
import 'package:taxlien_swipe_app/design/design.dart';
import 'package:taxlien_swipe_app/widgets/widgets.dart';

// In your MaterialApp
MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.system,
  // ...
);
```

## Design Tokens

### Colors

```dart
// Brand colors
Container(color: AppColors.brandBlue);
Container(color: AppColors.brandCyan);
Container(decoration: BoxDecoration(gradient: AppColors.brandGradient));

// Semantic colors
Icon(Icons.check, color: AppColors.success);
Icon(Icons.warning, color: AppColors.warning);
Icon(Icons.error, color: AppColors.danger);

// Stage colors (property lifecycle)
AppBadge(label: 'PRE-AUCTION', tone: BadgeTone.warn);  // Orange
AppBadge(label: 'LISTED', tone: BadgeTone.info);       // Blue
AppBadge(label: 'OTC', tone: BadgeTone.cyan);          // Cyan
AppBadge(label: 'SOLD', tone: BadgeTone.neutral);      // Gray

// X-Ray insight colors
XRayInsightType.warning.color;     // Red
XRayInsightType.opportunity.color; // Green
XRayInsightType.ethical.color;     // Purple
XRayInsightType.info.color;        // Blue
```

### Typography

```dart
Text('Large Number', style: AppTypography.timer);     // 40px bold
Text('Screen Title', style: AppTypography.title);     // 24px semibold
Text('Section Header', style: AppTypography.screen);  // 20px semibold
Text('Body text', style: AppTypography.body);         // 17px regular
Text('Muted label', style: AppTypography.secondary);  // 15px regular
Text('STAT LABEL', style: AppTypography.label);       // 14px medium
Text('Caption/ID', style: AppTypography.caption);     // 13px regular

// Dark mode variants are automatic via AppTheme
```

### Spacing

```dart
Padding(padding: EdgeInsets.all(AppSpacing.xxs));  // 4px
Padding(padding: EdgeInsets.all(AppSpacing.xs));   // 8px
Padding(padding: EdgeInsets.all(AppSpacing.sm));   // 12px
Padding(padding: EdgeInsets.all(AppSpacing.md));   // 16px
Padding(padding: EdgeInsets.all(AppSpacing.lg));   // 20px
Padding(padding: EdgeInsets.all(AppSpacing.xl));   // 24px
Padding(padding: EdgeInsets.all(AppSpacing.xxl));  // 32px

// Page margins
Padding(padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter));  // 30px
```

### Border Radius

```dart
Container(decoration: BoxDecoration(borderRadius: AppRadius.sm));   // 8px
Container(decoration: BoxDecoration(borderRadius: AppRadius.md));   // 10px
Container(decoration: BoxDecoration(borderRadius: AppRadius.lg));   // 16px
Container(decoration: BoxDecoration(borderRadius: AppRadius.xl));   // 20px
Container(decoration: BoxDecoration(borderRadius: AppRadius.pill)); // 999px (pill)
```

### Shadows

```dart
Container(decoration: BoxDecoration(boxShadow: AppShadows.card));
Container(decoration: BoxDecoration(boxShadow: AppShadows.cardStrong));
Container(decoration: BoxDecoration(boxShadow: AppShadows.modal));
Container(decoration: BoxDecoration(boxShadow: AppShadows.ctaGlow(AppColors.brandBlue)));
```

## Components

### StatTile

Display labeled statistics with optional icon and delta.

```dart
StatTile(
  label: 'Value',
  value: '\$125K',
)

StatTile(
  label: 'ROI',
  value: '12.5%',
  icon: Icons.trending_up,
  delta: '+3.2%',
  deltaPositive: true,
  accentColor: AppColors.success,
)

StatTile(
  label: 'Tax Owed',
  value: '\$2,450',
  size: StatTileSize.compact,
)
```

### AppBadge

Small status badges/chips.

```dart
AppBadge(label: 'LIEN', tone: BadgeTone.info)
AppBadge(label: 'HIGH RISK', tone: BadgeTone.hot)
AppBadge(label: 'OPPORTUNITY', tone: BadgeTone.good, icon: Icons.star)
```

### GradeBadge

FVI grade indicators.

```dart
GradeBadge(grade: 'A+')  // Green
GradeBadge(grade: 'B', size: GradeBadgeSize.lg)  // Cyan
GradeBadge(grade: 'C', size: GradeBadgeSize.sm)  // Orange
```

### PropertyCard

Property display cards in three variants.

```dart
// Mini - for galaxy dot tooltips
PropertyCard(
  variant: PropertyCardVariant.mini,
  address: '123 Main St',
)

// Compact - for list views
PropertyCard(
  variant: PropertyCardVariant.compact,
  address: '123 Main St',
  county: 'Miami-Dade',
  value: 125000,
  stage: PropertyStage.listed,
)

// Full - for detail panels
PropertyCard(
  variant: PropertyCardVariant.full,
  address: '123 Main St',
  county: 'Miami-Dade, FL',
  parcelId: '12-3456-789',
  imageUrl: 'https://...',
  value: 125000,
  roi: 12.5,
  fvi: 85,
  stage: PropertyStage.listed,
  type: 'LIEN',
  riskLevel: RiskLevel.low,
  isWatchlisted: true,
  onWatchlistTap: () {},
  onShareTap: () {},
  onDetailsTap: () {},
)
```

### CtaButton

Call-to-action buttons.

```dart
CtaButton(
  label: 'Save Property',
  icon: Icons.bookmark,
  onPressed: () {},
)

CtaButton(
  label: 'Share',
  variant: CtaButtonVariant.ghost,
  onPressed: () {},
)

CtaButton(
  label: 'Quick Action',
  size: CtaButtonSize.small,
  onPressed: () {},
)
```

### AppBottomNav

Bottom navigation for mobile.

```dart
AppBottomNav(
  currentTab: AppNavTab.galaxy,
  onTabChanged: (tab) => setState(() => _currentTab = tab),
  badges: {AppNavTab.watchlist: 3},
)
```

### AdaptiveScaffold

Responsive layout that adapts to screen size.

```dart
AdaptiveScaffold(
  body: YourContent(),
  currentIndex: _selectedIndex,
  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
  destinations: [
    AdaptiveDestination(
      icon: Icons.blur_on_outlined,
      selectedIcon: Icons.blur_on,
      label: 'Galaxy',
    ),
    AdaptiveDestination(
      icon: Icons.list_outlined,
      selectedIcon: Icons.list,
      label: 'List',
    ),
    // ...
  ],
)
```

### AppToast

In-app notifications.

```dart
AppToast.show(
  context,
  message: 'Property saved to watchlist',
  type: ToastType.success,
);

AppToast.show(
  context,
  message: 'Network error',
  type: ToastType.error,
  actionLabel: 'Retry',
  onAction: () => _retry(),
);
```

## Breakpoints

The design system uses 5 breakpoints for responsive layouts:

| Breakpoint | Width | Navigation |
|------------|-------|------------|
| compact | 0-599 | Bottom nav |
| medium | 600-839 | Navigation rail |
| expanded | 840-1199 | Sidebar (collapsed) |
| large | 1200-1599 | Sidebar (expanded) |
| extraLarge | 1600+ | Sidebar + side panel |

```dart
final breakpoint = AppBreakpoints.fromWidth(MediaQuery.sizeOf(context).width);

if (breakpoint.isMobile) {
  // Show mobile layout
} else if (breakpoint.isDesktop) {
  // Show desktop layout
}
```

## Platform Features

### Notifications

```dart
final notifications = NotificationService();
await notifications.initialize();
await notifications.requestPermission();

await notifications.showLocal(
  title: 'New Match',
  body: 'A property matching your criteria was found!',
);
```

### System Tray (Desktop)

```dart
final tray = TrayService();
await tray.initialize();
await tray.updateMenu(defaultTrayMenu());

tray.onMenuItemClicked.listen((id) {
  switch (id) {
    case 'show_window': tray.showWindow();
    case 'quit': exit(0);
  }
});
```

## Dark Mode

Dark mode is automatic when using `AppTheme.light` and `AppTheme.dark`:

```dart
MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.system,  // or .light / .dark
);
```

All components automatically adapt to the current theme.

## Color Extensions

### Property Stages

```dart
PropertyStage.preAuction.color  // Orange
PropertyStage.preAuction.label  // 'PRE-AUCTION'
PropertyStage.listed.backgroundColor  // Blue at 12% opacity
```

### Risk Levels

```dart
RiskLevel.low.color    // Green
RiskLevel.medium.color // Orange
RiskLevel.high.color   // Red

// Interpolated color for scores
RiskColors.fromScore(45.0)  // Returns color between yellow and orange
RiskColors.levelFromScore(75.0)  // Returns RiskLevel.high
```

### X-Ray Insights

```dart
XRayInsightType.warning.color     // Red
XRayInsightType.warning.icon      // Icons.warning_amber_rounded
XRayInsightType.opportunity.prefix // '*'
```

## Testing

Run widget tests:

```bash
flutter test test/widgets/
```

## File Structure

```
lib/
├── design/
│   ├── design.dart              # Barrel export
│   ├── app_colors.dart          # Color constants
│   ├── app_typography.dart      # Text styles
│   ├── app_spacing.dart         # Spacing values
│   ├── app_radius.dart          # Border radius presets
│   ├── app_shadows.dart         # Box shadow presets
│   ├── app_sizes.dart           # Standard dimensions
│   ├── app_breakpoints.dart     # Responsive breakpoints
│   ├── app_theme.dart           # ThemeData (light/dark)
│   └── extensions/
│       ├── stage_colors.dart
│       ├── risk_colors.dart
│       └── xray_colors.dart
├── widgets/
│   ├── widgets.dart             # Barrel export
│   ├── stat_tile.dart
│   ├── app_badge.dart
│   ├── grade_badge.dart
│   ├── property_card.dart
│   ├── cta_button.dart
│   ├── app_icon_button.dart
│   ├── hud_pill.dart
│   ├── float_panel.dart
│   ├── galaxy_dot.dart
│   ├── galaxy_canvas.dart
│   ├── app_top_bar.dart
│   ├── app_bottom_nav.dart
│   ├── app_toast.dart
│   ├── adaptive_scaffold.dart
│   ├── app_sidebar.dart
│   └── app_navigation_rail.dart
├── services/
│   ├── services.dart
│   ├── notification_service.dart
│   └── tray_service.dart
└── platform/
    ├── platform.dart
    ├── macos/
    ├── windows/
    └── linux/
```
