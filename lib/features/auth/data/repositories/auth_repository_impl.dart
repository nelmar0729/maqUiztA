// Import your domain and data layer dependencies
import '/features/auth/data/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '/shared/response.dart';
import '../models/program_model.dart';

/// This class connects your business logic (domain) to your actual data source (API).
/// It implements the contract defined by AuthRepository (in the domain layer).
///
/// When you call login(), it asks the remote data source to fetch the user from the backend,
/// and then returns a User object for the rest of your app to use.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  // The repository needs to know which data source to use.
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<ResponseResult> login(String email, String password) {
    // This will call the API (via the remote data source)
    // and return a UserModel, which can be used as a User.
    return remoteDataSource.login(email, password);
  }

  @override
  Future<ResponseResult> register(
    String firstname,
    String lastname,
    String studentId,
    String email,
    String password,
  ) {
    return remoteDataSource.register(
      firstname,
      lastname,
      studentId,
      email,
      password,
    );
  }

  @override
  Future<ResponseResult> verifyEmail(String email, String token) {
    return remoteDataSource.verifyEmail(email, token);
  }

  @override
  Future<ResponseResult> resendCode(String email) {
    return remoteDataSource.resendCode(email);
  }

  @override
  Future<List<ProgramModel>> getPrograms() {
    return remoteDataSource.getPrograms();
  }

  @override
  Future<ResponseResult> isEnrolled(String userId) {
    return remoteDataSource.isEnrolled(userId);
  }

  @override
  Future<ResponseResult> enrollStudent(
    String userId,
    int programId,
    String yearLevel,
    String section,
  ) {
    return remoteDataSource.enrollStudent(
      userId,
      programId,
      yearLevel,
      section,
    );
  }

  @override
  Future<ResponseResult> sendPasswordResetLink(String email) {
    return remoteDataSource.sendPasswordResetLink(email);
  }

  // You can add more methods here, like register(), getUserById(), etc.
}
