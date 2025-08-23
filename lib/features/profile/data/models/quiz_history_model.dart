class QuizHistoryModel {
  final String title;
  final String date;
  final int score;
  final int total;
  final List<QuizQuestionModel> questions;
  final List<String> userAnswers;

  QuizHistoryModel({
    required this.title,
    required this.date,
    required this.score,
    required this.total,
    required this.questions,
    required this.userAnswers,
  });

  factory QuizHistoryModel.fromJson(Map<String, dynamic> json) {
    return QuizHistoryModel(
      title: json['title'],
      date: json['date'],
      score: json['score'] is int ? json['score'] : int.parse(json['score'].toString()),
      total: json['total'] is int ? json['total'] : int.parse(json['total'].toString()),
      questions: (json['questions'] as List<dynamic>)
          .map((q) => QuizQuestionModel.fromJson(q))
          .toList(),
      userAnswers: (json['userAnswers'] as List).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'date': date,
    'score': score,
    'total': total,
    'questions': questions.map((q) => q.toJson()).toList(),
    'userAnswers': userAnswers,
  };
}

class QuizQuestionModel {
  final String question;
  final List<String> choices;
  final String answer;

  QuizQuestionModel({
    required this.question,
    required this.choices,
    required this.answer,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      question: json['question'],
      choices: (json['choices'] as List).map((e) => e.toString()).toList(),
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'choices': choices,
    'answer': answer,
  };
}
