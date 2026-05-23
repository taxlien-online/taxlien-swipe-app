import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_radius.dart';
import '../../../core/design/app_shadows.dart';
import '../../../core/design/app_typography.dart';
import '../../../core/models/galaxy_dimension.dart';
import '../providers/galaxy_provider.dart';
import '../widgets/galaxy_viewport.dart';
import '../widgets/selection_provider.dart';

/// Main Galaxy screen with viewport, HUD, and floating panels
class GalaxyScreen extends StatefulWidget {
  const GalaxyScreen({super.key});

  @override
  State<GalaxyScreen> createState() => _GalaxyScreenState();
}

class _GalaxyScreenState extends State<GalaxyScreen> {
  bool _showDimensionPicker = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GalaxyProvider()),
        ChangeNotifierProvider(create: (_) => SelectionProvider()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Stack(
            children: [
              // Main viewport
              const Positioned.fill(
                child: GalaxyViewport(),
              ),

              // Top HUD
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildTopHud(),
              ),

              // Dimension picker overlay
              if (_showDimensionPicker)
                Positioned.fill(
                  child: _buildDimensionPicker(),
                ),

              // Selection floating panel
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildSelectionPanel(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHud() {
    return Consumer<GalaxyProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.bg,
                AppColors.bg.withOpacity(0),
              ],
            ),
          ),
          child: Row(
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
                color: AppColors.fg1,
              ),

              const Spacer(),

              // Dimension indicator
              GestureDetector(
                onTap: () {
                  setState(() => _showDimensionPicker = true);
                  HapticFeedback.lightImpact();
                },
                child: DimensionIndicator(
                  dimension: provider.dimension,
                  onPrevious: () {
                    provider.previousDimension();
                    HapticFeedback.selectionClick();
                  },
                  onNext: () {
                    provider.nextDimension();
                    HapticFeedback.selectionClick();
                  },
                ),
              ),

              const Spacer(),

              // Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lasso mode toggle
                  Consumer<SelectionProvider>(
                    builder: (context, selection, _) {
                      return IconButton(
                        icon: Icon(
                          selection.isLassoMode
                              ? Icons.gesture
                              : Icons.gesture_outlined,
                        ),
                        onPressed: () {
                          if (selection.isLassoMode) {
                            selection.exitLassoMode();
                          } else {
                            selection.enterLassoMode();
                          }
                          HapticFeedback.selectionClick();
                        },
                        color: selection.isLassoMode
                            ? AppColors.brandBlue
                            : AppColors.fg1,
                      );
                    },
                  ),

                  // Reset view
                  IconButton(
                    icon: const Icon(Icons.fit_screen),
                    onPressed: () {
                      provider.resetView();
                      HapticFeedback.lightImpact();
                    },
                    color: AppColors.fg1,
                  ),

                  // More options
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showOptionsMenu(context),
                    color: AppColors.fg1,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDimensionPicker() {
    return GestureDetector(
      onTap: () => setState(() => _showDimensionPicker = false),
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            margin: EdgeInsets.all(AppSpacing.xl),
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.floatingPanelRadius,
              boxShadow: AppShadows.modal,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Dimension',
                  style: AppTypography.screenTitle,
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Choose how to organize properties',
                  style: AppTypography.secondary.copyWith(color: AppColors.fg2),
                ),
                SizedBox(height: AppSpacing.lg),

                // MVP Dimensions
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: GalaxyDimension.values
                      .where((d) => d.isMvp)
                      .map((d) => _buildDimensionChip(d))
                      .toList(),
                ),

                SizedBox(height: AppSpacing.md),
                Divider(color: AppColors.line),
                SizedBox(height: AppSpacing.sm),

                Text(
                  'Extended (Coming Soon)',
                  style: AppTypography.caption.copyWith(color: AppColors.fg3),
                ),
                SizedBox(height: AppSpacing.sm),

                // Extended Dimensions (disabled)
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: GalaxyDimension.values
                      .where((d) => !d.isMvp)
                      .map((d) => _buildDimensionChip(d, enabled: false))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDimensionChip(GalaxyDimension dimension, {bool enabled = true}) {
    return Consumer<GalaxyProvider>(
      builder: (context, provider, _) {
        final isSelected = provider.dimension == dimension;
        return GestureDetector(
          onTap: enabled
              ? () {
                  provider.setDimension(dimension);
                  setState(() => _showDimensionPicker = false);
                  HapticFeedback.selectionClick();
                }
              : null,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.brandBlue
                  : enabled
                      ? AppColors.bg
                      : AppColors.disabled,
              borderRadius: AppRadius.chipRadius,
              border: Border.all(
                color: isSelected ? AppColors.brandBlue : AppColors.line,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  dimension.icon,
                  size: 16,
                  color: isSelected
                      ? Colors.white
                      : enabled
                          ? AppColors.fg1
                          : AppColors.fg3,
                ),
                SizedBox(width: AppSpacing.xs),
                Text(
                  dimension.displayName,
                  style: AppTypography.label.copyWith(
                    color: isSelected
                        ? Colors.white
                        : enabled
                            ? AppColors.fg1
                            : AppColors.fg3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectionPanel() {
    return Consumer<SelectionProvider>(
      builder: (context, selection, _) {
        if (!selection.hasSelection) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: EdgeInsets.all(AppSpacing.md),
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.floatingPanelRadius,
            boxShadow: AppShadows.floatingPanel,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stats row
              Row(
                children: [
                  // Count
                  _buildStatItem(
                    label: 'Selected',
                    value: selection.selectionCount.toString(),
                    icon: Icons.check_circle,
                  ),
                  SizedBox(width: AppSpacing.lg),

                  // Total value
                  _buildStatItem(
                    label: 'Total Lien',
                    value: selection.stats.formattedLienAmount,
                    icon: Icons.attach_money,
                  ),
                  SizedBox(width: AppSpacing.lg),

                  // Average ROI
                  if (selection.stats.averageExpectedRoi > 0)
                    _buildStatItem(
                      label: 'Avg ROI',
                      value:
                          '${(selection.stats.averageExpectedRoi * 100).toStringAsFixed(1)}%',
                      icon: Icons.trending_up,
                    ),

                  const Spacer(),

                  // Actions
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Add to watchlist
                      IconButton(
                        icon: const Icon(Icons.bookmark_add_outlined),
                        onPressed: () => _addToWatchlist(context, selection),
                        tooltip: 'Add to Watchlist',
                        color: AppColors.brandBlue,
                      ),

                      // Clear selection
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          selection.clearSelection();
                          HapticFeedback.lightImpact();
                        },
                        tooltip: 'Clear Selection',
                        color: AppColors.fg2,
                      ),
                    ],
                  ),
                ],
              ),

              // Warning if exemptions present
              if (selection.stats.hasExemptions) ...[
                SizedBox(height: AppSpacing.sm),
                Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.insightEthical.withOpacity(0.1),
                    borderRadius: AppRadius.badgeRadius,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.shield,
                        size: 16,
                        color: AppColors.insightEthical,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        'Selection includes owner-occupied or exempt properties',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.insightEthical,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.fg3),
            SizedBox(width: AppSpacing.xxs),
            Text(
              label,
              style: AppTypography.statLabel.copyWith(color: AppColors.fg3),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: AppTypography.statValue.copyWith(color: AppColors.fg1),
        ),
      ],
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sheetRadius),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.file_download_outlined),
                title: const Text('Export Selection'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement export
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share to Family Board'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement share
                },
              ),
              ListTile(
                leading: const Icon(Icons.filter_list),
                title: const Text('Filter Properties'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement filter
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('How to Use Galaxy'),
                onTap: () {
                  Navigator.pop(context);
                  _showHelpDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Galaxy View Help'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpItem(Icons.pinch, 'Pinch to zoom in/out'),
              _buildHelpItem(Icons.pan_tool, 'Drag to pan around'),
              _buildHelpItem(Icons.touch_app, 'Tap property to select'),
              _buildHelpItem(Icons.gesture, 'Draw lasso to multi-select'),
              _buildHelpItem(
                  Icons.rotate_right, 'Two-finger rotate to change dimension'),
              _buildHelpItem(Icons.ads_click, 'Tap cluster to zoom in'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.brandBlue),
          SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  void _addToWatchlist(BuildContext context, SelectionProvider selection) {
    final count = selection.selectionCount;
    selection.clearSelection();
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $count properties to Watchlist'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // TODO: Navigate to watchlist
          },
        ),
      ),
    );
  }
}
