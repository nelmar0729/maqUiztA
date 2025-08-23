// Import your domain and data layer dependencies
import '/features/profile/data/repositories/repository.dart';
import '../datasources/data_source.dart';
import '/shared/response.dart';
import '../models/user_model.dart';
import 'dart:io';
import '../models/quiz_history_model.dart';

/// This class connects your business logic (domain) to your actual data source (API).
/// It implements the contract defined by Repository (in the domain layer).
///
/// When you call login(), it asks the remote data source to fetch the user from the backend,
/// and then returns a User object for the rest of your app to use.
class RepositoryImpl implements Repository {
  final DataSource remoteDataSource;

  // The repository needs to know which data source to use.
  RepositoryImpl(this.remoteDataSource);

  @override
  Future<ResponseResult> updateUserData(
    String firstname,
    String lastname,
    String studentId,
    String email,
    File? avatar, // <-- File type for image, nullable if not changed
    int programId,
    String yearLevel,
    String section,
    String userId,
  ) {
    return remoteDataSource.updateUserData(
      firstname,
      lastname,
      studentId,
      email,
      avatar, // Pass the file directly
      programId,
      yearLevel,
      section,
      userId,
    );
  }

  @override
  Future<UserModel> getUserData(String userId) {
    return remoteDataSource.getUserData(userId);
  }

  @override
  Future<ResponseResult> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
    String userId,
  ) {
    return remoteDataSource.changePassword(
      currentPassword,
      newPassword,
      confirmPassword,
      userId,
    );
  }

  @override
  Future<ResponseResult> verifyEmail(String email, String token) {
    return remoteDataSource.verifyEmail(email, token);
  }

  @override
  Future<List<QuizHistoryModel>> getQuizHistory(String userId) {
    return remoteDataSource.getQuizHistory(userId);
  }

  // You can add more methods here, like register(), getUserById(), etc.
}
