import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_flags/core/app_colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.light,

        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,

        error: AppColors.error,
        onError: AppColors.onError,

        surface: AppColors.surface,
        surfaceContainerHighest: AppColors.surfaceHighest,
        onSurface: AppColors.onSurface,

        outline: AppColors.outline,
        shadow: AppColors.shadow,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.onPrimary),
      ),

      textTheme: TextTheme(
        // SplashScreen title (big)
        displayLarge: GoogleFonts.calistoga(color: AppColors.primary),

        // Screen title.
        headlineLarge: GoogleFonts.inter(color: AppColors.primary),

        // Pager/Section Title.
        headlineMedium: GoogleFonts.inter(color: AppColors.primary),

        // Card Title.
        headlineSmall: GoogleFonts.inter(color: AppColors.primary),

        // Basic text.
        bodyLarge: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontWeight: FontWeight.normal,
        ),

        labelLarge: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontWeight: FontWeight.normal,
        ),
        labelMedium: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontWeight: FontWeight.normal,
        ),
        labelSmall: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w100,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
      ),

      scaffoldBackgroundColor: Color.fromARGB(255, 233, 233, 233),
    );
  }
}
