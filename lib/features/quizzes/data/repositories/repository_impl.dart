// Import your domain and data layer dependencies
import '../repositories/repository.dart';
import '../datasources/remote_data_source.dart';
import '/shared/response.dart';
import '../models/quiz_model.dart';
import '/features/quizzes/data/models/question_model.dart';
import '/features/quizzes/data/models/leaderboard_model.dart';

/// This class connects your business logic (domain) to your actual data source (API).
/// It implements the contract defined by Repository (in the domain layer).
///
/// When you call login(), it asks the remote data source to fetch the user from the backend,
/// and then returns a User object for the rest of your app to use.
class RepositoryImpl implements Repository {
  final RemoteDataSource remoteDataSource;

  // The repository needs to know which data source to use.
  RepositoryImpl(this.remoteDataSource);

  @override
  Future<ResponseResult> joinSubject(String userId, String code) {
    return remoteDataSource.joinSubject(userId, code);
  }

  @override
  Future<List<QuizModel>> fetchQuizzes(String userId) {
    return remoteDataSource.fetchQuizzes(userId);
  }

  @override
  Future<List<QuestionModel>> fetchQuestions(int quizId, String userId) {
    return remoteDataSource.fetchQuestions(quizId, userId);
  }

  @override
  Future<ResponseResult> studentAnswer(
    String userId,
    int quizId,
    int questionId,
    int choiceId,
  ) {
    return remoteDataSource.studentAnswer(userId, quizId, questionId, choiceId);
  }

  @override
  Future<List<LeaderboardUser>> leaderboardByQuiz(int quizId, String userId) {
    return remoteDataSource.leaderboardByQuiz(quizId, userId);
  }

  // You can add more methods here, like register(), getUserById(), etc.
}
