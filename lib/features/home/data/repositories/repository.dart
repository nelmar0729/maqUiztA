import '../models/user_model.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import '../models/recent_quiz_model.dart';
import '/features/subjects/data/models/subject_model.dart';
import '../models/leader_board_model.dart';

/// This is the interface (contract) for your Repository.
/// It lists all the methods you want your authentication system to provide.
abstract class Repository {
  /// The login method takes an email and password,
  /// and returns a User object if successful.

  Future<UserModel> getUserData(String userId);
  Future<List<QuizModel>> fetchTodayQuizzes(String userId);
  Future<List<RecentQuizModel>> fetchRecentQuiz(String userId);
  Future<List<SubjectModel>> fetchSubjects(String userId);
  Future<Map<String, List<LeaderboardEntryModel>>> fetchLeaderboardsForStudent(
    String userId,
  );
  // You can add more contracts like:
  // Future<User> register(...);
  // Future<User> getUserById(int userId);
}
