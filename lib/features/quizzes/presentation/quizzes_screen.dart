// ignore_for_file: deprecated_member_use
import '/shared/util/network_utils.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/core/routes/app_router.dart';
import '/features/quizzes/domain/usecases/fetch_quizzes.dart';
import '/shared/app_colors.dart';
import '/shared/text_styles.dart';
import '/shared/helpers.dart';
import '/features/quizzes/data/datasources/remote_data_source.dart';
import '/features/quizzes/data/repositories/repository_impl.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

@RoutePage()
class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  late final RemoteDataSource remoteDataSource;
  late final RepositoryImpl repositoryImpl;
  late final FetchQuizzes fetchQuizzes;
  final localAuth = LocalAuthDataSource();

  List<QuizModel> _quizzes = [];
  bool _isLoading = true;
  String? _error;
  String? _userId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    remoteDataSource = RemoteDataSourceImpl();
    repositoryImpl = RepositoryImpl(remoteDataSource);
    fetchQuizzes = FetchQuizzes(repositoryImpl);
    _getUserData();
  }

  void _getUserData() async {
    final userId = await localAuth.getUserId();

    if (!mounted) return; // ✅ prevent setState after dispose
    setState(() {
      _userId = userId;
    });

    if (_userId != null) {
      await _loadQuizzes();
    }
  }

  Future<void> _loadQuizzes() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final quizzes = await safeApiCall<List<QuizModel>>(
      context,
      () => fetchQuizzes(_userId ?? ""), // ✅ null safety
    );

    if (!mounted) return;
    setState(() {
      if (quizzes != null) {
        _quizzes = quizzes;
      }
      _isLoading = false;
    });
  }

  Future<void> _navigateAndRefresh(QuizModel quiz) async {
    await context.pushRoute(StartQuizRoute(quiz: quiz));
    await _loadQuizzes(); // this now uses safeApiCall
  }

  List<QuizModel> get _filteredQuizzes {
    if (_searchQuery.isEmpty) return _quizzes;
    return _quizzes.where((quiz) {
      final title = (quiz.title).toLowerCase();
      final desc = (quiz.description).toLowerCase();
      return title.contains(_searchQuery.toLowerCase()) ||
          desc.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quizzes",
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
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
                  child: RefreshIndicator(
                    onRefresh: _loadQuizzes,
                    child: _filteredQuizzes.isEmpty
                        ? ListView(
                            // ✅ make RefreshIndicator always usable
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(
                                height: 300, // just to give pull-down space
                                child: Center(
                                  child: Text('No quizzes available.'),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 20,
                            ),
                            physics:
                                const AlwaysScrollableScrollPhysics(), // ✅ enable pull even if few items
                            itemCount: _filteredQuizzes.length,
                            itemBuilder: (context, index) {
                              final quiz = _filteredQuizzes[index];
                              final now = DateTime.now();
                              final scheduledAt =
                                  quiz.scheduledAt ?? DateTime.now();
                              final int totalQuestions =
                                  quiz.totalQuestions ?? 1;
                              final int timerPerQuestion =
                                  quiz.timerPerQuestion ?? 15;
                              final int totalDurationSeconds =
                                  totalQuestions * timerPerQuestion;
                              final end = scheduledAt.add(
                                Duration(seconds: totalDurationSeconds),
                              );

                              // Status logic
                              String status = "";
                              Color statusColor;
                              if (now.isBefore(scheduledAt)) {
                                status = "Not Started";
                                statusColor = Colors.grey;
                              } else if (!now.isBefore(scheduledAt) &&
                                  now.isBefore(end)) {
                                status = "Ongoing";
                                statusColor = Colors.blueAccent;
                              } else {
                                status = "Ended";
                                statusColor = Colors.red;
                              }

                              // Faded card color
                              final baseColor = quiz.color != null
                                  ? Color(quiz.color!)
                                  : Colors.white;
                              final fadedCardColor = baseColor.withOpacity(
                                0.16,
                              );

                              final titleColor =
                                  baseColor.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.black87;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 18),
                                decoration: BoxDecoration(
                                  color: fadedCardColor,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 18,
                                  ),
                                  title: Text(
                                    quiz.title,
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: titleColor,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          quiz.description,
                                          style: AppTextStyles.titleSmall
                                              .copyWith(
                                                color: titleColor.withOpacity(
                                                  0.85,
                                                ),
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.schedule,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                AppHelpers.formatInTimeZone(
                                                  scheduledAt,
                                                  'Asia/Manila',
                                                  pattern: 'MMMM d, y H:mm',
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: statusColor.withOpacity(
                                                  0.15,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                status,
                                                style: TextStyle(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.local_fire_department,
                                              size: 18,
                                              color: _getDifficultyColor(
                                                quiz.difficulty ?? '',
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              quiz.difficulty ?? '',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                color: _getDifficultyColor(
                                                  quiz.difficulty ?? '',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: () async {
                                      await _navigateAndRefresh(quiz);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.accent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      textStyle: AppTextStyles.titleMedium,
                                    ),
                                    child: Text(
                                      status == "Ended"
                                          ? "View"
                                          : status == "Not Started"
                                          ? "Details"
                                          : "Start",
                                    ),
                                  ),
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

Color _getDifficultyColor(String? difficulty) {
  switch (difficulty?.toLowerCase()) {
    case 'easy':
      return AppColors.success;
    case 'medium':
      return AppColors.accent;
    case 'hard':
      return AppColors.error;
    default:
      return AppColors.disabled;
  }
}
