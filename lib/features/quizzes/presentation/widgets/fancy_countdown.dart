import 'dart:async';
import 'package:flutter/material.dart';

class FancyCountdown extends StatefulWidget {
  final int totalTime; // in seconds
  const FancyCountdown({super.key, this.totalTime = 60});

  @override
  State<FancyCountdown> createState() => _FancyCountdownState();
}

class _FancyCountdownState extends State<FancyCountdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _timeLeft = 0;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.totalTime;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.totalTime),
    )..forward();

    // update every second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        timer.cancel();
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 250,
        width: 250,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular progress
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(250, 250),
                  painter: CountdownPainter(
                    progress: _controller.value,
                    color: Colors.blueAccent,
                  ),
                );
              },
            ),

            // Number in the middle
            Text(
              "$_timeLeft",
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CountdownPainter extends CustomPainter {
  final double progress;
  final Color color;

  CountdownPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint basePaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18;

    final Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // Draw base circle
    canvas.drawCircle(center, radius - 20, basePaint);

    // Draw progress arc (reverse so it counts down)
    final sweepAngle = 2 * 3.1416 * (1 - progress);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      -3.1416 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
