import 'tax_lien_models.dart';

/// Statistics computed from a selection of properties
class SelectionStats {
  final int count;
  final double totalValue;
  final double totalLienAmount;
  final double averageRoi;
  final double averageExpectedRoi; // ML-predicted expected_roi
  final double averageRedemptionProb; // Average redemption_probability
  final double averageRiskScore; // Average risk_score (0-100)
  final int averagePaybackMonths; // Average payback_months
  final Map<String, int> riskDistribution; // low, medium, high based on risk_score
  final Map<String, int> stageDistribution; // pre-auction, listed, otc, sold
  final Map<String, int> exemptionDistribution; // homestead, veteran, senior, none
  final Set<String> counties;
  final Set<String> propertyTypes;

  const SelectionStats({
    required this.count,
    required this.totalValue,
    required this.totalLienAmount,
    required this.averageRoi,
    required this.averageExpectedRoi,
    required this.averageRedemptionProb,
    required this.averageRiskScore,
    required this.averagePaybackMonths,
    required this.riskDistribution,
    required this.stageDistribution,
    required this.exemptionDistribution,
    required this.counties,
    required this.propertyTypes,
  });

  factory SelectionStats.empty() => const SelectionStats(
        count: 0,
        totalValue: 0,
        totalLienAmount: 0,
        averageRoi: 0,
        averageExpectedRoi: 0,
        averageRedemptionProb: 0,
        averageRiskScore: 0,
        averagePaybackMonths: 0,
        riskDistribution: {},
        stageDistribution: {},
        exemptionDistribution: {},
        counties: {},
        propertyTypes: {},
      );

  factory SelectionStats.fromProperties(List<TaxLien> properties) {
    if (properties.isEmpty) return SelectionStats.empty();

    double totalValue = 0;
    double totalLien = 0;
    double totalRoi = 0;
    double totalExpectedRoi = 0;
    double totalRedemptionProb = 0;
    double totalRiskScore = 0;
    int totalPaybackMonths = 0;
    int countWithExpectedRoi = 0;
    int countWithRedemption = 0;
    int countWithRisk = 0;
    int countWithPayback = 0;

    final riskDist = <String, int>{'low': 0, 'medium': 0, 'high': 0};
    final stageDist = <String, int>{};
    final exemptionDist = <String, int>{
      'homestead': 0,
      'veteran': 0,
      'senior': 0,
      'none': 0
    };
    final counties = <String>{};
    final propertyTypes = <String>{};

    for (final p in properties) {
      totalValue += p.estimatedValue;
      totalLien += p.taxAmount;

      // Simple ROI calculation
      if (p.taxAmount > 0) {
        final roi = (p.estimatedValue - p.taxAmount) / p.taxAmount * 100;
        totalRoi += roi;
      }

      // ML-predicted expected_roi
      if (p.expectedRoi != null) {
        totalExpectedRoi += p.expectedRoi!;
        countWithExpectedRoi++;
      }

      // Redemption probability (inverse of foreclosure opportunity)
      if (p.redemptionProbability != null) {
        totalRedemptionProb += p.redemptionProbability!;
        countWithRedemption++;
      }

      // Risk score (0-100)
      if (p.riskScore != null) {
        totalRiskScore += p.riskScore!;
        countWithRisk++;

        // Risk distribution based on risk_score
        if (p.riskScore! <= 30) {
          riskDist['low'] = (riskDist['low'] ?? 0) + 1;
        } else if (p.riskScore! <= 70) {
          riskDist['medium'] = (riskDist['medium'] ?? 0) + 1;
        } else {
          riskDist['high'] = (riskDist['high'] ?? 0) + 1;
        }
      }

      // Payback months
      if (p.paybackMonths != null) {
        totalPaybackMonths += p.paybackMonths!;
        countWithPayback++;
      }

      // Stage distribution
      final stage = p.listingStage;
      stageDist[stage] = (stageDist[stage] ?? 0) + 1;

      // Exemption distribution
      if (p.hasHomesteadExemption == true) {
        exemptionDist['homestead'] = (exemptionDist['homestead'] ?? 0) + 1;
      } else if (p.hasVeteranExemption == true) {
        exemptionDist['veteran'] = (exemptionDist['veteran'] ?? 0) + 1;
      } else if (p.hasSeniorExemption == true) {
        exemptionDist['senior'] = (exemptionDist['senior'] ?? 0) + 1;
      } else {
        exemptionDist['none'] = (exemptionDist['none'] ?? 0) + 1;
      }

      counties.add(p.county);
      if (p.propertyType.isNotEmpty) {
        propertyTypes.add(p.propertyType);
      }
    }

    return SelectionStats(
      count: properties.length,
      totalValue: totalValue,
      totalLienAmount: totalLien,
      averageRoi: properties.isNotEmpty ? totalRoi / properties.length : 0,
      averageExpectedRoi:
          countWithExpectedRoi > 0 ? totalExpectedRoi / countWithExpectedRoi : 0,
      averageRedemptionProb:
          countWithRedemption > 0 ? totalRedemptionProb / countWithRedemption : 0,
      averageRiskScore: countWithRisk > 0 ? totalRiskScore / countWithRisk : 0,
      averagePaybackMonths: countWithPayback > 0
          ? (totalPaybackMonths / countWithPayback).round()
          : 0,
      riskDistribution: riskDist,
      stageDistribution: stageDist,
      exemptionDistribution: exemptionDist,
      counties: counties,
      propertyTypes: propertyTypes,
    );
  }

  /// Format total value for display
  String get formattedTotalValue => _formatCurrency(totalValue);

  /// Format lien amount for display
  String get formattedLienAmount => _formatCurrency(totalLienAmount);

  /// Summary text for floating panel
  String get summaryText {
    final parts = <String>[];
    parts.add('$count selected');
    parts.add(formattedLienAmount);
    if (averageExpectedRoi > 0) {
      parts.add('${(averageExpectedRoi * 100).toStringAsFixed(1)}% avg ROI');
    }
    return parts.join(' • ');
  }

  /// Detailed summary for expanded panel
  String get detailedSummary {
    final lines = <String>[
      '$count properties selected',
      'Total Value: $formattedTotalValue',
      'Total Lien: $formattedLienAmount',
    ];
    if (averageExpectedRoi > 0) {
      lines.add('Avg ROI: ${(averageExpectedRoi * 100).toStringAsFixed(1)}%');
    }
    if (averageRiskScore > 0) {
      lines.add('Avg Risk: ${averageRiskScore.toStringAsFixed(0)}/100');
    }
    if (counties.isNotEmpty) {
      lines.add('Counties: ${counties.length}');
    }
    return lines.join('\n');
  }

  static String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}k';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  /// Check if selection has any high-risk properties
  bool get hasHighRisk => (riskDistribution['high'] ?? 0) > 0;

  /// Check if selection has any exemption properties
  bool get hasExemptions {
    return (exemptionDistribution['homestead'] ?? 0) > 0 ||
        (exemptionDistribution['veteran'] ?? 0) > 0 ||
        (exemptionDistribution['senior'] ?? 0) > 0;
  }

  @override
  String toString() => 'SelectionStats($count properties, $formattedLienAmount)';
}
