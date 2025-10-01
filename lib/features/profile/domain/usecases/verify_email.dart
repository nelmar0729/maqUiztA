import '/features/profile/data/repositories/repository.dart';
import '/shared/response.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

class VerifyEmail {
  final Repository repository;
  final LocalAuthDataSource localAuthDataSource;
  VerifyEmail(this.repository, this.localAuthDataSource);

  Future<ResponseResult> call({
    required String email,
    required String token,
  }) async {
    final userId = await localAuthDataSource.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }
    // Repository handles the upload & update
    return repository.verifyEmail(email, token, userId);
  }
}
