// lib/shared/constants.dart

// ignore: dangling_library_doc_comments
/// AppConstants
///
/// Place to keep static values used across your app.
/// Examples: app name, API endpoints, default values, durations, etc.
///
/// Usage Example:
///   print(AppConstants.appName);
///   Duration(seconds: AppConstants.animationDuration);
import 'dart:io';

class AppConstants {
  // --- App Info ---
  static const String appName = "maqUiztA";
  static const String appVersion = "1.0.1";
  static const String developer =
      "Nelmar A. Raymundo & Rhea Elizah A. Alfonso"; // Increment with each release
  // App ID (used in AndroidManifest.xml only)
  static const String appId = "ca-app-pub-1145544271012472~1220650426";

  // Test Ad Unit IDs
  static const String bannerId = "ca-app-pub-1145544271012472/6437882734";
  static const String interstitialId = "ca-app-pub-1145544271012472/7564365796";
  static const String rewardedId = "ca-app-pub-1145544271012472/7809301000";
  // --- API Endpoints ---
  static const String baseUrl = "https://maquizta.fun";
  static const String authEndpoint = "$baseUrl/public/App_auth";
  static const String subjectEndpoint = "$baseUrl/public/App_subject";
  static const String quizzesEndpoint = "$baseUrl/public/App_quizzes";
  static const String profileEndpoint = "$baseUrl/public/App_profile";
  static const String homeEndpoint = "$baseUrl/public/App_home";

  /* Local */
  // static const String baseUrl = "http://192.168.123.40";
  // static const String authEndpoint = "$baseUrl/maqUiztA/public/App_auth";
  // static const String subjectEndpoint = "$baseUrl/maqUiztA/public/App_subject";
  // static const String quizzesEndpoint = "$baseUrl/maqUiztA/public/App_quizzes";
  // static const String profileEndpoint = "$baseUrl/maqUiztA/public/App_profile";
  // static const String homeEndpoint = "$baseUrl/maqUiztA/public/App_home";

  static Map<String, String> get defaultHeaders => {
    "Content-Type": "application/x-www-form-urlencoded",
    "Accept": "application/json",
    "User-Agent": Platform.isIOS ? "MyApp/1.0 (iOS)" : "MyApp/1.0 (Android)",
  };
  static const List<String> years = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  static const List<String> sections = ['A', 'B', 'C', 'D'];

  // --- UI/UX ---
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double appBarHeight = 56.0;

  // --- Animation ---
  static const int animationDuration = 300; // milliseconds

  // --- Timeouts ---
  static const int apiTimeout = 10000; // milliseconds

  // --- Keys (for storage, preferences, etc.) ---
  static const String tokenKey = "auth_token";
  static const String userPrefsKey = "user_prefs";

  // --- Error Messages ---
  static const String errorNetwork = "Network error. Please try again.";
  static const String errorGeneric = "Something went wrong. Try again later.";

  // You can add more constants here as your app grows!
}
