// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import '/shared/util/unified_interstitial_ad.dart';
import '/shared/util/network_utils.dart';
import '/shared/app_colors.dart';

import '/features/quizzes/data/models/leaderboard_model.dart';
import '/features/quizzes/domain/usecases/fetch_leader_board_by_quiz.dart';
import '/features/quizzes/data/datasources/remote_data_source.dart';
import '/features/quizzes/data/repositories/repository_impl.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

@RoutePage()
class LeaderboardScreen extends StatefulWidget {
  final int quizId;
  const LeaderboardScreen({super.key, required this.quizId});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late final LocalAuthDataSource localAuthDataSource;
  late final RemoteDataSource remoteDataSource;
  late final RepositoryImpl repositoryImpl;
  late final FetchLeaderBoardByQuiz fetchLeaderBoardByQuiz;

  List<LeaderboardUser> _leaderboard = [];
  List<int> _ranks = []; // ← dense ranks
  bool _isLoading = true;
  String? _error;

  bool _adWatched = false;

  @override
  void initState() {
    super.initState();
    localAuthDataSource = LocalAuthDataSource();
    remoteDataSource = RemoteDataSourceImpl();
    repositoryImpl = RepositoryImpl(remoteDataSource);
    fetchLeaderBoardByQuiz = FetchLeaderBoardByQuiz(
      repositoryImpl,
      localAuthDataSource,
    );

    UnifiedInterstitialAd.show(
      onComplete: () {
        setState(() => _adWatched = true);
        _fetchLeaderboard();
      },
    );
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

    if (users == null) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load leaderboard.';
      });
      return;
    }

    // Sort by score desc; tie-break deterministically by name (optional)
    final sorted = [...users]..sort((a, b) {
      final byScore = (b.score).compareTo(a.score);
      if (byScore != 0) return byScore;
      // Optional: add other tie-breakers if you have them (e.g., duration, submittedAt)
      return a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase());
    });

    // Dense ranking: 1,2,2,3 for ties
    final ranks = <int>[];
    int currentRank = 0;
    int? lastScore;
    for (final u in sorted) {
      if (lastScore == null || u.score != lastScore) {
        currentRank += 1;
        lastScore = u.score;
      }
      ranks.add(currentRank);
    }

    setState(() {
      _leaderboard = sorted;
      _ranks = ranks;
      _isLoading = false;
    });
  }

  Widget? _getMedal(int rank) {
    switch (rank) {
      case 1:
        return const Icon(Icons.emoji_events, color: Colors.amber, size: 26);
      case 2:
        return const Icon(Icons.emoji_events, color: Colors.grey, size: 24);
      case 3:
        return const Icon(Icons.emoji_events, color: Color(0xFFCD7F32), size: 22); // Bronze
      default:
        return null;
    }
  }

  Color _chipBg(int rank) {
    if (rank == 1) return const Color(0xFF00C6FB);
    if (rank == 2) return Colors.grey[400]!;
    if (rank == 3) return const Color(0xFFCD7F32);
    return Colors.grey[200]!;
  }

  @override
  Widget build(BuildContext context) {
    if (!_adWatched) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.white)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white, // ensures icons/text are white
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _leaderboard.isEmpty
                  ? const Center(child: Text('No scores yet.'))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                      itemCount: _leaderboard.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final user = _leaderboard[index];
                        final rank = _ranks[index];
                        final medal = _getMedal(rank);

                        // New face: sleeker white card with subtle accent bar and rank chip
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                            border: Border.all(
                              color: rank <= 3
                                  ? AppColors.primary.withOpacity(0.20)
                                  : const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            leading: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage: (user.avatar.isNotEmpty)
                                      ? NetworkImage(user.avatar)
                                      : const AssetImage('assets/images/user.png') as ImageProvider,
                                ),
                                if (medal != null)
                                  Positioned(
                                    bottom: -2,
                                    right: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: medal,
                                    ),
                                  ),
                              ],
                            ),
                            title: Text(
                              user.fullName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              "Score: ${user.score}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF334155),
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                              decoration: BoxDecoration(
                                color: _chipBg(rank),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                "#$rank",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: rank <= 3 ? Colors.white : const Color(0xFF111827),
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
