import 'package:flutter/material.dart';
import '../design/design.dart';
import 'adaptive_scaffold.dart';

/// A sidebar navigation for desktop layouts (expanded+ breakpoints).
///
/// Can be collapsed (icons only) or expanded (icons + labels).
/// Widths: expanded=240, collapsed=72.
class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.collapsed = false,
    this.header,
    this.footer,
    this.onToggleCollapse,
  });

  /// The navigation destinations to display.
  final List<AdaptiveDestination> destinations;

  /// The currently selected destination index.
  final int selectedIndex;

  /// Callback when a destination is selected.
  final ValueChanged<int> onDestinationSelected;

  /// Whether the sidebar is collapsed (icons only).
  final bool collapsed;

  /// Optional header widget (e.g., app logo, user info).
  final Widget? header;

  /// Optional footer widget (e.g., settings, logout).
  final Widget? footer;

  /// Callback to toggle collapsed state.
  final VoidCallback? onToggleCollapse;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
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
            _buildHeader(context, isDark),
            const SizedBox(height: AppSpacing.md),
            // Navigation items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                ),
                children: [
                  for (var i = 0; i < destinations.length; i++)
                    _SidebarItem(
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
            if (onToggleCollapse != null) _buildCollapseToggle(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    if (header != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: header,
      );
    }

    // Default header with app logo
    return Padding(
      padding: EdgeInsets.all(collapsed ? AppSpacing.sm : AppSpacing.md),
      child: Row(
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
    );
  }

  Widget _buildCollapseToggle(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: GestureDetector(
        onTap: onToggleCollapse,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.sm,
              horizontal: collapsed ? 0 : AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadius.md,
            ),
            child: Row(
              mainAxisAlignment:
                  collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
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
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
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
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = AppColors.brandBlue;
    final inactiveColor = isDark ? AppColors.fg2Dark : AppColors.fg2;
    final textColor = isDark ? AppColors.fg1Dark : AppColors.fg1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.sm,
              horizontal: widget.collapsed ? 0 : AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? activeColor.withOpacity(0.12)
                  : (_isHovered
                      ? (isDark ? AppColors.surfaceDark2 : AppColors.bg)
                      : Colors.transparent),
              borderRadius: AppRadius.md,
            ),
            child: Row(
              mainAxisAlignment: widget.collapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Icon(
                      widget.isSelected
                          ? widget.destination.selectedIcon
                          : widget.destination.icon,
                      size: 22,
                      color: widget.isSelected ? activeColor : inactiveColor,
                    ),
                    if (widget.destination.badge != null &&
                        widget.destination.badge! > 0)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                if (!widget.collapsed) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.destination.label,
                      style: AppTypography.body.copyWith(
                        color: widget.isSelected ? activeColor : textColor,
                        fontWeight: widget.isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.destination.badge != null &&
                      widget.destination.badge! > 0) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: AppRadius.pill,
                      ),
                      child: Text(
                        widget.destination.badge! > 99
                            ? '99+'
                            : widget.destination.badge.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
