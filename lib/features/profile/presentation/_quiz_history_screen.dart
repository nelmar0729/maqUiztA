import '/shared/util/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/core/routes/app_router.dart';
import '/features/profile/domain/usecases/get_quiz_history.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';
import '/features/profile/data/datasources/data_source.dart';
import '/features/profile/data/repositories/repository_impl.dart';
import '/features/profile/data/models/quiz_history_model.dart';
import '/shared/app_colors.dart';

@RoutePage()
class QuizHistoryScreen extends StatefulWidget {
  const QuizHistoryScreen({super.key});

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  late final DataSource dataSource;
  late final RepositoryImpl repository;
  late final GetQuizHistory getQuizHistory;
  late final LocalAuthDataSource localAuth;

  List<QuizHistoryModel> _quizHistory = [];
  String _searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    localAuth = LocalAuthDataSource();
    dataSource = DataSourceImpl();
    repository = RepositoryImpl(dataSource);
    getQuizHistory = GetQuizHistory(repository, localAuth);

    _loadQuizHistory();
  }

  Future<void> _loadQuizHistory() async {
    setState(() => isLoading = true);

    final fetchedQuizHistory = await safeApiCall<List<QuizHistoryModel>>(
      context,
      () => getQuizHistory.call(),
    );

    if (!mounted) return; // 🔹 Prevent setState after dispose

    setState(() {
      if (fetchedQuizHistory != null) {
        _quizHistory = fetchedQuizHistory; // ✅ Only update if not null
      }
      isLoading = false;
    });
  }

  List<QuizHistoryModel> get _filteredQuizHistory {
    if (_searchQuery.isEmpty) return _quizHistory;
    return _quizHistory
        .where(
          (q) => q.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Sort by score descending
    List<QuizHistoryModel> sortedHistory = List.of(_filteredQuizHistory)
      ..sort((a, b) => b.score.compareTo(a.score));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz History',
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
      body: Column(
        children: [
          // --- SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search quizzes...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            // --- REFRESH INDICATOR ---
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadQuizHistory,
                    child: sortedHistory.isEmpty
                        ? const Center(child: Text('No quiz history yet.'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            itemCount: sortedHistory.length,
                            itemBuilder: (context, index) {
                              final quiz = sortedHistory[index];
                              final double percent = quiz.total > 0
                                  ? quiz.score / quiz.total
                                  : 0.0;
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 2,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFF6FE7FF),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    quiz.title,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${quiz.date}  |  Score: ${quiz.score}/${quiz.total}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  trailing: Icon(
                                    percent >= 0.7
                                        ? Icons.emoji_events
                                        : Icons.school,
                                    color: percent >= 0.7
                                        ? Colors.amber
                                        : Colors.blueGrey,
                                    size: 24,
                                  ),
                                  onTap: () {
                                    context.router.push(
                                      QuizHistoryDetailRoute(quiz: quiz),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
