import '/features/home/data/repositories/repository.dart';
import '/features/home/data/models/user_model.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

class GetUserData {
  Repository repository;
  LocalAuthDataSource localAuthDataSource;
  GetUserData(this.repository, this.localAuthDataSource);

  Future<UserModel> call() async {
    final userId = await localAuthDataSource.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }
    return repository.getUserData(userId);
  }
}
