import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/models/tax_lien_models.dart';
import '../../../core/models/spatial_position.dart';
import '../../../core/models/galaxy_dimension.dart';
import '../../../core/design/app_colors.dart';

/// Base class for dimension-specific layout calculations
abstract class DimensionLayout {
  GalaxyDimension get dimension;

  /// Calculate positions for all properties
  List<SpatialPosition> calculatePositions(List<TaxLien> properties);

  /// Get the color for a property in this dimension
  Color getColorForProperty(TaxLien property);

  /// Get the radius for a property based on value
  double getRadiusForProperty(TaxLien property);

  /// Utility: calculate radius from property value (log scale)
  double radiusFromValue(double value) {
    if (value <= 0) return 12.0;
    return (8 + 4 * math.log(value / 10000 + 1)).clamp(8.0, 48.0);
  }

  /// Utility: calculate radius from tax amount
  double radiusFromTaxAmount(double amount) {
    if (amount <= 0) return 10.0;
    return (6 + 4 * math.log(amount / 500 + 1)).clamp(6.0, 36.0);
  }

  /// Utility: add margin to normalized coordinates
  double withMargin(double value, {double margin = 0.1}) {
    return value * (1 - 2 * margin) + margin;
  }
}

/// Factory for creating dimension layouts
class DimensionLayoutFactory {
  static DimensionLayout create(GalaxyDimension dimension) {
    return switch (dimension) {
      GalaxyDimension.date => DateDimensionLayout(),
      GalaxyDimension.county => CountyDimensionLayout(),
      GalaxyDimension.roi => RoiDimensionLayout(),
      GalaxyDimension.risk => RiskDimensionLayout(),
      GalaxyDimension.stage => StageDimensionLayout(),
      GalaxyDimension.fvi => FviDimensionLayout(),
      GalaxyDimension.type => TypeDimensionLayout(),
      GalaxyDimension.priorYears => PriorYearsDimensionLayout(),
      GalaxyDimension.exemptions => ExemptionsDimensionLayout(),
      GalaxyDimension.ownerTenure => OwnerTenureDimensionLayout(),
      GalaxyDimension.payback => PaybackDimensionLayout(),
      GalaxyDimension.taxYear => TaxYearDimensionLayout(),
    };
  }
}

/// Date dimension: X = auction_date, Y = county spread
class DateDimensionLayout extends DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.date;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    if (properties.isEmpty) return [];

    // Find date range
    final dates = properties.map((p) => p.auctionDate).toList();
    final minDate = dates.reduce((a, b) => a.isBefore(b) ? a : b);
    final maxDate = dates.reduce((a, b) => a.isAfter(b) ? a : b);
    final dateRange = maxDate.difference(minDate).inDays;

    // Group by county for Y-axis spread
    final countyIndices = <String, int>{};
    for (final p in properties) {
      countyIndices.putIfAbsent(p.county, () => countyIndices.length);
    }

    return properties.map((p) {
      final x = dateRange > 0
          ? p.auctionDate.difference(minDate).inDays / dateRange
          : 0.5;
      final countyIdx = countyIndices[p.county] ?? 0;
      final y = countyIndices.length > 1
          ? (countyIdx + 0.5) / countyIndices.length
          : 0.5;

      return SpatialPosition(
        propertyId: p.id,
        x: withMargin(x),
        y: withMargin(y),
        color: getColorForProperty(p),
        radius: getRadiusForProperty(p),
      );
    }).toList();
  }

  @override
  Color getColorForProperty(TaxLien property) {
    final daysUntil = property.auctionDate.difference(DateTime.now()).inDays;
    if (daysUntil <= 7) return AppColors.danger;
    if (daysUntil <= 30) return AppColors.warning;
    return AppColors.brandBlue;
  }

  @override
  double getRadiusForProperty(TaxLien property) => radiusFromValue(property.estimatedValue);
}

