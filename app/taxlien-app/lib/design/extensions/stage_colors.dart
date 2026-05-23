import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Property listing stages.
enum PropertyStage {
  /// Pre-auction - research phase
  preAuction,

  /// Listed - active bidding
  listed,

  /// OTC - Over-the-counter, direct buy
  otc,

  /// Sold - transaction complete
  sold,
}

/// Color and label extensions for PropertyStage.
extension StageColorsExtension on PropertyStage {
  /// Primary color for this stage.
  Color get color => switch (this) {
        PropertyStage.preAuction => AppColors.stagePre,
        PropertyStage.listed => AppColors.stageListed,
        PropertyStage.otc => AppColors.stageOtc,
        PropertyStage.sold => AppColors.stageSold,
      };

  /// Background color for badges (12% opacity).
  Color get backgroundColor => color.withOpacity(0.12);

  /// Display label for this stage.
  String get label => switch (this) {
        PropertyStage.preAuction => 'PRE-AUCTION',
        PropertyStage.listed => 'LISTED',
        PropertyStage.otc => 'OTC',
        PropertyStage.sold => 'SOLD',
      };

  /// Short label for compact displays.
  String get shortLabel => switch (this) {
        PropertyStage.preAuction => 'PRE',
        PropertyStage.listed => 'LIST',
        PropertyStage.otc => 'OTC',
        PropertyStage.sold => 'SOLD',
      };

  /// Icon for this stage.
  IconData get icon => switch (this) {
        PropertyStage.preAuction => Icons.schedule_outlined,
        PropertyStage.listed => Icons.gavel_outlined,
        PropertyStage.otc => Icons.storefront_outlined,
        PropertyStage.sold => Icons.check_circle_outline,
      };
}

/// Parse PropertyStage from string.
PropertyStage? propertyStageFromString(String? value) {
  if (value == null) return null;
  final normalized = value.toLowerCase().replaceAll('-', '').replaceAll('_', '');
  return switch (normalized) {
    'preauction' || 'pre' => PropertyStage.preAuction,
    'listed' || 'list' => PropertyStage.listed,
    'otc' || 'overthecounter' => PropertyStage.otc,
    'sold' => PropertyStage.sold,
    _ => null,
  };
}
