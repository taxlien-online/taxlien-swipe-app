import 'package:flutter/material.dart';

/// Dimensions for organizing properties in the Galaxy view
enum GalaxyDimension {
  // MVP Dimensions (7)
  date, // X: auction_date timeline, Y: county spread
  county, // Clustered by geographic proximity
  roi, // X: expected_roi percentage, Y: estimated_value
  risk, // X: risk_score (0-100), Y: redemption_probability
  stage, // Columns: pre-auction, listed, otc, sold
  fvi, // X: FVI score, Y: tax_amount
  type, // Clustered by property_type (SFR, Land, Commercial, etc.)

  // Extended Dimensions (Post-MVP)
  priorYears, // X: prior_years_owed (1-5+), Y: tax_amount
  exemptions, // Clusters: homestead | veteran | senior | none
  ownerTenure, // X: owner_tenure_years, Y: redemption_probability
  payback, // X: payback_months, Y: expected_roi
  taxYear, // X: tax_year, Y: county
}

extension GalaxyDimensionExt on GalaxyDimension {
  String get displayName => switch (this) {
        GalaxyDimension.date => 'Date',
        GalaxyDimension.county => 'County',
        GalaxyDimension.roi => 'ROI',
        GalaxyDimension.risk => 'Risk',
        GalaxyDimension.stage => 'Stage',
        GalaxyDimension.fvi => 'FVI',
        GalaxyDimension.type => 'Type',
        GalaxyDimension.priorYears => 'Prior Years',
        GalaxyDimension.exemptions => 'Exemptions',
        GalaxyDimension.ownerTenure => 'Tenure',
        GalaxyDimension.payback => 'Payback',
        GalaxyDimension.taxYear => 'Tax Year',
      };

  IconData get icon => switch (this) {
        GalaxyDimension.date => Icons.calendar_today,
        GalaxyDimension.county => Icons.map,
        GalaxyDimension.roi => Icons.trending_up,
        GalaxyDimension.risk => Icons.warning_amber,
        GalaxyDimension.stage => Icons.layers,
        GalaxyDimension.fvi => Icons.star,
        GalaxyDimension.type => Icons.home,
        GalaxyDimension.priorYears => Icons.history,
        GalaxyDimension.exemptions => Icons.shield,
        GalaxyDimension.ownerTenure => Icons.person_pin,
        GalaxyDimension.payback => Icons.access_time,
        GalaxyDimension.taxYear => Icons.date_range,
      };

  /// Whether this dimension is available in MVP
  bool get isMvp => switch (this) {
        GalaxyDimension.date ||
        GalaxyDimension.county ||
        GalaxyDimension.roi ||
        GalaxyDimension.risk ||
        GalaxyDimension.stage ||
        GalaxyDimension.fvi ||
        GalaxyDimension.type =>
          true,
        _ => false,
      };

  /// Description of what this dimension shows
  String get description => switch (this) {
        GalaxyDimension.date => 'Properties by auction date',
        GalaxyDimension.county => 'Grouped by county',
        GalaxyDimension.roi => 'By expected return on investment',
        GalaxyDimension.risk => 'By risk score and redemption probability',
        GalaxyDimension.stage => 'By listing stage',
        GalaxyDimension.fvi => 'By Fair Value Index score',
        GalaxyDimension.type => 'By property type',
        GalaxyDimension.priorYears => 'By years of tax delinquency',
        GalaxyDimension.exemptions => 'By owner exemption status',
        GalaxyDimension.ownerTenure => 'By how long owner has held property',
        GalaxyDimension.payback => 'By estimated payback period',
        GalaxyDimension.taxYear => 'By tax year',
      };

  /// X-axis label for this dimension
  String get xAxisLabel => switch (this) {
        GalaxyDimension.date => 'Auction Date',
        GalaxyDimension.county => 'Geographic',
        GalaxyDimension.roi => 'Expected ROI %',
        GalaxyDimension.risk => 'Risk Score',
        GalaxyDimension.stage => 'Stage',
        GalaxyDimension.fvi => 'FVI Score',
        GalaxyDimension.type => 'Type',
        GalaxyDimension.priorYears => 'Years Owed',
        GalaxyDimension.exemptions => 'Exemption Type',
        GalaxyDimension.ownerTenure => 'Owner Tenure (years)',
        GalaxyDimension.payback => 'Payback (months)',
        GalaxyDimension.taxYear => 'Tax Year',
      };

  /// Y-axis label for this dimension
  String get yAxisLabel => switch (this) {
        GalaxyDimension.date => 'County',
        GalaxyDimension.county => '',
        GalaxyDimension.roi => 'Property Value',
        GalaxyDimension.risk => 'Redemption Probability',
        GalaxyDimension.stage => 'Value',
        GalaxyDimension.fvi => 'Tax Amount',
        GalaxyDimension.type => '',
        GalaxyDimension.priorYears => 'Tax Amount',
        GalaxyDimension.exemptions => '',
        GalaxyDimension.ownerTenure => 'Redemption Probability',
        GalaxyDimension.payback => 'Expected ROI',
        GalaxyDimension.taxYear => 'County',
      };

  /// Get the next dimension in cycle (for rotation gesture)
  GalaxyDimension get next {
    final mvpDimensions =
        GalaxyDimension.values.where((d) => d.isMvp).toList();
    final currentIndex = mvpDimensions.indexOf(this);
    if (currentIndex == -1) return GalaxyDimension.date;
    return mvpDimensions[(currentIndex + 1) % mvpDimensions.length];
  }

  /// Get the previous dimension in cycle
  GalaxyDimension get previous {
    final mvpDimensions =
        GalaxyDimension.values.where((d) => d.isMvp).toList();
    final currentIndex = mvpDimensions.indexOf(this);
    if (currentIndex == -1) return GalaxyDimension.date;
    return mvpDimensions[
        (currentIndex - 1 + mvpDimensions.length) % mvpDimensions.length];
  }
}
