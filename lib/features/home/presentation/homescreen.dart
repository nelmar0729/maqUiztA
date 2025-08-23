// ignore_for_file: use_build_context_synchronously
import '/shared/util/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

// Home widgets
import 'widgets/greetings.dart';
import 'widgets/todays_quizzes.dart';
import 'widgets/recent_results.dart';
import 'widgets/leaderboard_section.dart';

import '/features/home/data/datasources/data_source.dart';
import '/features/home/data/repositories/repository_impl.dart';
import '/features/home/domain/usecases/get_user_data.dart';
import '/features/home/domain/usecases/get_today_quizzes.dart';
import '/features/home/domain/usecases/get_recent_quizzes.dart';
import '/features/home/domain/usecases/get_fetch_subject.dart';
import '/features/home/domain/usecases/get_fetch_leader_board.dart';

import '/features/auth/data/datasources/local_auth_datasource.dart';

import '/features/home/data/models/user_model.dart';
import '/features/home/data/models/recent_quiz_model.dart';
import '/features/home/data/models/leader_board_model.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import '/features/subjects/data/models/subject_model.dart';
// import '/shared/widgets/snackbar.dart';
import '/shared/app_colors.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Use cases and data
  late final localAuth = LocalAuthDataSource();
  late final DataSource dataSource;
  late final RepositoryImpl repository;
  late final GetUserData getUserData;
  late final GetTodayQuizzes getTodayQuizzes;
  late final GetRecentQuizzes getRecentQuizzes;
  late final GetFetchSubject getFetchSubject;
  late final GetFetchLeaderBoard getFetchLeaderBoard;

  // State variables
  UserModel? userData;
  List<QuizModel> _todaysQuizzes = [];
  List<RecentQuizModel> _recentQuizzes = [];
  List<SubjectModel> _joinedSubjects = [];
  Map<String, List<LeaderboardEntryModel>> _leaderBoards = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    dataSource = DataSourceImpl();
    repository = RepositoryImpl(dataSource);
    getUserData = GetUserData(repository, localAuth);
    getTodayQuizzes = GetTodayQuizzes(repository, localAuth);
    getRecentQuizzes = GetRecentQuizzes(repository, localAuth);
    getFetchSubject = GetFetchSubject(repository, localAuth);
    getFetchLeaderBoard = GetFetchLeaderBoard(repository, localAuth);

    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => isLoading = true);

    final results = await Future.wait([
      safeApiCall<UserModel>(context, () => getUserData.call()),
      safeApiCall<List<QuizModel>>(context, () => getTodayQuizzes.call()),
      safeApiCall<List<RecentQuizModel>>(
        context,
        () => getRecentQuizzes.call(),
      ),
      safeApiCall<List<SubjectModel>>(context, () => getFetchSubject.call()),
      safeApiCall<Map<String, List<LeaderboardEntryModel>>>(
        context,
        () => getFetchLeaderBoard.call(),
      ),
    ]);

    // 🔹 Explicit safe casting with `as` would throw if wrong type
    // So instead use `results[i] as T?` carefully or `results[i] is T ? results[i] as T : null`

    final fetchedUser = results[0] as UserModel?;
    final fetchedQuizzes = results[1] as List<QuizModel>?;
    final fetchedRecent = results[2] as List<RecentQuizModel>?;
    final fetchedSubjects = results[3] as List<SubjectModel>?;
    final fetchedLeaderboards =
        results[4] as Map<String, List<LeaderboardEntryModel>>?;

    if (!mounted) return; // 🔹 prevent setState after dispose

    setState(() {
      if (fetchedUser != null) userData = fetchedUser;
      if (fetchedQuizzes != null) _todaysQuizzes = fetchedQuizzes;
      if (fetchedRecent != null) _recentQuizzes = fetchedRecent;
      if (fetchedSubjects != null) _joinedSubjects = fetchedSubjects;
      if (fetchedLeaderboards != null) _leaderBoards = fetchedLeaderboards;
      isLoading = false;
    });
  }

  // Future<void> _loadUserData() async {
  //   final fetchedUser = await safeApiCall(context, () => getUserData.call());
  //   if (fetchedUser != null) {
  //     setState(() => userData = fetchedUser);
  //   }
  // }

  // Future<void> _loadTodaysQuizzes() async {
  //   final fetchedQuizzes = await safeApiCall(
  //     context,
  //     () => getTodayQuizzes.call(),
  //   );
  //   if (fetchedQuizzes != null) {
  //     setState(() => _todaysQuizzes = fetchedQuizzes);
  //   }
  // }

  // Future<void> _loadRecentQuizzes() async {
  //   final fetchedRecent = await safeApiCall(
  //     context,
  //     () => getRecentQuizzes.call(),
  //   );
  //   if (fetchedRecent != null) {
  //     setState(() => _recentQuizzes = fetchedRecent);
  //   }
  // }

  // Future<void> _loadJoinedSubjects() async {
  //   final fetchedSubjects = await safeApiCall(
  //     context,
  //     () => getFetchSubject.call(),
  //   );
  //   if (fetchedSubjects != null) {
  //     setState(() => _joinedSubjects = fetchedSubjects);
  //   }
  // }

  // Future<void> _loadLeaderBoards() async {
  //   final fetchedLeaderBoards = await safeApiCall(
  //     context,
  //     () => getFetchLeaderBoard.call(),
  //   );
  //   if (fetchedLeaderBoards != null) {
  //     setState(() => _leaderBoards = fetchedLeaderBoards);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Loading state
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If user data is missing
    if (userData == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Failed to load user data 😢",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    // If no subjects joined
    if (_joinedSubjects.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Home",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: _loadAllData,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              GreetingHeader(
                avatarUrl: userData?.avatar ?? '',
                name:
                    "${userData?.firstName ?? 'Guest'} ${userData?.lastName ?? ''}",
              ),
              const SizedBox(height: 22),
              const Center(
                child: Text(
                  "You haven’t joined any subjects yet 📚",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Normal case
    return DefaultTabController(
      length: _joinedSubjects.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          title: const Text(
            'Profile',
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
        body: RefreshIndicator(
          onRefresh: _loadAllData,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              GreetingHeader(
                avatarUrl: userData?.avatar ?? '',
                name:
                    "${userData?.firstName ?? 'Guest'} ${userData?.lastName ?? ''}",
              ),
              const SizedBox(height: 22),

              // Today's Quizzes
              _todaysQuizzes.isEmpty
                  ? const Center(
                      child: Text(
                        "No quizzes for today 🎉",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : TodaysQuizzes(quizzes: _todaysQuizzes),

              const SizedBox(height: 18),

              // Recent Results
              _recentQuizzes.isEmpty
                  ? const Center(
                      child: Text(
                        "No recent results yet 📝",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : RecentResults(quizzes: _recentQuizzes),

              const SizedBox(height: 18),

              // Leaderboard
              _leaderBoards.isEmpty
                  ? const Center(
                      child: Text(
                        "No leaderboard data yet 👀",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : LeaderboardSection(
                      subjects: _joinedSubjects,
                      leaderboards: _leaderBoards,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
