import 'package:flutter/material.dart';
import '../design/design.dart';
import 'app_bottom_nav.dart';

/// A navigation destination for adaptive layouts.
class AdaptiveDestination {
  const AdaptiveDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badge,
  });

  /// The icon when not selected.
  final IconData icon;

  /// The icon when selected.
  final IconData selectedIcon;

  /// The text label.
  final String label;

  /// Optional badge count.
  final int? badge;
}

/// A responsive scaffold that adapts navigation to screen size.
///
/// Behavior at each breakpoint:
/// - **compact** (<600): Bottom navigation bar
/// - **medium** (600-839): Navigation rail on left
/// - **expanded** (840-1199): Sidebar (collapsed by default)
/// - **large** (1200-1599): Sidebar expanded
/// - **extraLarge** (1600+): Sidebar expanded + optional side panel
class AdaptiveScaffold extends StatefulWidget {
  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.currentIndex = 0,
    this.onDestinationSelected,
    this.destinations = const [],
    this.sidePanel,
    this.floatingActionButton,
    this.sidebarHeader,
    this.sidebarFooter,
  });

  /// The main content body.
  final Widget body;

  /// The currently selected destination index.
  final int currentIndex;

  /// Callback when a destination is selected.
  final ValueChanged<int>? onDestinationSelected;

  /// The navigation destinations.
  final List<AdaptiveDestination> destinations;

  /// Optional side panel for extra-large screens.
  final Widget? sidePanel;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Optional sidebar header widget.
  final Widget? sidebarHeader;

  /// Optional sidebar footer widget.
  final Widget? sidebarFooter;

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  bool _sidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final breakpoint = AppBreakpoints.fromWidth(width);

    return Scaffold(
      body: _buildBody(breakpoint),
      bottomNavigationBar:
          breakpoint.showBottomNav ? _buildBottomNav() : null,
      floatingActionButton: widget.floatingActionButton,
    );
  }

  Widget _buildBody(AppBreakpoint breakpoint) {
    // Import here to avoid circular dependency
    // ignore: depend_on_referenced_packages
    return switch (breakpoint) {
      AppBreakpoint.compact => widget.body,
      AppBreakpoint.medium => _buildWithRail(),
      AppBreakpoint.expanded => _buildWithSidebar(collapsed: true),
      AppBreakpoint.large => _buildWithSidebar(collapsed: _sidebarCollapsed),
      AppBreakpoint.extraLarge =>
        _buildWithSidebarAndPanel(collapsed: _sidebarCollapsed),
    };
  }

  Widget _buildWithRail() {
    return Row(
      children: [
        _NavigationRailInline(
          destinations: widget.destinations,
          selectedIndex: widget.currentIndex,
          onDestinationSelected: _onDestinationSelected,
        ),
        Expanded(child: widget.body),
      ],
    );
  }

  Widget _buildWithSidebar({required bool collapsed}) {
    return Row(
      children: [
        _SidebarInline(
          destinations: widget.destinations,
          selectedIndex: widget.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          collapsed: collapsed,
          header: widget.sidebarHeader,
          footer: widget.sidebarFooter,
          onToggleCollapse: () {
            setState(() => _sidebarCollapsed = !_sidebarCollapsed);
          },
        ),
        Expanded(child: widget.body),
      ],
    );
  }

  Widget _buildWithSidebarAndPanel({required bool collapsed}) {
    return Row(
      children: [
        _SidebarInline(
          destinations: widget.destinations,
          selectedIndex: widget.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          collapsed: collapsed,
          header: widget.sidebarHeader,
          footer: widget.sidebarFooter,
          onToggleCollapse: () {
            setState(() => _sidebarCollapsed = !_sidebarCollapsed);
          },
        ),
        Expanded(child: widget.body),
        if (widget.sidePanel != null) ...[
          Container(
            width: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.lineDark
                : AppColors.line,
          ),
          SizedBox(
            width: 320,
            child: widget.sidePanel,
          ),
        ],
      ],
    );
  }

  Widget _buildBottomNav() {
    if (widget.destinations.isEmpty) {
      return const SizedBox.shrink();
    }

    // Convert AdaptiveDestination to AppNavTab
    // For now, just use the index-based approach
    final tabs = AppNavTab.values;
    final currentTab =
        widget.currentIndex < tabs.length ? tabs[widget.currentIndex] : tabs[0];

    // Build badges map
    final badges = <AppNavTab, int>{};
    for (var i = 0; i < widget.destinations.length && i < tabs.length; i++) {
      if (widget.destinations[i].badge != null) {
        badges[tabs[i]] = widget.destinations[i].badge!;
      }
    }

    return AppBottomNav(
      currentTab: currentTab,
      onTabChanged: (tab) => _onDestinationSelected(tab.index),
      badges: badges,
    );
  }

  void _onDestinationSelected(int index) {
    widget.onDestinationSelected?.call(index);
  }
}

