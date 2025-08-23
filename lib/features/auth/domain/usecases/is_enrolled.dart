import '/features/auth/data/repositories/auth_repository.dart';
import '/shared/response.dart';

class Isenrolled {
  AuthRepository authRepository;

  Isenrolled(this.authRepository);

  Future<ResponseResult> call(String userId) {
    return authRepository.isEnrolled(userId);
  }
}
