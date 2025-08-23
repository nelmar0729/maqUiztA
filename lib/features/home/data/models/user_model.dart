// Import the User entity from the domain layer
import '../../domain/entities/user.dart';

/// UserModel is a data model used for reading/writing user data
/// from or to the backend (API or database).
///
/// It extends the User class, which means it also contains all
/// the main fields used in your app logic/UI.
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
  }) : super(
         id: userId.toString(), // ⚡ still required for User
       );

  /// Factory method for converting JSON data (from API) into a UserModel object.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: int.parse(json['user_id'].toString()),
      email: json['email'], // <--- Pass as param
      studentId: json['studentId'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      middleInitial: json['middle_initial'],
      suffix: json['suffix'],
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
    );
  }

  /// Converts a UserModel object back into JSON (for sending to backend).
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email, // inherited from User
      'studentId': studentId,
      'first_name': firstName,
      'last_name': lastName,
      'middle_initial': middleInitial,
      'suffix': suffix,
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
    };
  }
}
