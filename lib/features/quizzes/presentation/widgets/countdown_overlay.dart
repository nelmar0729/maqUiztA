// ignore_for_file: deprecated_member_use

import 'dart:ui'; // <-- Import for ImageFilter
import 'package:flutter/material.dart';
import '/shared/helpers.dart';

class CountdownOverlay extends StatelessWidget {
  final int count;
  const CountdownOverlay({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final bool isFriendly = count > 60;
    final String display = isFriendly
        ? AppHelpers.formatDurationFriendly(count)
        : (count < 10 ? count.toString().padLeft(2, '0') : count.toString());

    return Positioned.fill(
      child: Stack(
        children: [
          // This covers everything with a blur + semi-transparent overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: Colors.black.withOpacity(0.55),
            ),
          ),
          // Countdown text
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Text(
                display,
                key: ValueKey(display),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: isFriendly ? 30 : 70,
                  letterSpacing: isFriendly ? 1.5 : 0,
                  shadows: const [
                    Shadow(
                      blurRadius: 16,
                      color: Colors.black54,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
