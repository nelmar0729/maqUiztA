// ignore_for_file: deprecated_member_use
import '/shared/util/network_utils.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/core/routes/app_router.dart';
import '../domain/usecases/fetch_quizzes_by_subject.dart';
import '/shared/app_colors.dart';
import '/shared/text_styles.dart';
import '/shared/helpers.dart';
import '/features/subjects/data/datasources/remote_data_source.dart';
import '/features/subjects/data/repositories/repository_impl.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';
import '/features/subjects/data/models/subject_model.dart';

@RoutePage()
class SubjectQuizzesScreen extends StatefulWidget {
  final SubjectModel subject; // ✅ add this

  const SubjectQuizzesScreen({super.key, required this.subject});

  @override
  State<SubjectQuizzesScreen> createState() => _SubjectQuizzesScreenState();
}

class _SubjectQuizzesScreenState extends State<SubjectQuizzesScreen> {
  late final RemoteDataSource remoteDataSource;
  late final RepositoryImpl repositoryImpl;
  late final FetchQuizzesBySubject fetchQuizzes;
  final localAuth = LocalAuthDataSource();

  List<QuizModel> _quizzes = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  DateTime? _lastUpdated;

  Timer? _autoRefreshTimer;
  Timer? _uiUpdateTimer;

  @override
  void initState() {
    super.initState();

    remoteDataSource = RemoteDataSourceImpl();
    repositoryImpl = RepositoryImpl(remoteDataSource);
    fetchQuizzes = FetchQuizzesBySubject(repositoryImpl, localAuth);

    _loadQuizzes(showLoader: true); // ✅ load immediately

    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _loadQuizzes();
    });

    _uiUpdateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    _uiUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadQuizzes({bool showLoader = false}) async {
    if (!mounted) return;

    if (showLoader) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    final quizzes = await safeApiCall<List<QuizModel>>(
      context,
      () => fetchQuizzes(widget.subject.facultySubjectId), // ✅ use subject ID
    );

    if (!mounted) return;
    setState(() {
      if (quizzes != null) {
        _quizzes = quizzes;
        _lastUpdated = DateTime.now();
      }
      _isLoading = false;
    });
  }

  Future<void> _navigateAndRefresh(QuizModel quiz) async {
    await context.pushRoute(StartQuizRoute(quiz: quiz));
    await _loadQuizzes();
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
        title: Text(
          "Quizzes - ${widget.subject.subjectCode}",
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
                // 🔍 Search bar
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

                // ⏱️ Last updated info
                if (_lastUpdated != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 18,
                      right: 18,
                      bottom: 6,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Last updated: ${AppHelpers.formatInTimeZone(_lastUpdated!, 'Asia/Manila', pattern: 'HH:mm:ss')}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                // 📋 Quiz list
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _loadQuizzes(showLoader: true),
                    child: _filteredQuizzes.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(
                                height: 300,
                                child: Center(
                                  child: Text('No quizzes available.'),
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 20,
                            ),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: _filteredQuizzes.length,
                            itemBuilder: (context, index) {
                              final quiz = _filteredQuizzes[index];
                              return QuizCard(
                                quiz: quiz,
                                onTap: () async =>
                                    await _navigateAndRefresh(quiz),
                              );
                            },
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 18),
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}

/// 🔹 Extracted widget for better performance
/// 🔹 Extracted widget for better performance
class QuizCard extends StatelessWidget {
  final QuizModel quiz;
  final VoidCallback onTap;

  const QuizCard({super.key, required this.quiz, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final scheduledAt = quiz.scheduledAt ?? DateTime.now();
    final int totalQuestions = quiz.totalQuestions ?? 1;
    final int timerPerQuestion = quiz.timerPerQuestion ?? 15;
    final int totalDurationSeconds = totalQuestions * timerPerQuestion;
    final end = scheduledAt.add(Duration(seconds: totalDurationSeconds));

    // Status logic
    String status = "";
    Color statusColor;
    if (now.isBefore(scheduledAt)) {
      status = "Not Started";
      statusColor = Colors.grey;
    } else if (!now.isBefore(scheduledAt) && now.isBefore(end)) {
      status = "Ongoing";
      statusColor = Colors.blueAccent;
    } else {
      status = "Ended";
      statusColor = Colors.red;
    }

    // Card colors
    final baseColor = quiz.color != null ? Color(quiz.color!) : Colors.white;
    final fadedCardColor = baseColor.withOpacity(0.16);

    final titleColor = baseColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.black87;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
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
            style: AppTextStyles.titleMedium.copyWith(color: titleColor),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Subject Code
                if (quiz.subjectCode != null && quiz.subjectCode!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      "Subject Code: ${quiz.subjectCode}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                Text(
                  quiz.description,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: titleColor.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: Colors.grey),
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

                    // 🔹 Animated status badge
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.4),
                            end: Offset.zero,
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        key: ValueKey(status), // ✅ triggers animation
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
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
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 18,
                      color: _getDifficultyColor(quiz.difficulty ?? ''),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      quiz.difficulty ?? '',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: _getDifficultyColor(quiz.difficulty ?? ''),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