/// ROI dimension: X = expected_roi, Y = estimated_value
class RoiDimensionLayout extends DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.roi;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    if (properties.isEmpty) return [];

    const minRoi = 0.0;
    const maxRoi = 0.35; // 35% cap

    final values = properties.map((p) => p.estimatedValue).where((v) => v > 0);
    if (values.isEmpty) return [];
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final valueRange = maxValue - minValue;

    return properties.map((p) {
      final roi = p.expectedRoi ?? _calculateRoi(p);
      final x = ((roi - minRoi) / (maxRoi - minRoi)).clamp(0.0, 1.0);
      final y = valueRange > 0
          ? ((p.estimatedValue - minValue) / valueRange).clamp(0.0, 1.0)
          : 0.5;

      return SpatialPosition(
        propertyId: p.id,
        x: withMargin(x),
        y: withMargin(1 - y), // Invert Y so high value at top
        color: getColorForProperty(p),
        radius: getRadiusForProperty(p),
      );
    }).toList();
  }

  double _calculateRoi(TaxLien property) {
    if (property.taxAmount <= 0) return 0;
    return (property.estimatedValue - property.taxAmount) / property.taxAmount;
  }

  @override
  Color getColorForProperty(TaxLien property) {
    final roi = property.expectedRoi ?? _calculateRoi(property);
    if (roi >= 0.20) return AppColors.roiHigh;
    if (roi >= 0.10) return AppColors.roiMedium;
    return AppColors.roiLow;
  }

  @override
  double getRadiusForProperty(TaxLien property) => radiusFromValue(property.estimatedValue);
}

/// Risk dimension: X = risk_score, Y = redemption_probability
class RiskDimensionLayout extends DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.risk;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    return properties.map((p) {
      final riskScore = (p.riskScore ?? 50) / 100.0;
      final redemptionProb = p.redemptionProbability ?? 0.5;

      return SpatialPosition(
        propertyId: p.id,
        x: withMargin(riskScore),
        y: withMargin(1 - redemptionProb), // Low redemption at top (opportunity)
        color: getColorForProperty(p),
        radius: getRadiusForProperty(p),
      );
    }).toList();
  }

  @override
  Color getColorForProperty(TaxLien property) {
    final riskScore = property.riskScore ?? 50;
    if (riskScore <= 30) return AppColors.riskLow;
    if (riskScore <= 70) return AppColors.riskMedium;
    return AppColors.riskHigh;
  }

  @override
  double getRadiusForProperty(TaxLien property) => radiusFromTaxAmount(property.taxAmount);
}

/// Stage dimension: Columns by listing_stage
class StageDimensionLayout extends DimensionLayout {
  static const _stageOrder = ['pre-auction', 'listed', 'otc', 'sold'];

  @override
  GalaxyDimension get dimension => GalaxyDimension.stage;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    final byStage = <String, List<TaxLien>>{};
    for (final p in properties) {
      final stage = p.listingStage;
      byStage.putIfAbsent(stage, () => []).add(p);
    }

    final positions = <SpatialPosition>[];
    for (var stageIdx = 0; stageIdx < _stageOrder.length; stageIdx++) {
      final stage = _stageOrder[stageIdx];
      final stageProperties = byStage[stage] ?? [];
      final columnX = (stageIdx + 0.5) / _stageOrder.length;

      for (var i = 0; i < stageProperties.length; i++) {
        final p = stageProperties[i];
        final y = stageProperties.length > 1
            ? (i + 0.5) / stageProperties.length
            : 0.5;

        positions.add(SpatialPosition(
          propertyId: p.id,
          x: withMargin(columnX),
          y: withMargin(y),
          color: getColorForProperty(p),
          radius: getRadiusForProperty(p),
        ));
      }
    }
    return positions;
  }

  @override
  Color getColorForProperty(TaxLien property) => AppColors.stageColor(property.listingStage);

  @override
  double getRadiusForProperty(TaxLien property) => radiusFromValue(property.estimatedValue);
}

