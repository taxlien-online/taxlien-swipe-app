import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Design system typography tokens for Tax Lien App.
/// Source: designsystem/colors_and_type.css
abstract final class AppTypography {
  static String get _fontFamily => GoogleFonts.inter().fontFamily!;

  // ─── Light Theme Styles ──────────────────────────────────────

  /// Timer style - FVI mega-number (40/700)
  static TextStyle get timer => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: -0.4, // -0.01em
        color: AppColors.fg1,
      );

  /// Title style - Screen titles (24/600)
  static TextStyle get title => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.15,
        color: AppColors.fg1,
      );

  /// Screen style - Section headers (20/600)
  static TextStyle get screen => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.fg1,
      );

  /// Body style - Default text (17/400)
  static TextStyle get body => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: AppColors.fg1,
      );

  /// Button style - Button labels (17/500)
  static TextStyle get button => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.0,
        color: Colors.white,
      );

  /// Secondary style - Muted labels (15/400)
  static TextStyle get secondary => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: AppColors.fg2,
      );

  /// Label style - Stat tile labels (14/500)
  static TextStyle get label => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.0,
        letterSpacing: 0.56, // 0.04em
        color: AppColors.fg1,
      );

  /// Caption style - IDs, timestamps (13/400)
  static TextStyle get caption => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: AppColors.fg2,
      );

  // ─── Dark Theme Styles ───────────────────────────────────────

  static TextStyle get timerDark => timer.copyWith(color: AppColors.fg1Dark);
  static TextStyle get titleDark => title.copyWith(color: AppColors.fg1Dark);
  static TextStyle get screenDark => screen.copyWith(color: AppColors.fg1Dark);
  static TextStyle get bodyDark => body.copyWith(color: AppColors.fg1Dark);
  static TextStyle get secondaryDark =>
      secondary.copyWith(color: AppColors.fg2Dark);
  static TextStyle get labelDark => label.copyWith(color: AppColors.fg1Dark);
  static TextStyle get captionDark =>
      caption.copyWith(color: AppColors.fg2Dark);
}
