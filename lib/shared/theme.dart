// lib/shared/theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

/// AppTheme
///
/// Holds the ThemeData for the entire app.
/// Use this in your MaterialApp: theme: AppTheme.lightTheme,
class AppTheme {
  // Main app theme (light)
  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins', // Poppins is default for all text
    // Set primary swatch for default widget color
    primarySwatch: Colors.red, // fallback, real colors below
    // App-wide background color
    scaffoldBackgroundColor: AppColors.background,

    // Define the main color scheme using your AppColors
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary, // 🔴 Red
      onPrimary: AppColors.textOnPrimary,
      secondary: AppColors.secondary, // 🟡 Yellow
      onSecondary: AppColors.textOnSecondary,
      surface: AppColors.surface, // 🟦 White cards
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: AppColors.textOnPrimary,
    ),

    // App bar styling
    appBarTheme: AppBarTheme(
      color: AppColors.primary, // 🔴 Red AppBar
      iconTheme: IconThemeData(color: AppColors.textOnPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textOnPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      elevation: 2,
    ),

    // BottomNavigationBar styling
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary, // 🔴 Red for active
      unselectedItemColor: AppColors.textSecondary,
      showUnselectedLabels: true,
    ),

    // Button styles
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary, // 🔴 Red button
        foregroundColor: AppColors.textOnPrimary, // White text
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    // Text button styles
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondary, // 🟡 Yellow links
        textStyle: TextStyle(fontSize: 16),
      ),
    ),

    // Input field styling
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary), // 🔴 Red focus
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
      fillColor: AppColors.surface,
      filled: true,
      hintStyle: TextStyle(color: AppColors.textSecondary),
      labelStyle: TextStyle(color: AppColors.textPrimary),
    ),

    // Card styling
    cardColor: AppColors.surface,
    shadowColor: AppColors.shadow,

    // Icon styling
    iconTheme: IconThemeData(color: AppColors.accent), // 🔵 Blueish accent

    // Text theme
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),
      labelLarge: TextStyle(
        color: AppColors.textOnPrimary,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
    ),
  );
}
