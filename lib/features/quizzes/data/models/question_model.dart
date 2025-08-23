import 'choices_model.dart';
class QuestionModel {
  final int questionId;
  final int quizId;
  final String questionText;
  final int questionOrder;
  final int points;
  final String createdAt;
  final String updatedAt;
  final int isDeleted;
  final String? restoredAt;
  final List<ChoiceModel> choices;

  QuestionModel({
    required this.questionId,
    required this.quizId,
    required this.questionText,
    required this.questionOrder,
    required this.points,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    this.restoredAt,
    required this.choices,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    var choicesList = (json['choices'] as List)
        .map((c) => ChoiceModel.fromJson(c))
        .toList();

    return QuestionModel(
      questionId: json['question_id'],
      quizId: json['quiz_id'],
      questionText: json['question_text'],
      questionOrder: json['question_order'],
      points: json['points'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isDeleted: json['is_deleted'],
      restoredAt: json['restored_at'],
      choices: choicesList,
    );
  }
}
