import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens from VPN Client Pro design system
class AppTypography {
  AppTypography._();

  static TextStyle get timer => GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: -0.01,
      );

  static TextStyle get title => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.15,
      );

  static TextStyle get screenTitle => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.3,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.0,
      );

  static TextStyle get secondary => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.35,
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.0,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.3,
      );

  static TextStyle get small => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.2,
      );

  // Galaxy-specific
  static TextStyle get clusterCount => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.0,
        color: Colors.white,
      );

  static TextStyle get dimensionLabel => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.0,
      );

  static TextStyle get statValue => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.0,
      );

  static TextStyle get statLabel => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.0,
      );
}
