import '/features/home/data/repositories/repository.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';
import '/features/home/data/models/leader_board_model.dart';

class GetFetchLeaderBoard {
  Repository repository;
  LocalAuthDataSource localAuthDataSource;
  GetFetchLeaderBoard(this.repository, this.localAuthDataSource);

  Future<Map<String, List<LeaderboardEntryModel>>> call() async {
    final userId = await localAuthDataSource.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }
    return repository.fetchLeaderboardsForStudent(userId);
  }
}
