// lib/shared/app_colors.dart

import 'package:flutter/material.dart';

/// AppColors
///
/// Central place for all app color definitions.
/// Change colors here to update your entire app theme.

class AppColors {
  // ---- Brand Colors ----

  /// Primary brand color (Red)
  static const Color primary = Color(0xFFFF1744);

  /// Secondary brand color (Yellow)
  static const Color secondary = Color(0xFFFFD600);

  /// Accent / Supporting brand color (Blueish Grey)
  static const Color accent = Color(0xFF789ABC);

  /// Neutral / Background white
  static const Color neutral = Color(0xFFF9F9F9);

  // ---- Backgrounds & Surfaces ----
  static const Color background = neutral;
  static const Color surface = Colors.white;

  // ---- Text Colors ----
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Colors.black87;

  // ---- States ----
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);

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
