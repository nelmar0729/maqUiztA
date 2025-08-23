import '/features/profile/data/repositories/repository.dart';
import '/shared/response.dart';

class VerifyEmail {
  final Repository repository;

  VerifyEmail(this.repository);

  Future<ResponseResult> call({
    required String email,
    required String token,
  }) async {
    // Repository handles the upload & update
    return repository.verifyEmail(email, token);
  }
}