/// County dimension: Clustered by geographic proximity
class CountyDimensionLayout extends DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.county;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    final byCounty = <String, List<TaxLien>>{};
    for (final p in properties) {
      byCounty.putIfAbsent(p.county, () => []).add(p);
    }

    final counties = byCounty.keys.toList()..sort();
    final positions = <SpatialPosition>[];

    // Arrange counties in a grid
    final cols = math.sqrt(counties.length).ceil();
    final rows = (counties.length / cols).ceil();

    for (var countyIdx = 0; countyIdx < counties.length; countyIdx++) {
      final county = counties[countyIdx];
      final countyProperties = byCounty[county]!;

      final col = countyIdx % cols;
      final row = countyIdx ~/ cols;
      final centerX = (col + 0.5) / cols;
      final centerY = (row + 0.5) / rows;

      // Spiral layout within county cluster
      for (var i = 0; i < countyProperties.length; i++) {
        final p = countyProperties[i];
        final angle = i * 0.5;
        final radius = 0.02 + (i * 0.008).clamp(0.0, 0.08);

        positions.add(SpatialPosition(
          propertyId: p.id,
          x: (centerX + radius * math.cos(angle)).clamp(0.05, 0.95),
          y: (centerY + radius * math.sin(angle)).clamp(0.05, 0.95),
          color: getColorForProperty(p),
          radius: getRadiusForProperty(p),
        ));
      }
    }
    return positions;
  }

  @override
  Color getColorForProperty(TaxLien property) {
    // Color by county (hash-based)
    final hash = property.county.hashCode;
    return Color.fromARGB(
      255,
      (hash & 0xFF0000) >> 16,
      (hash & 0x00FF00) >> 8,
      hash & 0x0000FF,
    ).withOpacity(0.8);
  }

  @override
  double getRadiusForProperty(TaxLien property) => radiusFromValue(property.estimatedValue);
}

/// FVI dimension: X = FVI score, Y = tax_amount
class FviDimensionLayout extends DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.fvi;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    final taxAmounts = properties.map((p) => p.taxAmount).where((v) => v > 0);
    if (taxAmounts.isEmpty) return [];
    final minTax = taxAmounts.reduce((a, b) => a < b ? a : b);
    final maxTax = taxAmounts.reduce((a, b) => a > b ? a : b);
    final taxRange = maxTax - minTax;

    return properties.map((p) {
      final fviScore = p.fvi?.score ?? 0.5;
      final x = fviScore.clamp(0.0, 1.0);
      final y = taxRange > 0
          ? ((p.taxAmount - minTax) / taxRange).clamp(0.0, 1.0)
          : 0.5;

      return SpatialPosition(
        propertyId: p.id,
        x: withMargin(x),
        y: withMargin(1 - y),
        color: getColorForProperty(p),
        radius: getRadiusForProperty(p),
      );
    }).toList();
  }

  @override
  Color getColorForProperty(TaxLien property) {
    final score = property.fvi?.score ?? 0.5;
    if (score >= 0.7) return AppColors.success;
    if (score >= 0.4) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  double getRadiusForProperty(TaxLien property) => radiusFromTaxAmount(property.taxAmount);
}

/// Type dimension: Clustered by property_type
class TypeDimensionLayout extends DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.type;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    final byType = <String, List<TaxLien>>{};
    for (final p in properties) {
      final type = p.propertyType.isNotEmpty ? p.propertyType : 'Other';
      byType.putIfAbsent(type, () => []).add(p);
    }

    final types = byType.keys.toList()..sort();
    final positions = <SpatialPosition>[];

    // Predefined cluster centers for common types
    final typeCenters = <String, Offset>{
      'Single Family': const Offset(0.25, 0.25),
      'SFR': const Offset(0.25, 0.25),
      'Land': const Offset(0.75, 0.25),
      'Vacant Land': const Offset(0.75, 0.25),
      'Commercial': const Offset(0.25, 0.75),
      'Condo': const Offset(0.75, 0.75),
      'Multi-Family': const Offset(0.5, 0.5),
      'Other': const Offset(0.5, 0.85),
    };

    for (final type in types) {
      final typeProperties = byType[type]!;
      final center = typeCenters[type] ?? Offset(0.5, 0.5);

      for (var i = 0; i < typeProperties.length; i++) {
        final p = typeProperties[i];
        final angle = i * 0.618; // Golden angle
        final radius = 0.02 + (i * 0.006).clamp(0.0, 0.12);

        positions.add(SpatialPosition(
          propertyId: p.id,
          x: (center.dx + radius * math.cos(angle)).clamp(0.05, 0.95),
          y: (center.dy + radius * math.sin(angle)).clamp(0.05, 0.95),
          color: getColorForProperty(p),
          radius: getRadiusForProperty(p),
        ));
      }
    }
    return positions;
  }

  @override
  Color getColorForProperty(TaxLien property) {
    return switch (property.propertyType.toLowerCase()) {
      'single family' || 'sfr' => const Color(0xFF4CAF50),
      'land' || 'vacant land' => const Color(0xFF8BC34A),
      'commercial' => const Color(0xFF2196F3),
      'condo' => const Color(0xFF9C27B0),
      'multi-family' => const Color(0xFFFF9800),
      _ => AppColors.fg2,
    };
  }

  @override
  double getRadiusForProperty(TaxLien property) => radiusFromValue(property.estimatedValue);
}

