import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final _colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: Color(0xFFFF4164),

  primary: Color(0xFFFF4164),
  onPrimary: Color(0xFFFFFFFF),

  error: Color(0xFFFF0000),
  onError: Color(0xFFFFFFFF),

  surface: Color(0xFFE9E9E9),
  surfaceContainerHighest: Color(0xFFFFFFFF),
  onSurface: Color(0xFF3A3A3A),

  outline: Color(0xFF3A3A3A),
  shadow: Color(0x7E3A3A3A),
);

final _textTheme = TextTheme(
  // SplashScreen
  displayLarge: GoogleFonts.nunitoSans(color: _colorScheme.primary, fontSize: 42, fontWeight: FontWeight.w900),

  // Page screen title.
  headlineLarge: GoogleFonts.nunitoSans(color: _colorScheme.primary),
  // ! Section title. (Not USED).
  headlineMedium: GoogleFonts.nunitoSans(color: _colorScheme.onSurface),
  // Card Title.
  headlineSmall: GoogleFonts.nunitoSans(color: _colorScheme.onSurface),

  // ! (Not USED)
  titleLarge: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal),
  // ! (Not USED)
  titleMedium: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal),
  // ! (Not USED)
  titleSmall: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal),

  // Main content text.
  bodyLarge: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal),
  // Secondary content text.
  bodyMedium: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal),
  // ! (Not USED)
  bodySmall: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal),

  // Button Text.
  labelLarge: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal),
  // ! (Not USED)
  labelMedium: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.normal),
  // ! (Not USED)
  labelSmall: GoogleFonts.nunitoSans(color: _colorScheme.onSurface, fontWeight: FontWeight.w100),
);

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Color(0xFFE9E9E9),
      colorScheme: _colorScheme,
      textTheme: _textTheme,

      // Colored button.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _colorScheme.primary,
          foregroundColor: _colorScheme.onPrimary.withValues(alpha: 200),
          iconColor: _colorScheme.onPrimary,
          side: BorderSide(color: _colorScheme.primary),
          textStyle: _textTheme.labelLarge,
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
        fillColor: _colorScheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _colorScheme.outline)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: _colorScheme.onSurface),
      ),
    );
  }
}
