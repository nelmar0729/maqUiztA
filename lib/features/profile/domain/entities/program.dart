// domain/entities/program.dart

class Program {
  final String
  id; // Use String for id to be consistent with other entities, or change to int if you prefer
  final String code;
  final String name;
  final String? createdAt;
  final String? updatedAt;
  final bool isDeleted;
  final String? deletedAt;
  final String? restoredAt;

  const Program({
    required this.id,
    required this.code,
    required this.name,
    this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
    this.deletedAt,
    this.restoredAt,
  });
}
