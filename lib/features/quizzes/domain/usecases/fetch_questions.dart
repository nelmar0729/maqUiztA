import '/features/quizzes/data/repositories/repository.dart';
import '/features/quizzes/data/models/question_model.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

class FetchQuestions {
  Repository repository;
  LocalAuthDataSource localAuthDataSource;

  FetchQuestions(this.repository, this.localAuthDataSource);

  Future<List<QuestionModel>> call(int quizId) async {
    final userId = await localAuthDataSource.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }
    return repository.fetchQuestions(quizId, userId);
  }
}
