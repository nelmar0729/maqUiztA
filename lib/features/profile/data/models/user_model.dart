import '../../domain/entities/user.dart';

/// UserModel is a data model used for reading/writing user data
/// from or to the backend (API or database).
/// It extends the User class for shared fields used in app logic/UI.
class UserModel extends User {
  final int userId;
  final String? middleInitial;
  final String? suffix;
  final bool? isVerifiedEmail;
  final String? password;

  final String? sex;

  final int? programId;

  final String? lastActive;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final String? restoredAt;
  final String? deletedAt;
  final String? programCode;
  final String? programName;

  UserModel({
    required this.userId,
    // required from User
    required super.email, // ✅ required because User requires it
    super.firstName, // optional (if User allows nullable/has default)
    super.lastName,
    super.studentId,
    super.birthday,
    super.role,
    super.yearLevel,
    super.section,
    super.avatar,

    // extra fields
    this.middleInitial,
    this.suffix,
    this.isVerifiedEmail,
    this.password,
    this.sex,
    this.programId,
    this.lastActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.restoredAt,
    this.deletedAt,
    this.programCode,
    this.programName,
  }) : super(
         id: userId.toString(), // ⚡ still required for User
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: int.tryParse(json['user_id']?.toString() ?? '') ?? 0,
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      middleInitial: json['middle_initial'],
      suffix: json['suffix'],
      studentId: json['student_id'],
      isVerifiedEmail:
          json['is_verified_email'] == '1' || json['is_verified_email'] == 1,
      password: json['password'],
      birthday: json['birthday'],
      sex: json['sex'],
      role: json['role'],
      programId: json['program_id'] == null
          ? null
          : int.tryParse(json['program_id'].toString()),
      yearLevel: json['year_level'],
      section: json['section'],
      lastActive: json['last_active'],
      avatar: json['avatar'],
      isDeleted: json['is_deleted'] == 1 || json['is_deleted'] == '1',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      restoredAt: json['restored_at'],
      deletedAt: json['deleted_at'],
      programCode: json['program_code'],
      programName: json['program_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'middle_initial': middleInitial,
      'suffix': suffix,
      'student_id': studentId,
      'is_verified_email': isVerifiedEmail == true ? 1 : 0,
      'password': password,
      'birthday': birthday,
      'sex': sex,
      'role': role,
      'program_id': programId,
      'year_level': yearLevel,
      'section': section,
      'last_active': lastActive,
      'avatar': avatar,
      'is_deleted': isDeleted == true ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'restored_at': restoredAt,
      'deleted_at': deletedAt,
      'program_code': programCode,
      'program_name': programName,
    };
  }
}
