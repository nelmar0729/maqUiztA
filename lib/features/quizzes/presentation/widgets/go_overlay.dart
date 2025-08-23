// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class GoOverlay extends StatelessWidget {
  const GoOverlay({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      alignment: Alignment.center,
      child: const Text(
        "Go!",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 90,
          letterSpacing: 8,
          shadows: [
            Shadow(blurRadius: 24, color: Colors.black54, offset: Offset(0, 6)),
          ],
        ),
      ),
    );
  }
}
