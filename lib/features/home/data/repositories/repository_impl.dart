// Import your domain and data layer dependencies
import '/features/home/data/repositories/repository.dart';
import '../datasources/data_source.dart';
import '../models/user_model.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import '../models/recent_quiz_model.dart';
import '/features/subjects/data/models/subject_model.dart';
import '../models/leader_board_model.dart';

/// This class connects your business logic (domain) to your actual data source (API).
/// It implements the contract defined by Repository (in the domain layer).
///
/// When you call login(), it asks the remote data source to fetch the user from the backend,
/// and then returns a User object for the rest of your app to use.
class RepositoryImpl implements Repository {
  final DataSource remoteDataSource;

  // The repository needs to know which data source to use.
  RepositoryImpl(this.remoteDataSource);

  @override
  Future<UserModel> getUserData(String userId) {
    return remoteDataSource.getUserData(userId);
  }

  @override
  Future<List<QuizModel>> fetchTodayQuizzes(String userId) {
    return remoteDataSource.fetchTodayQuizzes(userId);
  }

  @override
  Future<List<RecentQuizModel>> fetchRecentQuiz(String userId) {
    return remoteDataSource.fetchRecentQuiz(userId);
  }

  @override
  Future<List<SubjectModel>> fetchSubjects(String userId) {
    return remoteDataSource.fetchSubjects(userId);
  }

  @override
  Future<Map<String, List<LeaderboardEntryModel>>> fetchLeaderboardsForStudent(
    String userId,
  ) {
    return remoteDataSource.fetchLeaderboardsForStudent(userId);
  }

  // You can add more methods here, like register(), getUserById(), etc.
}
