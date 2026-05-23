import 'package:flutter/material.dart';
import '../../../core/models/xray_insight.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_radius.dart';
import '../../../core/design/app_typography.dart';
import '../../../core/design/app_shadows.dart';

/// Overlay widget for X-Ray mode visualization
class XRayOverlay extends StatelessWidget {
  final List<XRayInsight> insights;
  final bool isActive;
  final void Function(XRayInsight insight)? onInsightTap;

  const XRayOverlay({
    super.key,
    required this.insights,
    required this.isActive,
    this.onInsightTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive || insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: AppColors.xrayOverlay,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.visibility, color: Colors.white, size: 20),
                SizedBox(width: AppSpacing.xs),
                Text(
                  'X-Ray Analysis',
                  style: AppTypography.label.copyWith(color: Colors.white),
                ),
                const Spacer(),
                Text(
                  '${insights.length} insights',
                  style: AppTypography.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),

            // Insight badges
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: insights.map((i) => InsightBadge(
                insight: i,
                onTap: () => onInsightTap?.call(i),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge showing a single insight
class InsightBadge extends StatelessWidget {
  final XRayInsight insight;
  final VoidCallback? onTap;
  final bool compact;

  const InsightBadge({
    super.key,
    required this.insight,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
          vertical: compact ? AppSpacing.xxs : AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: insight.color.withOpacity(0.15),
          borderRadius: AppRadius.insightBadgeRadius,
          border: Border.all(color: insight.color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              insight.icon,
              size: compact ? 12 : 14,
              color: insight.color,
            ),
            SizedBox(width: AppSpacing.xxs),
            Text(
              insight.title,
              style: (compact ? AppTypography.small : AppTypography.caption)
                  .copyWith(color: insight.color),
            ),
            if (insight.confidence != null && !compact) ...[
              SizedBox(width: AppSpacing.xxs),
              Text(
                insight.confidenceText!,
                style: AppTypography.small.copyWith(
                  color: insight.color.withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Detail sheet showing full insight information
class InsightDetailSheet extends StatelessWidget {
  final XRayInsight insight;

  const InsightDetailSheet({
    super.key,
    required this.insight,
  });

  static void show(BuildContext context, XRayInsight insight) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => InsightDetailSheet(insight: insight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSpacing.md),
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
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: insight.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  insight.icon,
                  color: insight.color,
                  size: 24,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight.title,
                      style: AppTypography.screenTitle,
                    ),
                    Text(
                      _getCategoryLabel(insight.category),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.fg3,
                      ),
                    ),
                  ],
                ),
              ),
              if (insight.confidence != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: AppRadius.chipRadius,
                  ),
                  child: Text(
                    '${insight.confidenceText} confidence',
                    style: AppTypography.small.copyWith(color: AppColors.fg2),
                  ),
                ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          // Description
          Text(
            insight.description,
            style: AppTypography.body,
          ),

          // Action hint
          if (insight.actionHint != null) ...[
            SizedBox(height: AppSpacing.md),
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.brandGradientSoft.colors.first,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: AppColors.brandBlue,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      insight.actionHint!,
                      style: AppTypography.secondary.copyWith(
                        color: AppColors.brandBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Field reference
          if (insight.field != null) ...[
            SizedBox(height: AppSpacing.md),
            Text(
              'Based on: ${insight.field}',
              style: AppTypography.caption.copyWith(color: AppColors.fg3),
            ),
          ],

          SizedBox(height: AppSpacing.lg),

          // Close button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.buttonRadius,
                ),
              ),
              child: const Text('Got it'),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(XRayInsightCategory category) {
    return switch (category) {
      XRayInsightCategory.risk => 'Risk Analysis',
      XRayInsightCategory.financial => 'Financial Insight',
      XRayInsightCategory.location => 'Location Data',
      XRayInsightCategory.owner => 'Owner Information',
      XRayInsightCategory.compliance => 'Ethical Consideration',
      XRayInsightCategory.data => 'Data Quality',
    };
  }
}

/// Summary card showing insight counts by type
class InsightSummaryCard extends StatelessWidget {
  final List<XRayInsight> insights;
  final VoidCallback? onTap;

  const InsightSummaryCard({
    super.key,
    required this.insights,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final counts = insights.countByType();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.cardRadius,
          boxShadow: AppShadows.card,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (counts[XRayInsightType.warning] != null)
              _buildCountBadge(
                counts[XRayInsightType.warning]!,
                AppColors.insightWarning,
                Icons.warning_rounded,
              ),
            if (counts[XRayInsightType.ethical] != null)
              _buildCountBadge(
                counts[XRayInsightType.ethical]!,
                AppColors.insightEthical,
                Icons.shield_rounded,
              ),
            if (counts[XRayInsightType.opportunity] != null)
              _buildCountBadge(
                counts[XRayInsightType.opportunity]!,
                AppColors.insightOpportunity,
                Icons.star_rounded,
              ),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.fg3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountBadge(int count, Color color, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 2),
          Text(
            count.toString(),
            style: AppTypography.small.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
