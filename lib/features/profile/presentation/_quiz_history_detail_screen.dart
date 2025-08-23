
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/features/profile/data/models/quiz_history_model.dart'; // adjust import as needed
import '/shared/app_colors.dart';
@RoutePage()
class QuizHistoryDetailScreen extends StatelessWidget {
  final QuizHistoryModel quiz;
  const QuizHistoryDetailScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    final questions = quiz.questions;
    final userAnswers = quiz.userAnswers;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          quiz.title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
          backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            "Date: ${quiz.date}   |   Score: ${quiz.score} / ${quiz.total}",
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),
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
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Q${i + 1}: ${q.question}",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: isUnanswered ? Colors.grey[700] : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(q.choices.length, (j) {
                      final choice = q.choices[j];
                      final bool isCorrect = choice == q.answer;
                      final bool isUser =
                          !isUnanswered && (choice == userAnswer);

                      Color? color;
                      Icon? icon;

                      if (isUser && isCorrect) {
                        // User answered and correct
                        color = Colors.green[100];
                        icon = const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 22,
                        );
                      } else if (isUser && !isCorrect) {
                        // User answered but wrong
                        color = Colors.red[100];
                        icon = const Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 22,
                        );
                      } else if (isUnanswered && isCorrect) {
                        // Not answered, just show as correct answer
                        color = Colors.blue[50];
                        icon = const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 22,
                        );
                      } else if (!isUser && isCorrect) {
                        // User answered but not this choice, show correct answer
                        color = Colors.green[50];
                        icon = const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 22,
                        );
                      } else {
                        color = null;
                        icon = null;
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
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
                    if (isUnanswered)
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0, top: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.red[700],
                              size: 18,
                            ),
                            const SizedBox(width: 4),
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
