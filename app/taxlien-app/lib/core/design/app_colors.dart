import 'package:flutter/material.dart';

/// Design tokens from VPN Client Pro design system
/// Adapted for Tax Lien domain
class AppColors {
  AppColors._();

  // Brand
  static const brandCyan = Color(0xFF00C6FB);
  static const brandBlue = Color(0xFF005BEA);
  static const brandGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [brandCyan, brandBlue],
  );
  static const brandGradientSoft = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE6F8FF), Color(0xFFE6EEFD)],
  );

  // Light theme neutrals
  static const bg = Color(0xFFF8F9FA);
  static const surface = Color(0xFFFFFFFF);
  static const fg1 = Color(0xFF303F49);
  static const fg2 = Color(0xFFB6B6B6);
  static const fg3 = Color(0xFFA2A2A2);
  static const line = Color(0x199CB2C2); // 10% opacity
  static const disabled = Color(0xFFE0E0E0);

  // Dark theme neutrals
  static const bgDark = Color(0xFF0F1419);
  static const surfaceDark = Color(0xFF1A2129);
  static const surfaceDark2 = Color(0xFF222B33);
  static const fg1Dark = Color(0xFFE7ECEF);
  static const switchTrackDark = Color(0xFF3A4750);

  // Semantic
  static const success = Color(0xFF1FB67A);
  static const warning = Color(0xFFFFB020);
  static const danger = Color(0xFFE5484D);

  // Domain-specific (Tax Lien)
  static const roiHigh = success;
  static const roiMedium = warning;
  static const roiLow = danger;

  static const riskLow = success;
  static const riskMedium = warning;
  static const riskHigh = danger;

  static const stageListed = brandBlue;
  static const stageOtc = Color(0xFFFF9800);
  static const stagePreAuction = Color(0xFF9C27B0);
  static const stageSold = fg2;

  // Exemption badge colors
  static const exemptionHomestead = Color(0xFF4CAF50);
  static const exemptionVeteran = Color(0xFF2196F3);
  static const exemptionSenior = Color(0xFF9C27B0);
  static const exemptionDisability = Color(0xFFFF9800);

  // Selection colors
  static const selected = brandCyan;
  static const lassoStroke = brandBlue;
  static const lassoFill = Color(0x20005BEA);
  static const xrayOverlay = Color(0x40005BEA);

  // X-Ray insight colors
  static const insightWarning = danger;
  static const insightOpportunity = success;
  static const insightEthical = Color(0xFF9C27B0);
  static const insightInfo = brandBlue;
  static const insightStale = warning;

  // Galaxy point colors by dimension
  static Color roiColor(double roi) {
    if (roi >= 0.20) return roiHigh;
    if (roi >= 0.10) return roiMedium;
    return roiLow;
  }

  static Color riskColor(double riskScore) {
    if (riskScore <= 30) return riskLow;
    if (riskScore <= 70) return riskMedium;
    return riskHigh;
  }

  static Color stageColor(String stage) {
    return switch (stage) {
      'pre-auction' || 'pre_auction' => stagePreAuction,
      'listed' => stageListed,
      'otc' => stageOtc,
      'sold' => stageSold,
      _ => fg2,
    };
  }
}
