import '/features/subjects/data/repositories/repository.dart';
import '/shared/response.dart';

class JoinSubject {
  Repository repository;

  JoinSubject(this.repository);
  Future<ResponseResult> call(String userId, String code) {
    return repository.joinSubject(userId, code);
  }
}
