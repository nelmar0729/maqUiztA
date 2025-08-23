import '/features/home/data/repositories/repository.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

class GetTodayQuizzes {
  Repository repository;
  LocalAuthDataSource localAuthDataSource;
  GetTodayQuizzes(this.repository, this.localAuthDataSource);

  Future<List<QuizModel>> call() async {
    final userId = await localAuthDataSource.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }
    return repository.fetchTodayQuizzes(userId);
  }
}
