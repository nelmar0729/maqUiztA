// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '/shared/app_colors.dart';
import '/features/quizzes/data/models/question_model.dart'; // Import your model
import '/features/quizzes/data/models/choices_model.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final String? selectedAnswer;
  final Function(ChoiceModel) onChoiceTap; // <--- Accepts ChoiceModel now!

  const QuestionCard({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.onChoiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Text(
            question.questionText,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...question.choices.map((choiceModel) {
          final choice = choiceModel.choiceText;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            child: Material(
              color: selectedAnswer == choice
                  ? AppColors.primary.withOpacity(0.15)
                  : AppColors.accent,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: selectedAnswer == null
                    ? () =>
                          onChoiceTap(
                            choiceModel,
                          ) // <--- Pass the entire choiceModel
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: Text(
                    choice,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: selectedAnswer == choice
                          ? AppColors.primary
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