// Inline versions to avoid circular imports

class _NavigationRailInline extends StatelessWidget {
  const _NavigationRailInline({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 72,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.lineDark : AppColors.line,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: AppRadius.md,
              ),
              child: const Icon(
                Icons.blur_on,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: Column(
                children: [
                  for (var i = 0; i < destinations.length; i++)
                    _RailItemInline(
                      destination: destinations[i],
                      isSelected: i == selectedIndex,
                      onTap: () => onDestinationSelected(i),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RailItemInline extends StatelessWidget {
  const _RailItemInline({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final AdaptiveDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = AppColors.brandBlue;
    final inactiveColor = isDark ? AppColors.fg2Dark : AppColors.fg2;

    return Tooltip(
      message: destination.label,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
            horizontal: AppSpacing.sm,
          ),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? activeColor.withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: AppRadius.md,
            ),
            child: Icon(
              isSelected ? destination.selectedIcon : destination.icon,
              size: 24,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarInline extends StatelessWidget {
  const _SidebarInline({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.collapsed,
    this.header,
    this.footer,
    this.onToggleCollapse,
  });

  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool collapsed;
  final Widget? header;
  final Widget? footer;
  final VoidCallback? onToggleCollapse;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: collapsed ? 72 : 240,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.lineDark : AppColors.line,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(collapsed ? AppSpacing.sm : AppSpacing.md),
              child: header ??
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          gradient: AppColors.brandGradient,
                          borderRadius: AppRadius.md,
                        ),
                        child: const Icon(
                          Icons.blur_on,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      if (!collapsed) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Deal Detective',
                          style: AppTypography.title.copyWith(
                            color: isDark ? AppColors.fg1Dark : AppColors.fg1,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ],
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                children: [
                  for (var i = 0; i < destinations.length; i++)
                    _SidebarItemInline(
                      destination: destinations[i],
                      isSelected: i == selectedIndex,
                      collapsed: collapsed,
                      onTap: () => onDestinationSelected(i),
                    ),
                ],
              ),
            ),
            // Footer
            if (footer != null) ...[
              const Divider(height: 1),
              footer!,
            ],
            // Collapse toggle
            if (onToggleCollapse != null)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: GestureDetector(
                  onTap: onToggleCollapse,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                      horizontal: collapsed ? 0 : AppSpacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: collapsed
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        Icon(
                          collapsed
                              ? Icons.keyboard_double_arrow_right_rounded
                              : Icons.keyboard_double_arrow_left_rounded,
                          size: 20,
                          color: isDark ? AppColors.fg2Dark : AppColors.fg2,
                        ),
                        if (!collapsed) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Collapse',
                            style: AppTypography.caption.copyWith(
                              color: isDark ? AppColors.fg2Dark : AppColors.fg2,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItemInline extends StatelessWidget {
  const _SidebarItemInline({
    required this.destination,
    required this.isSelected,
    required this.collapsed,
    required this.onTap,
  });

  final AdaptiveDestination destination;
  final bool isSelected;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = AppColors.brandBlue;
    final inactiveColor = isDark ? AppColors.fg2Dark : AppColors.fg2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: collapsed ? 0 : AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: AppRadius.md,
          ),
          child: Row(
            mainAxisAlignment:
                collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                isSelected ? destination.selectedIcon : destination.icon,
                size: 22,
                color: isSelected ? activeColor : inactiveColor,
              ),
              if (!collapsed) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    destination.label,
                    style: AppTypography.body.copyWith(
                      color: isSelected
                          ? activeColor
                          : (isDark ? AppColors.fg1Dark : AppColors.fg1),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
