import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.outfit().fontFamily,
      primaryColor: AppColors.primaryGreen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentGreen,
        surface: AppColors.cardBackground,
        error: AppColors.red,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.headerBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          color: AppColors.darkText,
          fontSize: 36,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.outfit(
          color: AppColors.darkText,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.outfit(
          color: AppColors.darkText,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        headlineLarge: GoogleFonts.outfit(
          color: AppColors.darkText,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.outfit(
          color: AppColors.darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.outfit(
          color: AppColors.darkText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.outfit(
          color: AppColors.darkText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.outfit(
          color: AppColors.darkText,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.outfit(
          color: AppColors.secondaryText,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: AppColors.darkText,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: GoogleFonts.outfit(
          color: AppColors.darkText,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: GoogleFonts.outfit(
          color: AppColors.secondaryText,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: GoogleFonts.outfit(
          color: AppColors.darkText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: GoogleFonts.outfit(
          color: AppColors.secondaryText,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.outfit(
          color: AppColors.secondaryText,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: GoogleFonts.outfit(
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        dataTextStyle: GoogleFonts.outfit(
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
          color: AppColors.darkText,
        ),
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
        dividerThickness: 1,
        horizontalMargin: 20.0,
        columnSpacing: 20.0,
        headingRowHeight: 52.0,
        dataRowMinHeight: 48.0,
        dataRowMaxHeight: 52.0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          textStyle: GoogleFonts.outfit(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkText,
          side: const BorderSide(color: AppColors.border),
          textStyle: GoogleFonts.outfit(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: GoogleFonts.outfit(
          color: AppColors.secondaryText,
          fontSize: 13.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
