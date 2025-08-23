class QuizModel {
  final int quizId;
  final String title;
  final String description;
  final int subjectId;
  final String? subjectCode;
  final String? subjectName;
  final String? difficulty;
  final int? createdBy;
  final String? status;
  final int? timerPerQuestion;
  final DateTime? scheduledAt;
  final int? color;

  // Extra fields
  final int? totalQuestions; // <-- ADD THIS LINE

  final int? studentFacultySubjectId;
  final int? studentId;
  final int? facultySubjectId;
  final int? facultyId;
  final String? accessToken;
  final DateTime? joinedAt;
  final int? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final DateTime? restoredAt;

  QuizModel({
    required this.quizId,
    required this.title,
    required this.description,
    required this.subjectId,
    this.subjectCode,
    this.subjectName,
    this.difficulty,
    this.createdBy,
    this.status,
    this.timerPerQuestion,
    this.scheduledAt,
    this.color,
    this.totalQuestions, // <-- ADD THIS LINE
    this.studentFacultySubjectId,
    this.studentId,
    this.facultySubjectId,
    this.facultyId,
    this.accessToken,
    this.joinedAt,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.restoredAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      quizId: json['quiz_id'] as int,
      title: json['title'] as String,
      description: json['description'] ?? '',
      subjectId: json['subject_id'] as int,
      subjectCode: json['subject_code'],
      subjectName: json['subject_name'],
      difficulty: json['difficulty'],
      createdBy: json['created_by'],
      status: json['status'],
      timerPerQuestion: json['timer_per_question'],
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.tryParse(json['scheduled_at'])
          : null,
      color: json['color'],
      totalQuestions: json['total_questions'], // <-- ADD THIS LINE
      studentFacultySubjectId: json['student_faculty_subject_id'],
      studentId: json['student_id'],
      facultySubjectId: json['faculty_subject_id'],
      facultyId: json['faculty_id'],
      accessToken: json['access_token'],
      joinedAt: json['joined_at'] != null
          ? DateTime.tryParse(json['joined_at'])
          : null,
      isDeleted: json['is_deleted'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      restoredAt: json['restored_at'] != null
          ? DateTime.tryParse(json['restored_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz_id': quizId,
      'title': title,
      'description': description,
      'subject_id': subjectId,
      'subject_code': subjectCode,
      'subject_name': subjectName,
      'difficulty': difficulty,
      'created_by': createdBy,
      'status': status,
      'timer_per_question': timerPerQuestion,
      'scheduled_at': scheduledAt?.toIso8601String(),
      'color': color,
      'total_questions': totalQuestions, // <-- ADD THIS LINE
      'student_faculty_subject_id': studentFacultySubjectId,
      'student_id': studentId,
      'faculty_subject_id': facultySubjectId,
      'faculty_id': facultyId,
      'access_token': accessToken,
      'joined_at': joinedAt?.toIso8601String(),
      'is_deleted': isDeleted,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'restored_at': restoredAt?.toIso8601String(),
    };
  }
}
