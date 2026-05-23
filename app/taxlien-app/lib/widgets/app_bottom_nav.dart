import 'dart:ui';
import 'package:flutter/material.dart';
import '../design/design.dart';

/// Navigation tabs for the bottom nav bar.
enum AppNavTab {
  /// Galaxy/visualization view.
  galaxy,

  /// List view of properties.
  list,

  /// Saved/watchlisted properties.
  watchlist,

  /// User profile and settings.
  profile,
}

/// Extension methods for AppNavTab.
extension AppNavTabExtension on AppNavTab {
  /// The icon when not selected.
  IconData get icon => switch (this) {
        AppNavTab.galaxy => Icons.blur_on_outlined,
        AppNavTab.list => Icons.view_list_outlined,
        AppNavTab.watchlist => Icons.bookmark_border_rounded,
        AppNavTab.profile => Icons.person_outline_rounded,
      };

  /// The icon when selected.
  IconData get selectedIcon => switch (this) {
        AppNavTab.galaxy => Icons.blur_on,
        AppNavTab.list => Icons.view_list_rounded,
        AppNavTab.watchlist => Icons.bookmark_rounded,
        AppNavTab.profile => Icons.person_rounded,
      };

  /// The label text.
  String get label => switch (this) {
        AppNavTab.galaxy => 'Galaxy',
        AppNavTab.list => 'List',
        AppNavTab.watchlist => 'Saved',
        AppNavTab.profile => 'Profile',
      };
}

/// A frosted-glass bottom navigation bar.
///
/// Used on mobile/compact layouts for primary navigation.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
    this.badges = const {},
  });

  /// The currently selected tab.
  final AppNavTab currentTab;

  /// Callback when a tab is selected.
  final ValueChanged<AppNavTab> onTabChanged;

  /// Optional badge counts for tabs.
  final Map<AppNavTab, int> badges;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: AppSizes.tabStripHeight + bottomPadding,
          padding: EdgeInsets.only(bottom: bottomPadding),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark.withOpacity(0.92)
                : AppColors.surface.withOpacity(0.92),
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.lineDark : AppColors.line,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: AppNavTab.values.map((tab) {
              final isSelected = tab == currentTab;
              final badge = badges[tab];

              return _NavItem(
                icon: isSelected ? tab.selectedIcon : tab.icon,
                label: tab.label,
                isSelected: isSelected,
                badge: badge,
                onTap: () => onTabChanged(tab),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.badge,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final int? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeColor = AppColors.brandBlue;
    final inactiveColor = isDark ? AppColors.fg2Dark : AppColors.fg2;
    final color = isSelected ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: AppSizes.tabIcon + 24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: AppSizes.tabIcon,
                  height: 32,
                  decoration: isSelected
                      ? BoxDecoration(
                          color: activeColor.withOpacity(0.12),
                          borderRadius: AppRadius.pill,
                        )
                      : null,
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    size: 24,
                    color: color,
                  ),
                ),
                if (badge != null && badge! > 0)
                  Positioned(
                    top: -2,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: AppRadius.pill,
                      ),
                      constraints: const BoxConstraints(minWidth: 16),
                      child: Text(
                        badge! > 99 ? '99+' : badge.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