/// Prior Years dimension: X = prior_years_owed, Y = tax_amount
class PriorYearsDimensionLayout extends DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.priorYears;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    const maxYears = 5.0;
    final taxAmounts = properties.map((p) => p.taxAmount).where((v) => v > 0);
    if (taxAmounts.isEmpty) return [];
    final minTax = taxAmounts.reduce((a, b) => a < b ? a : b);
    final maxTax = taxAmounts.reduce((a, b) => a > b ? a : b);
    final taxRange = maxTax - minTax;

    return properties.map((p) {
      final years = (p.priorYearsOwed ?? 1).clamp(1, 6);
      final x = (years - 1) / maxYears;
      final y = taxRange > 0
          ? ((p.taxAmount - minTax) / taxRange).clamp(0.0, 1.0)
          : 0.5;

      return SpatialPosition(
        propertyId: p.id,
        x: withMargin(x),
        y: withMargin(1 - y),
        color: getColorForProperty(p),
        radius: getRadiusForProperty(p),
      );
    }).toList();
  }

  @override
  Color getColorForProperty(TaxLien property) {
    final years = property.priorYearsOwed ?? 1;
    if (years >= 4) return AppColors.danger;
    if (years >= 2) return AppColors.warning;
    return AppColors.success;
  }

  @override
  double getRadiusForProperty(TaxLien property) => radiusFromTaxAmount(property.taxAmount);
}

/// Exemptions dimension: Clusters by exemption type
class ExemptionsDimensionLayout extends DimensionLayout {
  static const _exemptionClusters = {
    'homestead': Offset(0.25, 0.25),
    'veteran': Offset(0.75, 0.25),
    'senior': Offset(0.25, 0.75),
    'disability': Offset(0.75, 0.75),
    'none': Offset(0.5, 0.5),
  };

  @override
  GalaxyDimension get dimension => GalaxyDimension.exemptions;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    final byExemption = <String, List<TaxLien>>{};
    for (final p in properties) {
      final exemption = _getPrimaryExemption(p);
      byExemption.putIfAbsent(exemption, () => []).add(p);
    }

    final positions = <SpatialPosition>[];
    for (final entry in byExemption.entries) {
      final cluster = _exemptionClusters[entry.key] ?? const Offset(0.5, 0.5);

      for (var i = 0; i < entry.value.length; i++) {
        final p = entry.value[i];
        final angle = i * 0.5;
        final radius = 0.02 + (i * 0.01).clamp(0.0, 0.15);

        positions.add(SpatialPosition(
          propertyId: p.id,
          x: (cluster.dx + radius * math.cos(angle)).clamp(0.05, 0.95),
          y: (cluster.dy + radius * math.sin(angle)).clamp(0.05, 0.95),
          color: getColorForProperty(p),
          radius: getRadiusForProperty(p),
        ));
      }
    }
    return positions;
  }

  String _getPrimaryExemption(TaxLien p) {
    if (p.hasHomesteadExemption == true) return 'homestead';
    if (p.hasVeteranExemption == true) return 'veteran';
    if (p.hasSeniorExemption == true) return 'senior';
    if (p.hasDisabilityExemption == true) return 'disability';
    return 'none';
  }

  @override
  Color getColorForProperty(TaxLien property) {
    if (property.hasHomesteadExemption == true) return AppColors.exemptionHomestead;
    if (property.hasVeteranExemption == true) return AppColors.exemptionVeteran;
    if (property.hasSeniorExemption == true) return AppColors.exemptionSenior;
    if (property.hasDisabilityExemption == true) return AppColors.exemptionDisability;
    return AppColors.fg2;
  }

  @override
  double getRadiusForProperty(TaxLien property) => radiusFromValue(property.estimatedValue);
}

