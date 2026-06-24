import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accentGold,
        surface: AppColors.surfaceLight,
      ),
      textTheme: GoogleFonts.elMessiriTextTheme().copyWith(
        displayLarge: GoogleFonts.elMessiri(color: AppColors.textPrimaryLight),
        bodyLarge: GoogleFonts.elMessiri(color: AppColors.textPrimaryLight),
        bodyMedium: GoogleFonts.elMessiri(color: AppColors.textSecondaryLight),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
        titleTextStyle: GoogleFonts.elMessiri(
          color: AppColors.textPrimaryLight,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.textSecondaryLight.withOpacity(0.1)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accentGold,
        surface: AppColors.surfaceDark,
      ),
      textTheme: GoogleFonts.elMessiriTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.elMessiri(color: AppColors.textPrimaryDark),
        bodyLarge: GoogleFonts.elMessiri(color: AppColors.textPrimaryDark),
        bodyMedium: GoogleFonts.elMessiri(color: AppColors.textSecondaryDark),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
        titleTextStyle: GoogleFonts.elMessiri(
          color: AppColors.textPrimaryDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.textSecondaryDark.withOpacity(0.1)),
        ),
      ),
    );
  }
}
