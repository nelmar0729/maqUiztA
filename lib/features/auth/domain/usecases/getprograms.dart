import '/features/auth/data/repositories/auth_repository.dart';
import '/features/auth/data/models/program_model.dart';

class Getprograms {
  AuthRepository authRepository;

  Getprograms(this.authRepository);

  Future<List<ProgramModel>> call() {
    return authRepository.getPrograms();
  }
}
