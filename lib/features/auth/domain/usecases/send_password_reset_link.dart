import '/features/auth/data/repositories/auth_repository.dart';
import '/shared/response.dart';

class SendPasswordResetLink {
  AuthRepository authRepository;

  SendPasswordResetLink(this.authRepository);
  Future<ResponseResult> call(String email) {
    return authRepository.sendPasswordResetLink(email);
  }
}
