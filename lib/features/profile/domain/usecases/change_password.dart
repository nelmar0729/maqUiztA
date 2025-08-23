import '/features/profile/data/repositories/repository.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';
import '/shared/response.dart';


class ChangePassword {
  final Repository repository;
  final LocalAuthDataSource localAuthDataSource;

  ChangePassword(this.repository, this.localAuthDataSource);

  Future<ResponseResult> call({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final userId = await localAuthDataSource.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }
    return repository.changePassword(
      currentPassword,
      newPassword,
      confirmPassword,
      userId,
    );
    // Repository handles the upload & update
  }
}
