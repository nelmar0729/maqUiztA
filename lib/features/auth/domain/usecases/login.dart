import '/features/auth/data/repositories/auth_repository.dart';
import '/shared/response.dart';

/// This class handles the business logic for logging in a user.
/// It depends only on the AuthRepository contract, not on any implementation.
/// This keeps your logic testable and independent from the API or database.
class Login {
  final AuthRepository repository;

  // Constructor takes in the AuthRepository.
  Login(this.repository);

  /// Call this method to perform the login action.
  /// It takes the user's email and password, and returns a User on success.
  Future<ResponseResult> call(String email, String password) {
    return repository.login(email, password);
  }
}
