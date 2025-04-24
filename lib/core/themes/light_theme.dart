import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final _colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: Color(0xFFFF4164),

  primary: Color(0xFFFF4164),
  onPrimary: Color.fromARGB(255, 240, 240, 240),

  error: Color(0xFFFF0000),
  onError: Color(0xFFFFFFFF),

  surface: Color(0xFFFAFAFA),
  surfaceContainerHighest: Color(0xFFFFFFFF),
  onSurface: Color(0xFF3A3A3A),
  onSurfaceVariant: Color(0xFF888888),

  outline: Color(0xFF3A3A3A),
  outlineVariant: Color(0xFF888888),
  shadow: Color(0x7E3A3A3A),
);

final _textTheme = TextTheme(
  // SplashScreen
  displayLarge: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: 0),

  // Page screen title. (On dark surface always).
  headlineLarge: GoogleFonts.nunitoSans(
    color: _colorScheme.onSurface,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.2,
  ),
  // Page screen subtitle. (On dark surface always).
  headlineMedium: GoogleFonts.nunitoSans(
    color: _colorScheme.onSurface,
    fontSize: 20,
    fontWeight: FontWeight.w100,
    letterSpacing: 0,
    height: 1.2,
  ),
  // Card Title.
  headlineSmall: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0),

  // ! (Not USED)
  titleLarge: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal),
  // ! (Not USED)
  titleMedium: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal),
  // ! (Not USED)
  titleSmall: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal),

  // Main content text.
  bodyLarge: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal, fontSize: 16),
  // Secondary content text.
  bodyMedium: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal, fontSize: 14),
  // ! (Not USED)
  bodySmall: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal, fontSize: 12),

  // Button Text.
  labelLarge: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal, fontSize: 18),
  // ! (Not USED)
  labelMedium: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal),
  // ! (Not USED)
  labelSmall: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.w100),
);

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      textTheme: _textTheme,
      scaffoldBackgroundColor: _colorScheme.surface,

      // Colored button.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _colorScheme.outline,
          side: BorderSide(color: _colorScheme.outline, width: 2),
          foregroundColor: _colorScheme.onPrimary,
          iconColor: _colorScheme.onPrimary,
          textStyle: _textTheme.labelLarge,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
        ),
      ),
      // Outllinded Button.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(foregroundColor: _colorScheme.primary, side: BorderSide(color: _colorScheme.primary)),
      ),
      // Link Button.
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: _colorScheme.primary)),
      // ! Floating Button (Not Used).
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: _colorScheme.primary),

      // All inputs in apps.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _colorScheme.surfaceContainerHighest,

        labelStyle: _textTheme.labelLarge?.copyWith(color: _colorScheme.onSurfaceVariant),
        floatingLabelStyle: _textTheme.labelLarge?.copyWith(color: _colorScheme.primary),

        border: OutlineInputBorder(
          gapPadding: 4.0,
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _colorScheme.outline, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          gapPadding: 4.0,
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _colorScheme.outlineVariant, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          gapPadding: 4.0,
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _colorScheme.primary, width: 1),
        ),
      ),
    );
  }
}
