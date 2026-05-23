import 'package:flutter/material.dart';
import '../design/design.dart';
import 'stat_tile.dart';
import 'app_badge.dart';
import 'grade_badge.dart';

/// Size variants for PropertyCard.
enum PropertyCardVariant {
  /// Minimal card: 100x40, no image, address only.
  mini,

  /// Compact card: height 64, small image, basic info.
  compact,

  /// Full card: flexible height, large image, all fields.
  full,
}

/// A card displaying property information.
///
/// Supports three variants for different contexts:
/// - mini: for galaxy dot previews
/// - compact: for list views
/// - full: for detail panels
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
  final String? type;
  final DateTime? auctionDate;
  final RiskLevel? riskLevel;
  final bool isWatchlisted;
  final VoidCallback? onTap;
  final VoidCallback? onWatchlistTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onDetailsTap;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      PropertyCardVariant.mini => _MiniPropertyCard(
          address: address,
          onTap: onTap,
        ),
      PropertyCardVariant.compact => _CompactPropertyCard(
          address: address,
          county: county,
          imageUrl: imageUrl,
          value: value,
          stage: stage,
          fvi: fvi,
          onTap: onTap,
        ),
      PropertyCardVariant.full => _FullPropertyCard(
          address: address,
          county: county,
          parcelId: parcelId,
          imageUrl: imageUrl,
          value: value,
          roi: roi,
          fvi: fvi,
          stage: stage,
          type: type,
          auctionDate: auctionDate,
          riskLevel: riskLevel,
          isWatchlisted: isWatchlisted,
          onTap: onTap,
          onWatchlistTap: onWatchlistTap,
          onShareTap: onShareTap,
          onDetailsTap: onDetailsTap,
        ),
    };
  }
}

class _MiniPropertyCard extends StatelessWidget {
  const _MiniPropertyCard({
    required this.address,
    this.onTap,
  });

