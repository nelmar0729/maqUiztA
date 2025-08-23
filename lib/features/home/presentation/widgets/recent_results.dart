import 'package:flutter/material.dart';
import '/shared/text_styles.dart';
import '/features/home/data/models/recent_quiz_model.dart';

class RecentResults extends StatelessWidget {
  final List<RecentQuizModel> quizzes;

  const RecentResults({super.key, required this.quizzes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Recent Results", style: AppTextStyles.titleLarge),
            Icon(Icons.insights_outlined, color: Color(0xFF57A5FF)),
          ],
        ),
        const SizedBox(height: 10),
        ...quizzes
            .take(3)
            .map(
              (quiz) => RecentResultItem(
                title: quiz.title,
                score: quiz.score,
                total: quiz.totalItems,
                date: quiz.lastTaken ?? '', // fallback to empty if null
              ),
            ),
        const SizedBox(height: 22),
      ],
    );
  }
}

class RecentResultItem extends StatelessWidget {
  final String title;
  final int score;
  final int total;
  final String date;

  const RecentResultItem({
    super.key,
    required this.title,
    required this.score,
    required this.total,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = total > 0 ? score / total : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              value: percent,
              strokeWidth: 5,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                percent == 1 ? Colors.green : const Color(0xFF00C6FB),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLarge),
                Text(
                  'Score: $score / $total  •  $date',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          Icon(
            percent == 1 ? Icons.emoji_events : Icons.check_circle,
            color: percent == 1 ? Colors.amber : Colors.green,
            size: 26,
          ),
        ],
      ),
    );
  }
}

