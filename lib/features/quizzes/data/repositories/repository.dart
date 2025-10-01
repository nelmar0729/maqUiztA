import '/shared/response.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import '/features/quizzes/data/models/question_model.dart';
import '/features/quizzes/data/models/leaderboard_model.dart';

/// This is the interface (contract) for your Repository.
/// It lists all the methods you want your authentication system to provide.
abstract class Repository {
  /// The login method takes an email and password,
  /// and returns a User object if successful.
  Future<ResponseResult> joinSubject(String userId, String code);
  Future<List<QuizModel>> fetchQuizzes(String userId);
  Future<List<QuestionModel>> fetchQuestions(int quizId, String userId);
  Future<ResponseResult> studentAnswer(
    String userId,
    int quizId,
    int questionId,
    int choiceId,
  );
  Future<List<LeaderboardUser>> leaderboardByQuiz(int quizId, String userId);
  // You can add more contracts like:
  // Future<User> register(...);
  // Future<User> getUserById(int userId);
}
