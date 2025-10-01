/// SubjectModel represents a subject row (for student joining/faculty listing)
class SubjectModel {
  final String facultySubjectId;
  final String subjectCode;
  final String subjectName;
  final String instructor;

  SubjectModel({
    required this.facultySubjectId,
    required this.subjectCode,
    required this.subjectName,
    required this.instructor,
  });

  /// Factory method to create a SubjectModel from a JSON map
  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      facultySubjectId: json['faculty_subject_id']?.toString() ?? '',
      subjectCode: json['subject_code'] ?? '',
      subjectName: json['subject_name'] ?? '',
      instructor: json['instructor'] ?? '',
    );
  }

  /// Converts the SubjectModel to a JSON map (for backend/API)
  Map<String, dynamic> toJson() {
    return {
      'faculty_subject_id': facultySubjectId,
      'subject_code': subjectCode,
      'subject_name': subjectName,
      'instructor': instructor,
    };
  }
}
