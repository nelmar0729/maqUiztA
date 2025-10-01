import '/features/subjects/data/repositories/repository.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

class FetchQuizzesBySubject {
  Repository repository;
  LocalAuthDataSource localAuthDataSource;
  FetchQuizzesBySubject(this.repository, this.localAuthDataSource);

  Future<List<QuizModel>> call(String facultySubjectId) async {
    final userId = await localAuthDataSource.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }
    return repository.fetchQuizzesBySubject(facultySubjectId, userId);
  }
}
