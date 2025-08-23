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

class AppConstants {
  // --- App Info ---
  static const String appName = "maqUiztA";
  static const String appVersion = "1.0.0";
  static const String developer = "Nelmar A. Raymundo & Rhea Elizah A. Alfonso"; // Increment with each release

  // --- API Endpoints ---
  static const String baseUrl = "https://maquizta.fun";
  static const String authEndpoint = "$baseUrl/public/App_auth";
  static const String subjectEndpoint = "$baseUrl/public/App_subject";
  static const String quizzesEndpoint = "$baseUrl/public/App_quizzes";
  static const String profileEndpoint = "$baseUrl/public/App_profile";
  static const String homeEndpoint = "$baseUrl/public/App_home";

  static const Map<String, String> defaultHeaders = {
    "Content-Type": "application/x-www-form-urlencoded",
    "Accept": "application/json", // ask server for JSON
    "User-Agent": "Mozilla/5.0 (compatible; FlutterApp/1.0)",
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
