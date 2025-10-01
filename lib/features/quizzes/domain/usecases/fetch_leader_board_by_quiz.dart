import '/features/quizzes/data/repositories/repository.dart';
import '/features/quizzes/data/models/leaderboard_model.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';
class FetchLeaderBoardByQuiz {
  Repository repository;
  LocalAuthDataSource localAuthDataSource;

  FetchLeaderBoardByQuiz(this.repository,this.localAuthDataSource);

  Future<List<LeaderboardUser>> call(int quizId) async {
    final userId = await localAuthDataSource.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }
    return repository.leaderboardByQuiz(quizId, userId);
  }
}
