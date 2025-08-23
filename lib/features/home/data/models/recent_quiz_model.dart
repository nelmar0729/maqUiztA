/// RecentQuizModel represents the summary of a quiz recently taken by the user.
class RecentQuizModel {
  final int quizId;
  final String title;
  final String? difficulty;
  final int totalItems;
  final int score;
  final String? lastTaken;

  RecentQuizModel({
    required this.quizId,
    required this.title,
    this.difficulty,
    required this.totalItems,
    required this.score,
    this.lastTaken,
  });

  /// Converts JSON (Map) to a RecentQuizModel
  factory RecentQuizModel.fromJson(Map<String, dynamic> json) {
    return RecentQuizModel(
      quizId: int.parse(json['quiz_id'].toString()),
      title: json['title'],
      difficulty: json['difficulty'],
      totalItems: int.parse(json['total_items'].toString()),
      score: int.parse(json['score'].toString()),
      lastTaken: json['last_taken'],
    );
  }

  /// Converts RecentQuizModel back to JSON (for API/backend)
  Map<String, dynamic> toJson() {
    return {
      'quiz_id': quizId,
      'title': title,
      'difficulty': difficulty,
      'total_items': totalItems,
      'score': score,
      'last_taken': lastTaken,
    };
  }
}