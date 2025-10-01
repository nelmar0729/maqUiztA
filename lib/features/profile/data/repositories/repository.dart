import '../models/quiz_history_model.dart';
import '/shared/response.dart';
import '../models/user_model.dart';

/// This is the interface (contract) for your Repository.
/// It lists all the methods you want your authentication system to provide.
abstract class Repository {
  /// The login method takes an email and password,
  /// and returns a User object if successful.
  Future<ResponseResult> updateUserData(
    String firstname,
    String lastname,
    String studentId,
    String email,
    dynamic avatar, // <-- File type for image, nullable if not changed
    int programId,
    String yearLevel,
    String section,
    String userId,
  );

  Future<UserModel> getUserData(String userId);

  Future<ResponseResult> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
    String userId,
  );

  Future<ResponseResult> verifyEmail(String email, String token, String userId);
  Future<List<QuizHistoryModel>> getQuizHistory(String userId);
  // You can add more contracts like:
  // Future<User> register(...);
  // Future<User> getUserById(int userId);
}