/// Owner Tenure dimension: X = owner_tenure_years, Y = redemption_probability
class OwnerTenureDimensionLayout extends DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.ownerTenure;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    const maxTenure = 30.0;

    return properties.map((p) {
      final tenure = (p.ownerTenureYears ?? 0).clamp(0, 30);
      final x = tenure / maxTenure;
      final redemptionProb = p.redemptionProbability ?? 0.5;

      return SpatialPosition(
        propertyId: p.id,
        x: withMargin(x),
        y: withMargin(1 - redemptionProb),
        color: getColorForProperty(p),
        radius: getRadiusForProperty(p),
      );
    }).toList();
  }

  @override
  Color getColorForProperty(TaxLien property) {
    final tenure = property.ownerTenureYears ?? 0;
    if (tenure >= 15) return AppColors.success; // Long-term, stable
    if (tenure >= 5) return AppColors.warning;
    return AppColors.brandBlue; // Recent
  }

  @override
  double getRadiusForProperty(TaxLien property) => radiusFromValue(property.estimatedValue);
}

/// Payback dimension: X = payback_months, Y = expected_roi
class PaybackDimensionLayout extends DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.payback;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    const maxPayback = 36.0; // 3 years max

    return properties.map((p) {
      final payback = (p.paybackMonths ?? 12).clamp(1, 36);
      final x = payback / maxPayback;
      final roi = (p.expectedRoi ?? 0.1).clamp(0.0, 0.35);

      return SpatialPosition(
        propertyId: p.id,
        x: withMargin(x),
        y: withMargin(1 - roi / 0.35), // High ROI at top
        color: getColorForProperty(p),
        radius: getRadiusForProperty(p),
      );
    }).toList();
  }

  @override
  Color getColorForProperty(TaxLien property) {
    final payback = property.paybackMonths ?? 12;
    if (payback <= 6) return AppColors.success; // Quick payback
    if (payback <= 18) return AppColors.warning;
    return AppColors.danger; // Long payback
  }

  @override
  double getRadiusForProperty(TaxLien property) => radiusFromTaxAmount(property.taxAmount);
}

/// Tax Year dimension: X = tax_year, Y = county
class TaxYearDimensionLayout extends DimensionLayout {
  @override
  GalaxyDimension get dimension => GalaxyDimension.taxYear;

  @override
  List<SpatialPosition> calculatePositions(List<TaxLien> properties) {
    final years = properties.map((p) => p.taxYear?.year ?? DateTime.now().year).toSet().toList()..sort();
    final minYear = years.isNotEmpty ? years.first : DateTime.now().year - 3;
    final maxYear = years.isNotEmpty ? years.last : DateTime.now().year;
    final yearRange = maxYear - minYear;

    final countyIndices = <String, int>{};
    for (final p in properties) {
      countyIndices.putIfAbsent(p.county, () => countyIndices.length);
    }

    return properties.map((p) {
      final year = p.taxYear?.year ?? DateTime.now().year;
      final x = yearRange > 0 ? (year - minYear) / yearRange : 0.5;
      final countyIdx = countyIndices[p.county] ?? 0;
      final y = countyIndices.length > 1
          ? (countyIdx + 0.5) / countyIndices.length
          : 0.5;

      return SpatialPosition(
        propertyId: p.id,
        x: withMargin(x),
        y: withMargin(y),
        color: getColorForProperty(p),
        radius: getRadiusForProperty(p),
      );
    }).toList();
  }

  @override
  Color getColorForProperty(TaxLien property) {
    final year = property.taxYear?.year ?? DateTime.now().year;
    final age = DateTime.now().year - year;
    if (age >= 3) return AppColors.danger; // Old taxes
    if (age >= 1) return AppColors.warning;
    return AppColors.brandBlue; // Current year
  }

  @override
  double getRadiusForProperty(TaxLien property) => radiusFromTaxAmount(property.taxAmount);
}
