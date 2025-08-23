import '/features/auth/data/repositories/auth_repository.dart';
import '/shared/response.dart';

class Register {
  AuthRepository authRepository;

  Register(this.authRepository);
  Future<ResponseResult> call(
    String firstname,
    String lastname,
    String studentId,
    String email,
    String password,
  ) {
    return authRepository.register(
      firstname,
      lastname,
      studentId,
      email,
      password,
    );
  }
}
