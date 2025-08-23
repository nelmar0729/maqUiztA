import '/shared/util/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

// Widgets
import '/shared/app_colors.dart';
import '/features/quizzes/data/models/leaderboard_model.dart';
import '/features/quizzes/domain/usecases/fetch_leader_board_by_quiz.dart';
import '/features/quizzes/data/datasources/remote_data_source.dart';
import '/features/quizzes/data/repositories/repository_impl.dart';

@RoutePage()
class LeaderboardScreen extends StatefulWidget {
  final int quizId; // <-- pass the quiz id for the specific leaderboard

  const LeaderboardScreen({super.key, required this.quizId});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late final RemoteDataSource remoteDataSource;
  late final RepositoryImpl repositoryImpl;
  late final FetchLeaderBoardByQuiz fetchLeaderBoardByQuiz;

  List<LeaderboardUser> _leaderboard = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    remoteDataSource = RemoteDataSourceImpl();
    repositoryImpl = RepositoryImpl(remoteDataSource);
    fetchLeaderBoardByQuiz = FetchLeaderBoardByQuiz(repositoryImpl);
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final users = await safeApiCall<List<LeaderboardUser>>(
      context,
      () => fetchLeaderBoardByQuiz(widget.quizId),
    );

    if (!mounted) return;
    setState(() {
      if (users != null) {
        _leaderboard = users;
      }
      _isLoading = false;
    });
  }

  Widget? _getMedal(int rank) {
    switch (rank) {
      case 1:
        return const Icon(Icons.emoji_events, color: Colors.amber, size: 32);
      case 2:
        return const Icon(Icons.emoji_events, color: Colors.grey, size: 28);
      case 3:
        return const Icon(
          Icons.emoji_events,
          color: Color(0xFFCD7F32),
          size: 24,
        ); // Bronze
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _leaderboard.isEmpty
          ? const Center(child: Text('No scores yet.'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              itemCount: _leaderboard.length,
              itemBuilder: (context, index) {
                final user = _leaderboard[index];
                final rank = index + 1;
                final medal = _getMedal(rank);

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: rank == 1 ? 8 : 2,
                  color: rank == 1
                      ? const Color(0xFFE3F6FC)
                      : rank == 2
                      ? const Color(0xFFF6F6F6)
                      : rank == 3
                      ? const Color(0xFFFFF6E3)
                      : AppColors.accent,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(user.avatar),
                      backgroundColor: Colors.grey.shade200,
                      child: medal != null
                          ? Stack(
                              children: [
                                Positioned(bottom: -6, right: -6, child: medal),
                              ],
                            )
                          : null,
                    ),
                    title: Text(
                      user.fullName,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    subtitle: Text(
                      "Score: ${user.score}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 7,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        color: rank == 1
                            ? const Color(0xFF00C6FB)
                            : rank == 2
                            ? Colors.grey[400]
                            : rank == 3
                            ? const Color(0xFFCD7F32)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "#$rank",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: rank <= 3
                              ? AppColors.accent
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
