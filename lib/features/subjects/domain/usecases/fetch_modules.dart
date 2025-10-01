import '/features/subjects/data/repositories/repository.dart';
import '/features/subjects/data/models/module_model.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

class FetchModules {
  Repository repository;
  LocalAuthDataSource localAuthDataSource;
  FetchModules(this.repository, this.localAuthDataSource);

  Future<List<ModuleModel>> call(String facultySubjectId) async {
    final userId = await localAuthDataSource.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }
    return repository.fetchModules(userId, facultySubjectId);
  }
}
