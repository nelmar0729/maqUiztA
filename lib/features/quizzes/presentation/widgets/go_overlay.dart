// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '/shared/app_colors.dart';

class GoOverlay extends StatefulWidget {
  const GoOverlay({super.key});

  @override
  State<GoOverlay> createState() => _GoOverlayState();
}

class _GoOverlayState extends State<GoOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      alignment: Alignment.center,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.primaryGradient.createShader(bounds),
            child: const Text(
              "GO!",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                fontSize: 100,
                letterSpacing: 8,
                color: Colors.white, // base (shader overrides this)
                shadows: [
                  Shadow(
                    blurRadius: 30,
                    color: Colors.black54,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
