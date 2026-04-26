import 'package:flutter/material.dart';
import 'package:aevum_os/theme/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.surface,
      cardTheme: CardTheme(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSub,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: AppColors.textTitle, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(color: AppColors.textSub),
      ),
    );
  }
}
