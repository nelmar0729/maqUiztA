// CountdownOverlay.dart
// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart'; // 🎵 for background sound
import '/shared/app_colors.dart';
import '/shared/util/mobile_banner_ad.dart'; // ✅ import your banner widget

class CountdownOverlay extends StatefulWidget {
  final int count; // seconds remaining
  final int total; // total seconds for full circle

  const CountdownOverlay({
    super.key,
    required this.count,
    required this.total,
  });

  @override
  State<CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay>
    with TickerProviderStateMixin {
  AnimationController? _pulseController;
  late AnimationController _bgController;

  // 🎵 Background audio player
  late AudioPlayer _bgPlayer;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    // 🎵 Start background music (looped)
    _bgPlayer = AudioPlayer();
    _bgPlayer.setReleaseMode(ReleaseMode.loop);
    _bgPlayer.play(AssetSource('sounds/waiting.mp3'));
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    _bgController.dispose();

    // 🎵 Stop music
    _bgPlayer.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    if (seconds >= 60) {
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      return "$minutes:${secs.toString().padLeft(2, '0')}";
    } else {
      return seconds.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        widget.total > 0 ? widget.count / widget.total : 0;
    final String display = _formatTime(widget.count);

    // Transition: Primary green → Red
    final Color circleColor =
        Color.lerp(AppColors.primary, AppColors.error, 1 - progress)!;

    return SizedBox.expand(
      child: Stack(
        children: [
          // 🌈 Animated background
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(AppColors.primary, AppColors.accent,
                          _bgController.value)!,
                      Color.lerp(AppColors.secondary, AppColors.textSecondary,
                          _bgController.value)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),

          // Blur overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            // ignore: deprecated_member_use
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🏃 Running Student Animation
                SizedBox(
                  height: 120,
                  child: Lottie.asset(
                    'assets/animation/running.json',
                    repeat: true,
                  ),
                ),
                const SizedBox(height: 20),

                // Countdown circle
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_pulseController != null)
                      ScaleTransition(
                        scale: Tween(begin: 0.9, end: 1.1).animate(
                          CurvedAnimation(
                            parent: _pulseController!,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Container(
                          height: 190,
                          width: 190,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: circleColor.withOpacity(0.2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Circular timer
                    SizedBox(
                      height: 170,
                      width: 170,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 14,
                        backgroundColor: AppColors.disabled,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(circleColor),
                      ),
                    ),

                    // Countdown text
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Text(
                        display,
                        key: ValueKey(display),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 44,
                          color: AppColors.textOnPrimary,
                          shadows: [
                            Shadow(
                              blurRadius: 18,
                              color: Colors.black54,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ✅ Centralized banner widget
                const MobileBannerAd(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
