import 'package:flutter/material.dart';

/// Shadow tokens from VPN Client Pro design system
class AppShadows {
  AppShadows._();

  static List<BoxShadow> get card => [
        BoxShadow(
          color: const Color(0xFF9CB2C2).withOpacity(0.10),
          blurRadius: 32,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get cardStrong => [
        BoxShadow(
          color: const Color(0xFF9CB2C2).withOpacity(0.22),
          blurRadius: 24,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get modal => [
        BoxShadow(
          color: const Color(0xFF142332).withOpacity(0.20),
          blurRadius: 48,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> get floatingPanel => [
        BoxShadow(
          color: const Color(0xFF142332).withOpacity(0.15),
          blurRadius: 24,
          offset: const Offset(0, -4),
        ),
      ];

  static List<BoxShadow> get button => [
        BoxShadow(
          color: const Color(0xFF005BEA).withOpacity(0.30),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  // Dark theme shadows
  static List<BoxShadow> get cardDark => [
        BoxShadow(
          color: Colors.black.withOpacity(0.30),
          blurRadius: 32,
          offset: const Offset(0, 2),
        ),
      ];
}
