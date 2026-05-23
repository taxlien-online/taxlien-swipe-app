import '../../../core/models/tax_lien_models.dart';
import '../../../core/models/xray_insight.dart';

/// Rule-based insight generator for X-Ray mode
class XRayInsightGenerator {
  /// Generate all applicable insights for a property
  List<XRayInsight> generateInsights(TaxLien property) {
    final insights = <XRayInsight>[];

    // Warning insights
    insights.addAll(_generateWarningInsights(property));

    // Opportunity insights
    insights.addAll(_generateOpportunityInsights(property));

    // Ethical insights
    insights.addAll(_generateEthicalInsights(property));

    // Informational insights
    insights.addAll(_generateInformationalInsights(property));

    // Data staleness insights
    insights.addAll(_generateDataInsights(property));

    // Sort by priority
    return insights.sortedByPriority();
  }

  /// Get the most important insight for badge display
  XRayInsight? getPrimaryInsight(TaxLien property) {
    final insights = generateInsights(property);
    if (insights.isEmpty) return null;

    // Return highest priority insight
    return insights.first;
  }

  /// Generate insights for a selection of properties
  List<XRayInsight> generateSelectionInsights(List<TaxLien> properties) {
    if (properties.isEmpty) return [];

    final insights = <XRayInsight>[];

    // Aggregate stats
    final totalValue = properties.fold<double>(0, (sum, p) => sum + p.estimatedValue);
    final totalLien = properties.fold<double>(0, (sum, p) => sum + p.taxAmount);
    final avgRoi = properties
        .where((p) => p.expectedRoi != null)
        .fold<double>(0, (sum, p) => sum + p.expectedRoi!) /
        properties.where((p) => p.expectedRoi != null).length;

    // Selection-level insights
    final highRiskCount = properties.where((p) => (p.riskScore ?? 0) > 70).length;
    if (highRiskCount > 0) {
      insights.add(XRayInsight(
        type: XRayInsightType.warning,
        category: XRayInsightCategory.risk,
        title: 'High Risk Properties',
        description: '$highRiskCount of ${properties.length} have high risk scores',
        actionHint: 'Review individually before proceeding',
      ));
    }

    final exemptionCount = properties.where((p) =>
        p.hasHomesteadExemption == true ||
        p.hasVeteranExemption == true ||
        p.hasSeniorExemption == true).length;
    if (exemptionCount > 0) {
      insights.add(XRayInsight(
        type: XRayInsightType.ethical,
        category: XRayInsightCategory.compliance,
        title: 'Protected Owners',
        description: '$exemptionCount properties have owner exemptions',
        actionHint: 'Consider ethical implications',
      ));
    }

    if (avgRoi > 0.20) {
      insights.add(XRayInsight(
        type: XRayInsightType.opportunity,
        category: XRayInsightCategory.financial,
        title: 'High Average ROI',
        description: '${(avgRoi * 100).toStringAsFixed(1)}% average expected return',
      ));
    }

    return insights.sortedByPriority();
  }

  List<XRayInsight> _generateWarningInsights(TaxLien p) {
    final insights = <XRayInsight>[];

    // High redemption probability warning
    if ((p.redemptionProbability ?? 0) > 0.7) {
      insights.add(XRayInsight(
        type: XRayInsightType.warning,
        category: XRayInsightCategory.risk,
        title: 'High Redemption Risk',
        description:
            '${(p.redemptionProbability! * 100).toStringAsFixed(0)}% probability owner will redeem',
        field: 'redemption_probability',
        confidence: p.redemptionProbability,
        actionHint: 'Consider lower-risk alternatives',
      ));
    }

    // Flood zone warning
    if (p.floodZone != null && p.floodZone != 'X' && p.floodZone != 'C') {
      insights.add(XRayInsight(
        type: XRayInsightType.warning,
        category: XRayInsightCategory.location,
        title: 'Flood Zone: ${p.floodZone}',
        description: 'Property is in FEMA flood zone, may require insurance',
        field: 'flood_zone',
        actionHint: 'Factor flood insurance into ROI calculation',
      ));
    }

    // Multi-year delinquency
    if ((p.priorYearsOwed ?? 0) >= 3) {
      insights.add(XRayInsight(
        type: XRayInsightType.warning,
        category: XRayInsightCategory.risk,
        title: 'Multi-Year Delinquency',
        description: '${p.priorYearsOwed} years of unpaid taxes',
        field: 'prior_years_owed',
        actionHint: 'May indicate severe financial distress',
      ));
    }

    // High risk score
    if ((p.riskScore ?? 0) > 70) {
      insights.add(XRayInsight(
        type: XRayInsightType.warning,
        category: XRayInsightCategory.risk,
        title: 'High Risk Score',
        description: 'Risk score: ${p.riskScore?.toStringAsFixed(0)}/100',
        field: 'risk_score',
        confidence: (p.riskScore ?? 0) / 100,
      ));
    }

    // Low school rating (property value risk)
    if ((p.schoolRating ?? 10) < 4) {
      insights.add(XRayInsight(
        type: XRayInsightType.warning,
        category: XRayInsightCategory.location,
        title: 'Low School Rating',
        description: 'School district rated ${p.schoolRating}/10',
        field: 'school_rating',
        actionHint: 'May affect resale value',
      ));
    }

    return insights;
  }

