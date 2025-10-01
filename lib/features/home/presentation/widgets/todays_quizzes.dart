// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '/shared/text_styles.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';
import '/core/routes/app_router.dart';

class TodaysQuizzes extends StatelessWidget {
  final List<QuizModel> quizzes;

  const TodaysQuizzes({super.key, required this.quizzes});

  @override
  Widget build(BuildContext context) {
    if (quizzes.isEmpty) {
      return const Text(
        "No quizzes scheduled for today.",
        style: AppTextStyles.bodyLarge,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Today's Quizzes", style: AppTextStyles.titleLarge)],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120, // 🔹 more height so title + code + status fit comfortably
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [for (final quiz in quizzes) QuizCard(quiz: quiz)],
          ),
        ),
      ],
    );
  }
}

class QuizCard extends StatelessWidget {
  final QuizModel quiz;
  const QuizCard({super.key, required this.quiz});

  /// Returns a text color (black/white) based on brightness of [quiz.color]
  Color getDynamicTitleColor(int? colorValue) {
    if (colorValue == null) return Colors.black;
    final bgColor = Color(colorValue);
    return bgColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  /// Returns a faded color for the card background
  Color getFadedBgColor(int? colorValue) {
    if (colorValue == null) return Colors.white;
    // Use withOpacity for fade effect (e.g., 18%)
    return Color(colorValue).withOpacity(0.18);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final scheduledAt = quiz.scheduledAt;
    final int totalQuestions = quiz.totalQuestions ?? 1;
    final int timerPerQuestion = quiz.timerPerQuestion ?? 15;
    final int totalDurationSeconds = timerPerQuestion * totalQuestions;

    if (scheduledAt == null) {
      return Container(
        width: 170,
        margin: const EdgeInsets.only(right: 14),
        child: const Center(child: Text("Invalid schedule")),
      );
    }

    final start = scheduledAt;
    final end = start.add(Duration(seconds: totalDurationSeconds));

    String statusText;
    IconData icon;
    Color iconColor;

    if (now.isBefore(start)) {
      // Not started yet
      statusText = DateFormat('h:mm a').format(start);
      icon = Icons.lock_outline;
      iconColor = Colors.grey;
    } else if (!now.isBefore(start) && now.isBefore(end)) {
      // Ongoing
      statusText = "Ongoing";
      icon = Icons.play_circle_fill;
      iconColor = Colors.blueAccent;
    } else {
      // Ended
      statusText = "Ended";
      icon = Icons.lock_outline;
      iconColor = Colors.red;
    }

    final titleColor = getDynamicTitleColor(quiz.color);
    final fadedBgColor = getFadedBgColor(quiz.color);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        context.router.push(StartQuizRoute(quiz: quiz));
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: fadedBgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Title + Subject Code stacked properly
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // ✅ avoids overflow
                children: [
                  Text(
                    quiz.title,
                    style: AppTextStyles.bodyLarge.copyWith(color: titleColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  const SizedBox(height: 4),
                  if (quiz.subjectCode != null &&
                      quiz.subjectCode!.isNotEmpty)
                    Text(
                      "Code: ${quiz.subjectCode}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: iconColor, size: 26),
                  Flexible(
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
