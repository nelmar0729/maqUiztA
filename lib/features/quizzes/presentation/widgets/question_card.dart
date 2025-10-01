// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '/shared/app_colors.dart';
import '/features/quizzes/data/models/question_model.dart';
import '/features/quizzes/data/models/choices_model.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final String? selectedAnswer;
  final Function(ChoiceModel) onChoiceTap;

  const QuestionCard({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.onChoiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Question text (handles long text properly)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                question.questionText,
                textAlign: TextAlign.left,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                  height: 1.4, // better readability
                ),
              ),
            ),

            // ✅ Choices
            ...question.choices.map((choiceModel) {
              final choice = choiceModel.choiceText;
              final isSelected = selectedAnswer == choice;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Material(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.12)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => onChoiceTap(choiceModel),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Selection indicator (radio style)
                          Container(
                            width: 22,
                            height: 22,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 14),

                          // ✅ Choice text (wraps long answers too)
                          Expanded(
                            child: Text(
                              choice,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.5,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.black87,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
