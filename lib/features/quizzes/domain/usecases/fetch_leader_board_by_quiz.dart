import '/features/quizzes/data/repositories/repository.dart';
import '/features/quizzes/data/models/leaderboard_model.dart';

class FetchLeaderBoardByQuiz {
  Repository repository;

  FetchLeaderBoardByQuiz(this.repository);
  Future<List<LeaderboardUser>> call(int quizId) {
    return repository.leaderboardByQuiz(quizId);
  }
}
