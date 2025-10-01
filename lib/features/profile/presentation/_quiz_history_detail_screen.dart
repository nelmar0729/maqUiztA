// ignore_for_file: deprecated_member_use
import 'package:no_screenshot/no_screenshot.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import '/features/profile/data/models/quiz_history_model.dart';
import '/shared/app_colors.dart';
import '/shared/util/unified_rewarded_ad.dart';

@RoutePage()
class QuizHistoryDetailScreen extends StatefulWidget {
  final QuizHistoryModel quiz;
  const QuizHistoryDetailScreen({super.key, required this.quiz});

  @override
  State<QuizHistoryDetailScreen> createState() =>
      _QuizHistoryDetailScreenState();
}

class _QuizHistoryDetailScreenState extends State<QuizHistoryDetailScreen> {
  final noScreenshot = NoScreenshot.instance;
  bool _rewardGranted = false;

  @override
  void initState() {
    super.initState();
    noScreenshot.screenshotOff();

    // ✅ Show rewarded ad, but always proceed
    UnifiedRewardedAd.show(
      onRewardEarned: (amount, type) {
        setState(() => _rewardGranted = true);
      },
      onComplete: () {
        if (mounted) setState(() => _rewardGranted = true);
      },
    );
  }

  @override
  void dispose() {
    noScreenshot.screenshotOn();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_rewardGranted) {
      // Friendly loading UI
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16),
              Text(
                "Unlocking your quiz history...",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final quiz = widget.quiz;
    final questions = quiz.questions;
    final userAnswers = quiz.userAnswers;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          quiz.title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // 📊 Score summary card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quiz Summary",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text("Date: ${quiz.date}",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.emoji_events,
                          size: 18, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text("Score: ${quiz.score} / ${quiz.total}",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 📋 Questions
          ...List.generate(questions.length, (i) {
            final q = questions[i];
            final userAnswer = userAnswers.length > i ? userAnswers[i] : null;

            final bool isUnanswered =
                userAnswer == null ||
                ((userAnswer.trim().isEmpty || userAnswer == 'null'));

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question text
                    Text(
                      "Q${i + 1}: ${q.question}",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: isUnanswered ? Colors.grey[700] : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Choices
                    ...List.generate(q.choices.length, (j) {
                      final choice = q.choices[j];
                      final bool isCorrect = choice == q.answer;
                      final bool isUser =
                          !isUnanswered && (choice == userAnswer);

                      Color? color;
                      Icon? icon;

                      if (isUser && isCorrect) {
                        color = Colors.green[100];
                        icon = const Icon(Icons.check_circle,
                            color: Colors.green, size: 22);
                      } else if (isUser && !isCorrect) {
                        color = Colors.red[100];
                        icon = const Icon(Icons.cancel,
                            color: Colors.red, size: 22);
                      } else if (isUnanswered && isCorrect) {
                        color = Colors.blue[50];
                        icon = const Icon(Icons.info_outline,
                            color: Colors.blue, size: 22);
                      } else if (!isUser && isCorrect) {
                        color = Colors.green[50];
                        icon = const Icon(Icons.check_circle_outline,
                            color: Colors.green, size: 22);
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: icon,
                          title: Text(
                            choice,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: isUser
                                  ? (isCorrect
                                      ? Colors.green[900]
                                      : Colors.red[900])
                                  : (isUnanswered && isCorrect
                                      ? Colors.blue[900]
                                      : isCorrect
                                          ? Colors.green[900]
                                          : Colors.black87),
                            ),
                          ),
                        ),
                      );
                    }),

                    // Unanswered note
                    if (isUnanswered)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Colors.red[700], size: 18),
                            const SizedBox(width: 6),
                            Text(
                              "You did not answer this question",
                              style: TextStyle(
                                color: Colors.red[700],
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