  List<XRayInsight> _generateOpportunityInsights(TaxLien p) {
    final insights = <XRayInsight>[];

    // High expected ROI
    if ((p.expectedRoi ?? 0) > 0.18) {
      insights.add(XRayInsight(
        type: XRayInsightType.opportunity,
        category: XRayInsightCategory.financial,
        title: 'High ROI Potential',
        description: '${(p.expectedRoi! * 100).toStringAsFixed(1)}% expected return',
        field: 'expected_roi',
        confidence: 0.85,
      ));
    }

    // Quick payback
    if ((p.paybackMonths ?? 999) <= 12) {
      insights.add(XRayInsight(
        type: XRayInsightType.opportunity,
        category: XRayInsightCategory.financial,
        title: 'Quick Payback',
        description: '${p.paybackMonths} month estimated payback period',
        field: 'payback_months',
      ));
    }

    // High WalkScore (desirable location)
    if ((p.walkScore ?? 0) >= 70) {
      insights.add(XRayInsight(
        type: XRayInsightType.opportunity,
        category: XRayInsightCategory.location,
        title: 'Very Walkable',
        description: 'Walk Score: ${p.walkScore} - desirable location',
        field: 'walk_score',
      ));
    }

    // Low redemption probability
    if ((p.redemptionProbability ?? 1) < 0.3) {
      insights.add(XRayInsight(
        type: XRayInsightType.opportunity,
        category: XRayInsightCategory.financial,
        title: 'Low Redemption Risk',
        description:
            'Only ${(p.redemptionProbability! * 100).toStringAsFixed(0)}% redemption probability',
        field: 'redemption_probability',
        confidence: 1 - p.redemptionProbability!,
      ));
    }

    // OTC available (no auction competition)
    if (p.listingStage == 'otc') {
      insights.add(XRayInsight(
        type: XRayInsightType.opportunity,
        category: XRayInsightCategory.financial,
        title: 'Over-the-Counter',
        description: 'No auction competition - direct purchase available',
        field: 'listing_stage',
      ));
    }

    // Recent Zillow value increase
    if ((p.zillowPriceChange30d ?? 0) > 0.02) {
      insights.add(XRayInsight(
        type: XRayInsightType.opportunity,
        category: XRayInsightCategory.financial,
        title: 'Value Trending Up',
        description: '+${(p.zillowPriceChange30d! * 100).toStringAsFixed(1)}% in 30 days',
        field: 'zillow_price_change_30d',
      ));
    }

    return insights;
  }

