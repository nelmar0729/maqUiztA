import '/features/profile/data/repositories/repository.dart';
import '/features/profile/data/models/quiz_history_model.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

class GetQuizHistory {
  Repository repository;
  LocalAuthDataSource localAuthDataSource;
  GetQuizHistory(this.repository, this.localAuthDataSource);

  Future<List<QuizHistoryModel>> call() async {
    final userId = await localAuthDataSource.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }
    return repository.getQuizHistory(userId);
  }
}
