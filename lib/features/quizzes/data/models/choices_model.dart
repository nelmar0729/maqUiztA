class ChoiceModel {
  final int choiceId;
  final int questionId;
  final String choiceText;
  final int isCorrect;
  final String createdAt;
  final String updatedAt;
  final int isDeleted;
  final String? restoredAt;

  ChoiceModel({
    required this.choiceId,
    required this.questionId,
    required this.choiceText,
    required this.isCorrect,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    this.restoredAt,
  });

  factory ChoiceModel.fromJson(Map<String, dynamic> json) {
    return ChoiceModel(
      choiceId: json['choice_id'],
      questionId: json['question_id'],
      choiceText: json['choice_text'],
      isCorrect: json['is_correct'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isDeleted: json['is_deleted'],
      restoredAt: json['restored_at'],
    );
  }
}
