// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:auto_route/auto_route.dart';
import 'package:audioplayers/audioplayers.dart'; // ✅ add this
import '/shared/app_colors.dart'; 
import '/core/routes/app_router.dart';

class QuizResultScreen extends StatefulWidget {
  final int quizId;
  final String quizTitle;
  final int score;
  final int totalQuestions;
  final Color quizColor;
  final ConfettiController confettiController;

  const QuizResultScreen({
    super.key,
    required this.quizId,
    required this.quizTitle,
    required this.score,
    required this.totalQuestions,
    required this.quizColor,
    required this.confettiController,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playResultSound(); // 🔊 play sound on result load
  }

  Future<void> _playResultSound() async {
    double percent =
        widget.totalQuestions > 0 ? widget.score / widget.totalQuestions : 0.0;

    if (percent == 1.0) {
      await _audioPlayer.play(AssetSource("sounds/perfect.mp3"));
    } else if (percent >= 0.7) {
      await _audioPlayer.play(AssetSource("sounds/pass.mp3"));
    } else if (percent >= 0.4) {
      await _audioPlayer.play(AssetSource("sounds/celebrate.wav"));
    } else {
      await _audioPlayer.play(AssetSource("sounds/failed.wav"));
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double percent =
        widget.totalQuestions > 0 ? widget.score / widget.totalQuestions : 0.0;

    String message;
    String emoji;
    if (percent == 1.0) {
      message = "Outstanding! A perfect score – excellent work.";
      emoji = "🏆";
    } else if (percent >= 0.7) {
      message = "Well done! You have a strong grasp of the material.";
      emoji = "✅";
    } else if (percent >= 0.4) {
      message =
          "Fair effort. Review the material to strengthen your understanding.";
      emoji = "📘";
    } else {
      message = "Needs improvement. Consider revisiting the lessons.";
      emoji = "⚠️";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.quizTitle,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        foregroundColor: widget.quizColor.computeLuminance() < 0.4
            ? Colors.white
            : Colors.black87,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🎉 Emoji Animation
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) => Transform.scale(
                    scale: scale,
                    child: Text(emoji, style: const TextStyle(fontSize: 90)),
                  ),
                ),
                const SizedBox(height: 20),

                // 🎊 Confetti
                ConfettiWidget(
                  confettiController: widget.confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: [
                    widget.quizColor,
                    Colors.amber,
                    Colors.pink,
                    Colors.green,
                    Colors.blue,
                  ],
                  numberOfParticles: 35,
                  emissionFrequency: 0.1,
                  gravity: 0.3,
                ),
                const SizedBox(height: 20),

                // ✨ "Quiz Finished!"
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [widget.quizColor, Colors.purple, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    "Quiz Finished!",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🌟 Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),

                // 🔢 Score Counter
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: widget.score),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) => Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 36,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: percent >= 0.5
                          ? widget.quizColor.withOpacity(0.15)
                          : AppColors.error.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: widget.quizColor.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Your Score",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: widget.quizColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "$value / ${widget.totalQuestions}",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            color: percent >= 0.5
                                ? widget.quizColor
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 🏆 Leaderboard Button
                ElevatedButton.icon(
                  onPressed: () {
                    context.router.push(
                      LeaderboardRoute(quizId: widget.quizId),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.quizColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.leaderboard, color: Colors.white),
                  label: const Text(
                    "View Leaderboards",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🏠 Home Button
                ElevatedButton.icon(
                  onPressed: () {
                    context.router.replace(QuizterNavRoute());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 37, 37, 37),
                  ),
                  label: const Text(
                    "Go Home",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