  List<XRayInsight> _generateEthicalInsights(TaxLien p) {
    final insights = <XRayInsight>[];

    // Homestead exemption (owner-occupied)
    if (p.hasHomesteadExemption == true) {
      insights.add(XRayInsight(
        type: XRayInsightType.ethical,
        category: XRayInsightCategory.compliance,
        title: 'Owner-Occupied Home',
        description: 'Homestead exemption indicates primary residence',
        field: 'has_homestead_exemption',
        actionHint: 'Consider ethical implications',
        metadata: {'exemption_type': 'homestead'},
      ));
    }

    // Veteran owner
    if (p.hasVeteranExemption == true) {
      insights.add(XRayInsight(
        type: XRayInsightType.ethical,
        category: XRayInsightCategory.compliance,
        title: 'Veteran Owner',
        description: 'Property owner is a military veteran',
        field: 'has_veteran_exemption',
        actionHint: 'VA may have assistance programs',
        metadata: {'exemption_type': 'veteran'},
      ));
    }

    // Senior owner
    if (p.hasSeniorExemption == true) {
      insights.add(XRayInsight(
        type: XRayInsightType.ethical,
        category: XRayInsightCategory.compliance,
        title: 'Senior Owner',
        description: 'Property owner qualifies for senior exemption',
        field: 'has_senior_exemption',
        actionHint: 'May have fixed income constraints',
        metadata: {'exemption_type': 'senior'},
      ));
    }

    // Disability exemption
    if (p.hasDisabilityExemption == true) {
      insights.add(XRayInsight(
        type: XRayInsightType.ethical,
        category: XRayInsightCategory.compliance,
        title: 'Disability Exemption',
        description: 'Owner has disability-based tax exemption',
        field: 'has_disability_exemption',
        actionHint: 'Consider accessibility if property acquired',
        metadata: {'exemption_type': 'disability'},
      ));
    }

    // No heirs flag
    if (p.noHeirs == true) {
      insights.add(XRayInsight(
        type: XRayInsightType.ethical,
        category: XRayInsightCategory.compliance,
        title: 'No Known Heirs',
        description: 'Property may be from deceased owner without heirs',
        field: 'no_heirs',
        actionHint: 'Title search recommended',
      ));
    }

    return insights;
  }

  List<XRayInsight> _generateInformationalInsights(TaxLien p) {
    final insights = <XRayInsight>[];

    // Long owner tenure (stable neighborhood)
    if ((p.ownerTenureYears ?? 0) >= 10) {
      insights.add(XRayInsight(
        type: XRayInsightType.informational,
        category: XRayInsightCategory.owner,
        title: 'Long-Term Owner',
        description: 'Owner has held property for ${p.ownerTenureYears}+ years',
        field: 'owner_tenure_years',
      ));
    }

    // Property type info
    if (p.propertyType.isNotEmpty) {
      insights.add(XRayInsight(
        type: XRayInsightType.informational,
        category: XRayInsightCategory.location,
        title: 'Property Type',
        description: p.propertyType,
        field: 'property_type',
      ));
    }

    // Lot size
    if ((p.lotSizeSqft ?? 0) > 0) {
      final acres = p.lotSizeSqft! / 43560;
      insights.add(XRayInsight(
        type: XRayInsightType.informational,
        category: XRayInsightCategory.location,
        title: 'Lot Size',
        description: acres >= 1
            ? '${acres.toStringAsFixed(2)} acres'
            : '${p.lotSizeSqft} sqft',
        field: 'lot_size_sqft',
      ));
    }

    // Year built
    if (p.yearBuilt != null) {
      final age = DateTime.now().year - p.yearBuilt!;
      insights.add(XRayInsight(
        type: XRayInsightType.informational,
        category: XRayInsightCategory.location,
        title: 'Built ${p.yearBuilt}',
        description: '$age years old',
        field: 'year_built',
      ));
    }

    return insights;
  }

  List<XRayInsight> _generateDataInsights(TaxLien p) {
    final insights = <XRayInsight>[];

    // Stale Zillow data
    if (p.zillowLastUpdated != null) {
      final daysSinceUpdate =
          DateTime.now().difference(p.zillowLastUpdated!).inDays;
      if (daysSinceUpdate > 30) {
        insights.add(XRayInsight(
          type: XRayInsightType.stale,
          category: XRayInsightCategory.data,
          title: 'Stale Valuation',
          description: 'Zillow data is $daysSinceUpdate days old',
          field: 'zillow_last_updated',
          actionHint: 'Request fresh valuation',
        ));
      }
    }

    // Missing critical data
    if (p.estimatedValue <= 0) {
      insights.add(XRayInsight(
        type: XRayInsightType.stale,
        category: XRayInsightCategory.data,
        title: 'Missing Valuation',
        description: 'No estimated value available',
        field: 'estimated_value',
        actionHint: 'Requires manual research',
      ));
    }

    return insights;
  }
}
