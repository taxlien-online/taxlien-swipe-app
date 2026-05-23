import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';

/// Theme builder for Tax Lien App.
/// Provides light and dark ThemeData configurations.
abstract final class AppTheme {
  /// Light theme configuration.
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.light(
          primary: AppColors.brandBlue,
          secondary: AppColors.brandCyan,
          surface: AppColors.surface,
          error: AppColors.danger,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.fg1,
          onError: Colors.white,
        ),
        textTheme: TextTheme(
          displayLarge: AppTypography.timer,
          headlineLarge: AppTypography.title,
          headlineMedium: AppTypography.screen,
          bodyLarge: AppTypography.body,
          bodyMedium: AppTypography.secondary,
          labelLarge: AppTypography.button,
          labelMedium: AppTypography.label,
          labelSmall: AppTypography.caption,
        ),
        cardTheme: CardTheme(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bg,
          foregroundColor: AppColors.fg1,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.line,
          thickness: 1,
          space: 1,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.brandBlue,
          unselectedItemColor: AppColors.fg2,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.brandBlue,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: AppRadius.md,
            borderSide: const BorderSide(color: AppColors.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.md,
            borderSide: const BorderSide(color: AppColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.md,
            borderSide: const BorderSide(color: AppColors.brandBlue, width: 1.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brandBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.custom(12),
            ),
            textStyle: AppTypography.button,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.fg1,
            side: const BorderSide(color: AppColors.line),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.custom(12),
            ),
            textStyle: AppTypography.button.copyWith(color: AppColors.fg1),
          ),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.fg1,
          size: 24,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.fg1,
          contentTextStyle: AppTypography.body.copyWith(color: Colors.white),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
        ),
      );

  /// Dark theme configuration.
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.brandBlue,
          secondary: AppColors.brandCyan,
          surface: AppColors.surfaceDark,
          error: AppColors.danger,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.fg1Dark,
          onError: Colors.white,
        ),
        textTheme: TextTheme(
          displayLarge: AppTypography.timerDark,
          headlineLarge: AppTypography.titleDark,
          headlineMedium: AppTypography.screenDark,
          bodyLarge: AppTypography.bodyDark,
          bodyMedium: AppTypography.secondaryDark,
          labelLarge: AppTypography.button,
          labelMedium: AppTypography.labelDark,
          labelSmall: AppTypography.captionDark,
        ),
        cardTheme: CardTheme(
          color: AppColors.surfaceDark,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bgDark,
          foregroundColor: AppColors.fg1Dark,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.lineDark,
          thickness: 1,
          space: 1,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surfaceDark,
          selectedItemColor: AppColors.brandBlue,
          unselectedItemColor: AppColors.fg2Dark,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.brandBlue,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceDark2,
          border: OutlineInputBorder(
            borderRadius: AppRadius.md,
            borderSide: const BorderSide(color: AppColors.lineDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.md,
            borderSide: const BorderSide(color: AppColors.lineDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.md,
            borderSide: const BorderSide(color: AppColors.brandBlue, width: 1.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brandBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.custom(12),
            ),
            textStyle: AppTypography.button,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.fg1Dark,
            side: const BorderSide(color: AppColors.lineDark),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.custom(12),
            ),
            textStyle: AppTypography.button.copyWith(color: AppColors.fg1Dark),
          ),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.fg1Dark,
          size: 24,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceDark2,
          contentTextStyle:
              AppTypography.bodyDark.copyWith(color: AppColors.fg1Dark),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
        ),
      );
}
