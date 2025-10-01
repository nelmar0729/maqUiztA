import 'package:flutter/material.dart'; // For FormFieldValidator
import 'package:intl/intl.dart'; // For date formatting
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:timezone/timezone.dart' as tz;


/// AppHelpers
///
/// Common helper functions and utilities for your app.
/// Use these static methods anywhere you need a quick utility.

class AppHelpers {
  /// Formats a [DateTime] as a string in yyyy-MM-dd format.
  /// usage: AppHelpers.formatDate(DateTime.now()); // -> '2025-07-09'
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Formats a [DateTime] to a friendly string, e.g., "Jul 8, 2025".
  /// usage: AppHelpers.formatFriendlyDate(DateTime.now()); // -> 'Jul 9, 2025'
  static String formatFriendlyDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  /// Returns true if [email] is a valid email address.
  /// usage: AppHelpers.isValidEmail('me@email.com'); // -> true or false
  static bool isValidEmail(String? email) {
    if (email == null) return false;
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return regex.hasMatch(email.trim());
  }

  /// Returns a validator function for the email field with a custom message.
  /// usage: validator: AppHelpers.email('Please enter a valid email')
  static FormFieldValidator<String> email(String msg) =>
      (value) => isValidEmail(value) ? null : msg;

  /// Checks if a string is null, empty, or just whitespace.
  /// usage: AppHelpers.isNullOrEmpty(str); // -> true or false
  static bool isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Capitalizes the first letter of a string.
  /// usage: AppHelpers.capitalize('hello'); // -> 'Hello'
  static String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  /// Returns a safe int from a string, or 0 if conversion fails.
  /// usage: AppHelpers.parseInt('123'); // -> 123
  /// usage: AppHelpers.parseInt('abc'); // -> 0
  static int parseInt(String? value) {
    if (value == null) return 0;
    return int.tryParse(value) ?? 0;
  }

  /// Returns a validator function that checks for required field and shows [msg].
  /// usage: validator: AppHelpers.required('Please enter your Student ID')
  static FormFieldValidator<String> required(String msg) =>
      (value) => isNullOrEmpty(value) ? msg : null;

  /// Checks if a value matches the student ID pattern: 0000-0000-A (e.g., 1234-5678-X)
  /// usage: AppHelpers.isValidStudentId('1234-5678-X'); // -> true or false
  static bool isValidStudentId(String? value) {
    if (value == null) return false;
    final regex = RegExp(r'^\d{4}-\d{4}-[A-Z]$');
    return regex.hasMatch(value.trim());
  }

  /// Returns a validator function for the student ID field with custom message.
  /// usage: validator: AppHelpers.studentId('Please enter a valid student ID')
  static FormFieldValidator<String> studentId(String msg) =>
      (value) => isValidStudentId(value) ? null : msg;
  // You can add more helpers here (number formatting, phone validation, etc.)

  /// Combines multiple validators. Returns the first error message found, or null if all pass.
  /// Usage: validator: AppHelpers.multi([AppHelpers.required('...'), AppHelpers.studentId('...')])
  static FormFieldValidator<String> multi(
    List<FormFieldValidator<String>> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result; // Return the first error message found
        }
      }
      return null; // All validations passed
    };
  }

  static Timer startCountdown({
    required int totalSeconds,
    required void Function(int remaining) onTick,
    required VoidCallback onComplete,
    void Function()? onBeep,
  }) {
    int secondsLeft = totalSeconds;

    return Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 1) {
        secondsLeft--;
        onTick(secondsLeft);

        if (secondsLeft <= 10 && onBeep != null) {
          onBeep();
        }
      } else {
        timer.cancel();
        onComplete();
      }
    });
  }

  /// Formats [seconds] into a friendly string like "1 year 1 month 1 day 1 min 10 sec".
  static String formatDurationFriendly(int seconds) {
    Duration duration = Duration(seconds: seconds);
    int years = duration.inDays ~/ 365;
    int months = (duration.inDays % 365) ~/ 30;
    int days = (duration.inDays % 365) % 30;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int secs = duration.inSeconds % 60;

    List<String> parts = [];
    if (years > 0) parts.add('$years year${years > 1 ? 's' : ''}');
    if (months > 0) parts.add('$months month${months > 1 ? 's' : ''}');
    if (days > 0) parts.add('$days day${days > 1 ? 's' : ''}');
    if (hours > 0) parts.add('$hours hr${hours > 1 ? 's' : ''}');
    if (minutes > 0) parts.add('$minutes min${minutes > 1 ? 's' : ''}');
    if (secs > 0) parts.add('$secs sec${secs > 1 ? 's' : ''}');
    if (parts.isEmpty) parts.add('0 sec');

    return parts.join(' ');
  }

  /// Plays a beep sound from assets.
  ///
  /// Usage:
  ///   await AppHelpers.playBeep(audioPlayer: yourAudioPlayerInstance);
  ///
  /// - [audioPlayer]: Optional. Pass an existing AudioPlayer for resource management.
  /// - [volume]: Optional. Adjusts the volume, defaults to 1.0.
  static Future<void> playBeep({
    AudioPlayer? audioPlayer,
    double volume = 1.0,
  }) async {
    final player = audioPlayer ?? AudioPlayer();
    await player.play(AssetSource('sounds/count1.mp3'), volume: volume);
  }

  /// Plays any custom sound from assets.
  ///
  /// Usage:
  ///   await AppHelpers.playSound('sounds/Go.mp3', audioPlayer: yourAudioPlayerInstance);
  ///
  /// - [assetPath]: The path to your asset file (e.g., 'sounds/Go.mp3').
  /// - [audioPlayer]: Optional. Pass an existing AudioPlayer for resource management.
  /// - [volume]: Optional. Adjusts the volume, defaults to 1.0.
  static Future<void> playSound(
    String assetPath, {
    AudioPlayer? audioPlayer,
    double volume = 1.0,
  }) async {
    final player = audioPlayer ?? AudioPlayer();
    await player.play(AssetSource(assetPath), volume: volume);
  }

  /// Converts [date] to the user's local time zone.
  static DateTime toUserLocal(DateTime date) => date.toLocal();

  /// Converts [date] to a specific time zone using the timezone package.
  /// Example: AppHelpers.toTimeZone(date, 'Asia/Manila');
  static tz.TZDateTime toTimeZone(DateTime date, String timeZone) {
    final location = tz.getLocation(timeZone);
    return tz.TZDateTime.from(date, location);
  }

  /// Formats [date] for display in the user's local time zone.
  static String formatLocal(
    DateTime date, {
    String pattern = 'yyyy-MM-dd HH:mm',
  }) {
    return DateFormat(pattern).format(date.toLocal());
  }

  /// Formats [date] for display in any target time zone (e.g., PH).
  /// Example: AppHelpers.formatInTimeZone(date, 'Asia/Manila')
  static String formatInTimeZone(
    DateTime date,
    String timeZone, {
    String pattern = 'yyyy-MM-dd HH:mm',
  }) {
    final location = tz.getLocation(timeZone);
    final tzDate = tz.TZDateTime.from(date, location);
    return DateFormat(pattern).format(tzDate);
  }
}
