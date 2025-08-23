import '/features/home/data/repositories/repository.dart';
import '/features/home/data/models/recent_quiz_model.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

class GetRecentQuizzes {
  Repository repository;
  LocalAuthDataSource localAuthDataSource;
  GetRecentQuizzes(this.repository, this.localAuthDataSource);

  Future<List<RecentQuizModel>> call() async {
    final userId = await localAuthDataSource.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }
    return repository.fetchRecentQuiz(userId);
  }
}
