import '/shared/response.dart';
import '../models/program_model.dart';

/// This is the interface (contract) for your AuthRepository.
/// It lists all the methods you want your authentication system to provide.
abstract class AuthRepository {
  /// The login method takes an email and password,
  /// and returns a User object if successful.
  Future<ResponseResult> login(String email, String password);
  Future<ResponseResult> register(
    String firstname,
    String lastname,
    String studentId,
    String email,
    String password,
  );

  Future<ResponseResult> verifyEmail(String email, String token);

  Future<ResponseResult> resendCode(String email);

  Future<ResponseResult> isEnrolled(String userId);

  Future<List<ProgramModel>> getPrograms();

  Future<ResponseResult> enrollStudent(
    String userId,
    int programId,
    String yearLevel,
    String section,
  );

  Future<ResponseResult> sendPasswordResetLink(String email);
  // You can add more contracts like:
  // Future<User> register(...);
  // Future<User> getUserById(int userId);
}
