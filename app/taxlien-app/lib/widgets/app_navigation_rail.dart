import 'package:flutter/material.dart';
import '../design/design.dart';
import 'adaptive_scaffold.dart';

/// A vertical navigation rail for tablet layouts (medium breakpoint).
///
/// Shows icons only with tooltips on hover.
/// Width: 72px fixed.
class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  /// The navigation destinations to display.
  final List<AdaptiveDestination> destinations;

  /// The currently selected destination index.
  final int selectedIndex;

  /// Callback when a destination is selected.
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
            // App logo/icon at top
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
            // Navigation items
            Expanded(
              child: Column(
                children: [
                  for (var i = 0; i < destinations.length; i++)
                    _RailItem(
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

class _RailItem extends StatefulWidget {
  const _RailItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final AdaptiveDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_RailItem> createState() => _RailItemState();
}

class _RailItemState extends State<_RailItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = AppColors.brandBlue;
    final inactiveColor = isDark ? AppColors.fg2Dark : AppColors.fg2;

    return Tooltip(
      message: widget.destination.label,
      waitDuration: const Duration(milliseconds: 500),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xs,
              horizontal: AppSpacing.sm,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? activeColor.withOpacity(0.12)
                    : (_isHovered
                        ? (isDark
                            ? AppColors.surfaceDark2
                            : AppColors.bg)
                        : Colors.transparent),
                borderRadius: AppRadius.md,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    widget.isSelected
                        ? widget.destination.selectedIcon
                        : widget.destination.icon,
                    size: 24,
                    color: widget.isSelected ? activeColor : inactiveColor,
                  ),
                  if (widget.destination.badge != null &&
                      widget.destination.badge! > 0)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: AppRadius.pill,
                        ),
                        constraints: const BoxConstraints(minWidth: 14),
                        child: Text(
                          widget.destination.badge! > 99
                              ? '99+'
                              : widget.destination.badge.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
