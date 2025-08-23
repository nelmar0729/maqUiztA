// Import this if you have a base Program entity, otherwise you can ignore this line.
// import '../../domain/entities/program.dart';

/// ProgramModel represents a row in the "program" table.
class ProgramModel /* extends Program */ {
  final int programId;
  final String programCode;
  final String programName;
  final String? createdAt;
  final String? updatedAt;
  final bool isDeleted;
  final String? deletedAt;
  final String? restoredAt;

  ProgramModel({
    required this.programId,
    required this.programCode,
    required this.programName,
    this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.restoredAt,
  });

  /// Converts JSON (Map) to a ProgramModel
  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      programId: int.parse(json['program_id'].toString()),
      programCode: json['program_code'],
      programName: json['program_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isDeleted: json['is_deleted'] == 1 || json['is_deleted'] == '1',
      deletedAt: json['deleted_at'],
      restoredAt: json['restored_at'],
    );
  }

  /// Converts ProgramModel back to JSON (for API/backend)
  Map<String, dynamic> toJson() {
    return {
      'program_id': programId,
      'program_code': programCode,
      'program_name': programName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_deleted': isDeleted ? 1 : 0,
      'deleted_at': deletedAt,
      'restored_at': restoredAt,
    };
  }
}
