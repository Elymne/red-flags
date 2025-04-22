import 'package:flutter/widgets.dart';

class AppColors {
  // Main App color theme. Title, menu, background highlight..
  static Color primary = Color(0xFF009468);
  static Color onPrimary = Color(0xFFFFFFFF);

  // Not used for now.
  static Color secondary = Color(0xFFFF895A);
  static Color onSecondary = Color(0xFFFFFFFF);

  // Error color.
  static Color error = Color(0xFFFA264D);
  static Color onError = Color(0xFFFFFFFF);

  // Basic background + text color.
  static Color surface = Color(0xFFE9E9E9);
  static Color surfaceHighest = Color(0xFFFFFFFF);
  static Color onSurface = Color(0xFF3A3A3A);

  // Effetc shadows and outline. May change.
  static Color outline = Color(0xFF555555);
  static Color shadow = Color(0xFF464646);

  // For text score color.
  static Color greenFlag = primary;
  static Color orangeFlag = secondary;
  static Color redFlag = error;
}
