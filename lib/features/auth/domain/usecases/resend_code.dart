import '/features/auth/data/repositories/auth_repository.dart';
import '/shared/response.dart';

class ResendCode {
  AuthRepository authRepository;

  ResendCode(this.authRepository);
  Future<ResponseResult> call(String email) {
    return authRepository.resendCode(email);
  }
}
