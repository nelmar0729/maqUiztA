class ModuleModel {
  final int moduleId;
  final int facultySubjectId;
  final String title;
  final String description;
  final String fileType;
  final String filePath;
  final int uploadedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isDeleted;
  final String? deletedAt;
  final String? restoredAt;
  final String uploadedByName;

  ModuleModel({
    required this.moduleId,
    required this.facultySubjectId,
    required this.title,
    required this.description,
    required this.fileType,
    required this.filePath,
    required this.uploadedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    this.deletedAt,
    this.restoredAt,
    required this.uploadedByName,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      moduleId: json['module_id'] is int
          ? json['module_id']
          : int.parse(json['module_id'].toString()),
      facultySubjectId: json['faculty_subject_id'] is int
          ? json['faculty_subject_id']
          : int.parse(json['faculty_subject_id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      fileType: json['file_type'] ?? '',
      filePath: json['file_path'] ?? '',
      uploadedBy: json['uploaded_by'] is int
          ? json['uploaded_by']
          : int.parse(json['uploaded_by'].toString()),
      createdAt: DateTime.tryParse(json['created_at'].toString()) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'].toString()) ??
          DateTime.now(),
      isDeleted: json['is_deleted'] is int
          ? json['is_deleted']
          : int.parse(json['is_deleted'].toString()),
      deletedAt: json['deleted_at']?.toString(),
      restoredAt: json['restored_at']?.toString(),
      uploadedByName:
          "${json['first_name'] ?? ''} ${json['last_name'] ?? ''}".trim(),
    );
  }
}