  final String address;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 40,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: AppRadius.sm,
          boxShadow: AppShadows.card,
        ),
        alignment: Alignment.center,
        child: Text(
          address,
          style: AppTypography.caption.copyWith(
            color: isDark ? AppColors.fg1Dark : AppColors.fg1,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CompactPropertyCard extends StatelessWidget {
  const _CompactPropertyCard({
    required this.address,
    this.county,
    this.imageUrl,
    this.value,
    this.stage,
    this.fvi,
    this.onTap,
  });

  final String address;
  final String? county;
  final String? imageUrl;
  final double? value;
  final PropertyStage? stage;
  final double? fvi;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: AppRadius.md,
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            // Image
            _PropertyImage(
              imageUrl: imageUrl,
              size: 48,
              borderRadius: AppRadius.sm,
            ),
            const SizedBox(width: AppSpacing.sm),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    address,
                    style: AppTypography.label.copyWith(
                      color: isDark ? AppColors.fg1Dark : AppColors.fg1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (county != null)
                    Text(
                      county!,
                      style: AppTypography.caption.copyWith(
                        color: isDark ? AppColors.fg2Dark : AppColors.fg2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            // Value and stage
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (value != null)
                  Text(
                    '\$${_formatNumber(value!)}',
                    style: AppTypography.label.copyWith(
                      color: isDark ? AppColors.fg1Dark : AppColors.fg1,
                    ),
                  ),
                if (stage != null)
                  AppBadge(
                    label: stage!.label,
                    tone: _stageToBadgeTone(stage!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FullPropertyCard extends StatelessWidget {
  const _FullPropertyCard({
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

  final String address;
  final String? county;
  final String? parcelId;
  final String? imageUrl;
  final double? value;
  final double? roi;
  final double? fvi;
  final PropertyStage? stage;
  final String? type;
  final DateTime? auctionDate;
  final RiskLevel? riskLevel;
  final bool isWatchlisted;
  final VoidCallback? onTap;
  final VoidCallback? onWatchlistTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onDetailsTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: AppRadius.lg,
          boxShadow: AppShadows.cardStrong,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with overlays
            Stack(
              children: [
                _PropertyImage(
                  imageUrl: imageUrl,
                  size: 200,
                  borderRadius: AppRadius.md,
                  aspectRatio: 16 / 10,
                ),
                // Stage badge
                if (stage != null)
                  Positioned(
                    top: AppSpacing.xs,
                    left: AppSpacing.xs,
                    child: AppBadge(
                      label: stage!.label,
                      tone: _stageToBadgeTone(stage!),
                    ),
                  ),
                // FVI grade
                if (fvi != null)
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: GradeBadge(
                      grade: _fviToGrade(fvi!),
                      size: GradeBadgeSize.md,
                    ),
                  ),
                // Risk indicator
                if (riskLevel != null)
                  Positioned(
                    bottom: AppSpacing.xs,
                    left: AppSpacing.xs,
                    child: AppBadge(
                      label: riskLevel!.label,
                      tone: _riskToBadgeTone(riskLevel!),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Address
            Text(
              address,
              style: AppTypography.title.copyWith(
                color: isDark ? AppColors.fg1Dark : AppColors.fg1,
                fontSize: 18,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (county != null || parcelId != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                [county, parcelId].whereType<String>().join(' • '),
                style: AppTypography.caption.copyWith(
                  color: isDark ? AppColors.fg2Dark : AppColors.fg2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            // Stats row
            Row(
              children: [
                if (value != null)
                  Expanded(
                    child: StatTile(
                      label: 'Value',
                      value: '\$${_formatNumber(value!)}',
                      size: StatTileSize.compact,
                    ),
                  ),
                if (roi != null)
                  Expanded(
                    child: StatTile(
                      label: 'ROI',
                      value: '${roi!.toStringAsFixed(1)}%',
                      deltaPositive: roi! > 0,
                      size: StatTileSize.compact,
                    ),
                  ),
                if (type != null)
                  Expanded(
                    child: StatTile(
                      label: 'Type',
                      value: type!,
                      size: StatTileSize.compact,
                    ),
                  ),
              ],
            ),
            // Action buttons
            if (onWatchlistTap != null ||
                onShareTap != null ||
                onDetailsTap != null) ...[
              const SizedBox(height: AppSpacing.sm),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (onWatchlistTap != null)
                    _ActionButton(
                      icon: isWatchlisted
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      label: 'Save',
                      isActive: isWatchlisted,
                      onTap: onWatchlistTap,
                    ),
                  if (onShareTap != null)
                    _ActionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      onTap: onShareTap,
                    ),
                  if (onDetailsTap != null)
                    _ActionButton(
                      icon: Icons.open_in_new_rounded,
                      label: 'Details',
                      onTap: onDetailsTap,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PropertyImage extends StatelessWidget {
  const _PropertyImage({
    required this.imageUrl,
    required this.size,
    required this.borderRadius,
    this.aspectRatio,
  });

  final String? imageUrl;
  final double size;
  final BorderRadius borderRadius;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget child;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      child = Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(isDark),
      );
    } else {
      child = _placeholder(isDark);
    }

    if (aspectRatio != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: AspectRatio(
          aspectRatio: aspectRatio!,
          child: child,
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: size,
        height: size,
        child: child,
      ),
    );
  }

  Widget _placeholder(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surfaceDark2,
                  AppColors.surfaceDark,
                ],
              )
            : AppColors.brandGradientSoft,
      ),
      child: Icon(
        Icons.home_outlined,
        color: isDark ? AppColors.fg2Dark : AppColors.fg2,
        size: 32,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isActive
        ? AppColors.brandBlue
        : (isDark ? AppColors.fg2Dark : AppColors.fg2);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: color,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper functions
String _formatNumber(double value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  } else if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(0)}K';
  }
  return value.toStringAsFixed(0);
}

String _fviToGrade(double fvi) {
  if (fvi >= 90) return 'A+';
  if (fvi >= 80) return 'A';
  if (fvi >= 70) return 'B';
  if (fvi >= 60) return 'C';
  if (fvi >= 50) return 'D';
  return 'F';
}

BadgeTone _stageToBadgeTone(PropertyStage stage) {
  return switch (stage) {
    PropertyStage.preAuction => BadgeTone.warn,
    PropertyStage.listed => BadgeTone.info,
    PropertyStage.otc => BadgeTone.cyan,
    PropertyStage.sold => BadgeTone.neutral,
  };
}

BadgeTone _riskToBadgeTone(RiskLevel risk) {
  return switch (risk) {
    RiskLevel.low => BadgeTone.good,
    RiskLevel.medium => BadgeTone.warn,
    RiskLevel.high => BadgeTone.hot,
  };
}
