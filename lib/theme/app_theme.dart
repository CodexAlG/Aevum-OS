import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aevum_os/theme/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        surface: AppColors.surface,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.rajdhani(
          color: AppColors.textTitle,
          fontWeight: FontWeight.bold,
          fontSize: 28,
          letterSpacing: 2.0,
        ),
        titleLarge: GoogleFonts.rajdhani(
          color: AppColors.textTitle,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        bodyLarge: const TextStyle(color: AppColors.textTitle),
        bodySmall: const TextStyle(color: AppColors.textSub),
        labelSmall: GoogleFonts.rajdhani(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 10,
          letterSpacing: 3.0,
        ),
      ),
    );
  }
}
