import '/features/profile/data/repositories/repository.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';
import '/shared/response.dart';

class UpdateUserData {
  final Repository repository;
  final LocalAuthDataSource localAuthDataSource;

  UpdateUserData(this.repository, this.localAuthDataSource);

  Future<ResponseResult> call({
    required String firstname,
    required String lastname,
    required String studentId,
    required String email,
    dynamic avatar, // nullable for image
    required int programId,
    required String yearLevel,
    required String section,

  }) async {
    final userId = await localAuthDataSource.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }
    // Repository handles the upload & update
    return repository.updateUserData(
      firstname,
      lastname,
      studentId,
      email,
      avatar,
      programId,
      yearLevel,
      section,
      userId,
    );
  }
}
