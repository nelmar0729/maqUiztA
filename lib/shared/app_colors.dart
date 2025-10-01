// lib/shared/app_colors.dart

import 'package:flutter/material.dart';

/// AppColors
///
/// Central place for all app color definitions.
/// Change colors here to update your entire app theme.

class AppColors {
  // ---- Brand Colors ----

  /// Primary brand color (Fresh Green)
  static const Color primary = Color(0xFF43A047); // Leafy green

  /// Secondary brand color (Lime / Fresh Accent)
  static const Color secondary = Color(0xFFCDDC39); // Lime green

  /// Accent / Supporting brand color (Turquoise / Teal)
  static const Color accent = Color(0xFF26A69A);

  /// Neutral / Background white
  static const Color neutral = Color(0xFFF9F9F9);

  // ---- Backgrounds & Surfaces ----
  static const Color background = neutral;
  static const Color surface = Colors.white;

  // ---- Text Colors ----
  static const Color textPrimary = Color(0xFF1B1B1B);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Colors.black87;

  // ---- States ----
  static const Color success = Color(0xFF2E7D32); // Deep green
  static const Color warning = Color(0xFFFFA000); // Amber
  static const Color error = Color(0xFFE53935); // Strong red

  // ---- Disabled & Border ----
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color border = Color(0xFFDDDDDD);

  // ---- Shadows ----
  static const Color shadow = Color(0x33000000); // 20% opacity black

  // ---- Gradients (optional) ----
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient accentGradient = LinearGradient(
    colors: [secondary, accent],
    begin: Alignment.topCenter,
    end: Alignment.bottomRight,
  );
}
