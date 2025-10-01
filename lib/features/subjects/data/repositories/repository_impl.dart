// Import your domain and data layer dependencies
import '/features/subjects/data/repositories/repository.dart';
import '../datasources/remote_data_source.dart';
import '/shared/response.dart';
import '/features/subjects/data/models/subject_model.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import '/features/subjects/data/models/module_model.dart';


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
  Future<List<SubjectModel>> fetchSubjects(String userId) {
    return remoteDataSource.fetchSubjects(userId);
  }

  @override
  Future<List<QuizModel>> fetchQuizzesBySubject(
    String facultySubjectId,
    String userId,
  ) {
    return remoteDataSource.fetchQuizzesBySubject(facultySubjectId, userId);
  }
  
  @override
  Future<List<ModuleModel>> fetchModules(
    String userId,
    String facultySubjectId,
  ) {
    return remoteDataSource.fetchModules(userId, facultySubjectId);
  }

  // You can add more methods here, like register(), getUserById(), etc.
}
