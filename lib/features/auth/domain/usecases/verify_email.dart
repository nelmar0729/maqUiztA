import '/features/auth/data/repositories/auth_repository.dart';
import '/shared/response.dart';

class VerifyEmail {
  AuthRepository authRepository;

  VerifyEmail(this.authRepository);
  Future<ResponseResult> call(String email,String token) {
    return authRepository.verifyEmail(email,token);
  }
}
