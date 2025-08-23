import '/features/subjects/data/repositories/repository.dart';
import '/features/subjects/data/models/subject_model.dart';

class FetchSubject {
  Repository repository;

  FetchSubject(this.repository);

  Future<List<SubjectModel>> call(String userId) {
    return repository.fetchSubjects(userId);
  }
}
