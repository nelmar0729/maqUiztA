import '/features/auth/data/repositories/auth_repository.dart';
import '/shared/response.dart';

class Enrollstudent {
  AuthRepository authRepository;

  Enrollstudent(this.authRepository);

  Future<ResponseResult> call(
    String userId,
    int programId,
    String yearLevel,
    String section,
  ) {
    return authRepository.enrollStudent(userId, programId, yearLevel, section);
  }
}
