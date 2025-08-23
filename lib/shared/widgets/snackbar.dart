import 'package:flutter/material.dart';

/*
Usage
AppSnack.show(context, "Success!", SnackType.success);
AppSnack.show(context, "Something went wrong.", SnackType.error);
AppSnack.show(context, "Heads up!", SnackType.info);
AppSnack.show(context, "Check this!", SnackType.warning);

 */

enum SnackType { success, error, info, warning }

class AppSnack {
  static void show(
    BuildContext context,
    String message,
    SnackType type, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final color = switch (type) {
      SnackType.success => Colors.green,
      SnackType.error => Colors.red,
      SnackType.info => Colors.blueAccent,
      SnackType.warning => Colors.orange,
    };
    final icon = switch (type) {
      SnackType.success => Icons.check_circle,
      SnackType.error => Icons.error,
      SnackType.info => Icons.info,
      SnackType.warning => Icons.warning_amber_rounded,
    };
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
