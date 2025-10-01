import '/shared/response.dart';
import '/features/subjects/data/models/subject_model.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import '/features/subjects/data/models/module_model.dart';

/// This is the interface (contract) for your Repository.
/// It lists all the methods you want your authentication system to provide.
abstract class Repository {
  /// The login method takes an email and password,
  /// and returns a User object if successful.
  Future<ResponseResult> joinSubject(String userId, String code);

  Future<List<SubjectModel>> fetchSubjects(String userId);
  Future<List<QuizModel>> fetchQuizzesBySubject(
    String facultySubjectId,
    String userId,
  );
  Future<List<ModuleModel>> fetchModules(
    String userId,
    String facultySubjectId,
  );
  // You can add more contracts like:
  // Future<User> register(...);
  // Future<User> getUserById(int userId);
}
