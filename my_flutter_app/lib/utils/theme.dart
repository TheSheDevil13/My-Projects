import 'package:flutter/material.dart';

class AppColors {
  // Primary colors from the IoT website theme
  static const Color primaryDark = Color(0xFF1A1F2E); // Dark blue background
  static const Color primaryBlue = Color(0xFF2C3A52); // Medium blue
  static const Color accentCyan = Color(0xFF00BCD4); // Bright cyan/turquoise
  static const Color accentCyanLight = Color(0xFF4DD0E1); // Light cyan
  
  // UI colors
  static const Color cardBackground = Color(0xFF2A3441); // Card background
  static const Color surfaceColor = Color(0xFF1E2532); // Surface color
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textHint = Color(0xFF78909C);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = accentCyan;
  
  // Device status colors
  static const Color connected = success;
  static const Color disconnected = Color(0xFF546E7A);
  static const Color scanning = accentCyan;
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.accentCyan,
      scaffoldBackgroundColor: AppColors.primaryDark,
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentCyan,
        secondary: AppColors.accentCyanLight,
        surface: AppColors.surfaceColor,
        background: AppColors.primaryDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentCyan,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentCyan,
        foregroundColor: Colors.white,
      ),
      
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(AppColors.primaryBlue),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentCyan.withOpacity(0.1);
          }
          return AppColors.cardBackground;
        }),
        headingTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        dataTextStyle: const TextStyle(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
