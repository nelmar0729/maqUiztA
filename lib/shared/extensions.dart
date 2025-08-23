// lib/shared/extensions.dart

import 'package:flutter/material.dart';

/// Extensions
///
/// Collection of handy Dart extension methods for built-in types.
/// Use these to make your code shorter, cleaner, and more readable.
///
/// Example usage at the bottom of each extension.

/// String extensions
extension StringExtensions on String {
  /// Capitalizes the first letter of a string.
  /// Example: 'hello'.capitalize()  // 'Hello'
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Returns true if the string is a valid email address.
  /// Example: 'test@email.com'.isValidEmail  // true
  bool get isValidEmail {
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return regex.hasMatch(this);
  }

  /// Returns true if the string is null, empty, or just whitespace.
  /// Example: ''.isNullOrBlank        // true
  /// Example: '   '.isNullOrBlank     // true
  /// Example: 'hi'.isNullOrBlank      // false
  bool get isNullOrBlank {
    return trim().isEmpty;
  }
}
// Usage example:
//   'hello world'.capitalize();   // 'Hello world'
//   '   '.isNullOrBlank;          // true
//   'mail@mail.com'.isValidEmail; // true

/// Int extensions
extension IntExtensions on int {
  /// Formats the number with commas for thousands (e.g. 1,234).
  /// Example: 12345.formatted   // '12,345'
  String get formatted {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
// Usage example:
//   123456.formatted;           // '123,456'

/// BuildContext extensions (for widgets)
extension ContextExtensions on BuildContext {
  /// Hides keyboard from anywhere with: context.hideKeyboard();
  /// Example:
  ///   context.hideKeyboard();
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Shows a snackbar from anywhere.
  /// Example:
  ///   context.showSnackBar('Saved!');
  ///   context.showSnackBar('Warning!', color: Colors.orange);
  void showSnackBar(String message, {Color? color}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? Colors.black87,
      ),
    );
  }
}
// Usage example:
//   context.hideKeyboard();
//   context.showSnackBar('This is a message.');

/// DateTime extensions
extension DateTimeExtensions on DateTime {
  /// Returns a formatted date string, e.g. '9/7/2025'
  /// Example: DateTime.now().formatted    // '9/7/2025'
  String get formatted {
    return "$day/$month/$year";
    // For more advanced formatting, use the intl package!
  }
}

// Usage example:
//   DateTime.now().formatted;   // '9/7/2025'
