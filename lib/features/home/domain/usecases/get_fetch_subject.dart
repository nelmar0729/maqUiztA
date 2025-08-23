import '/features/home/data/repositories/repository.dart';
import '/features/subjects/data/models/subject_model.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

class GetFetchSubject {
  Repository repository;
  LocalAuthDataSource localAuthDataSource;
  GetFetchSubject(this.repository, this.localAuthDataSource);

  Future<List<SubjectModel>> call() async {
    final userId = await localAuthDataSource.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }
    return repository.fetchSubjects(userId);
  }
}
