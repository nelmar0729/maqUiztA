// ignore_for_file: deprecated_member_use
import '/shared/util/network_utils.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_route/auto_route.dart';
import '/core/routes/app_router.dart';
import '/features/quizzes/domain/usecases/fetch_questions.dart';

import '/shared/text_styles.dart';
import '/shared/helpers.dart';
import '/shared/app_colors.dart';

import 'widgets/countdown_overlay.dart';
import 'widgets/go_overlay.dart';
import 'widgets/question_card.dart';
import '/shared/widgets/primary_button_icon.dart';

import '/features/quizzes/data/models/question_model.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import '/features/quizzes/data/datasources/remote_data_source.dart';
import '/features/quizzes/data/repositories/repository_impl.dart';
import '/features/quizzes/domain/usecases/student_answer.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';
import '/features/quizzes/data/models/choices_model.dart';
import '/shared/widgets/snackbar.dart';

@RoutePage()
class StartQuizScreen extends StatefulWidget {
  final QuizModel quiz;

  const StartQuizScreen({super.key, required this.quiz});

  @override
  State<StartQuizScreen> createState() => _StartQuizScreenState();
}

class _StartQuizScreenState extends State<StartQuizScreen> {
  late final RemoteDataSource remoteDataSource;
  late final RepositoryImpl repositoryImpl;
  late final FetchQuestions fetchQuestions;
  late final StudentAnswer studentAnswer;
  final localAuth = LocalAuthDataSource();

  List<QuestionModel> questions = [];
  bool _isLoading = true;
  String? _error;

  late int maxTime;
  int _timeLeft = 15;
  Timer? _timer;
  int _currentQuestion = 0;
  late int _countdown;
  bool _showCountdown = false;

  String? _selectedAnswer;
  bool _quizFinished = false;
  bool _quizEndedDueToSchedule = false;
  bool showGoMessage = false;
  int _score = 0;
  bool _isAnswerSaved = false;

  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  late String scheduledAtPh;
  late String endsAtPh;
  late String nowPh;
  String? _userId;

  @override
  void initState() {
    super.initState();
    maxTime = widget.quiz.timerPerQuestion ?? 15;
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    remoteDataSource = RemoteDataSourceImpl();
    repositoryImpl = RepositoryImpl(remoteDataSource);
    fetchQuestions = FetchQuestions(repositoryImpl);
    studentAnswer = StudentAnswer(repositoryImpl);
    _fetchQuestions();
    _getUserData();
  }

  Future<void> _fetchQuestions() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final fetchedQuestions = await safeApiCall<List<QuestionModel>>(
      context,
      () => fetchQuestions(widget.quiz.quizId),
    );

    if (!mounted) return;
    setState(() {
      if (fetchedQuestions != null) {
        questions = fetchedQuestions;
      }
      _isLoading = false;
    });

    if (questions.isNotEmpty) {
      _setupQuiz();
    }
  }

  void _getUserData() async {
    final userId = await localAuth.getUserId();
    if (!mounted) return; // ✅ prevent setState on disposed widget
    setState(() {
      _userId = userId;
    });
  }

  void _setupQuiz() {
    final scheduledAt = widget.quiz.scheduledAt ?? DateTime.now();
    final now = DateTime.now();
    final questionsCount = questions.length;
    final endsAt = scheduledAt.add(Duration(seconds: questionsCount * maxTime));

    scheduledAtPh = AppHelpers.formatInTimeZone(
      scheduledAt,
      'Asia/Manila',
      pattern: 'yyyy-MM-dd HH:mm:ss',
    );
    endsAtPh = AppHelpers.formatInTimeZone(
      endsAt,
      'Asia/Manila',
      pattern: 'yyyy-MM-dd HH:mm:ss',
    );
    nowPh = AppHelpers.formatInTimeZone(
      now,
      'Asia/Manila',
      pattern: 'yyyy-MM-dd HH:mm:ss',
    );

    if (now.isAfter(endsAt)) {
      setState(() {
        _quizFinished = true;
        _quizEndedDueToSchedule = true;
      });
      return;
    }

    if (now.isBefore(scheduledAt)) {
      final diff = scheduledAt.difference(now).inSeconds;
      _showCountdown = true;
      _countdown = diff;

      _timer = AppHelpers.startCountdown(
        totalSeconds: diff,
        onTick: (remaining) {
          setState(() {
            _countdown = remaining;
          });
        },
        onComplete: () async {
          await AppHelpers.playSound(
            'sounds/Go.mp3',
            audioPlayer: _audioPlayer,
          );
          setState(() {
            _showCountdown = false;
            showGoMessage = true;
          });
          Future.delayed(const Duration(seconds: 1), () {
            setState(() => showGoMessage = false);
            _currentQuestion = 0;
            _selectedAnswer = null;
            _timeLeft = maxTime;
            _startQuestionTimer();
          });
        },
        onBeep: () async {
          await AppHelpers.playBeep(audioPlayer: _audioPlayer);
        },
      );
      return;
    }

    // Quiz started, maybe student is late
    final elapsed = now.difference(scheduledAt).inSeconds;
    int questionIndex = (elapsed ~/ maxTime);
    int questionTimeElapsed = elapsed % maxTime;
    int timeLeft = maxTime - questionTimeElapsed;

    if (questionIndex >= questionsCount) {
      setState(() {
        _quizFinished = true;
        _quizEndedDueToSchedule = true;
      });
      return;
    }

    setState(() {
      _showCountdown = false;
      showGoMessage = false;
      _currentQuestion = questionIndex;
      _selectedAnswer = null;
      _isAnswerSaved = false;
      _timeLeft = timeLeft;
    });

    _startQuestionTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startQuestionTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
        if (_timeLeft <= 5 && _timeLeft > 0) {
          await AppHelpers.playBeep(audioPlayer: _audioPlayer);
        }
      } else {
        timer.cancel();
        _goToNextQuestion();
      }
    });
  }

  void _goToNextQuestion() {
    setState(() {
      if (_currentQuestion < questions.length - 1) {
        _currentQuestion++;
        _selectedAnswer = null;
        _isAnswerSaved = false;
        _timeLeft = maxTime;
        _startQuestionTimer();
      } else {
        _quizFinished = true;
        Future.delayed(const Duration(milliseconds: 300), () {
          _confettiController.play();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the quiz color dynamically, fallback to primary if null
    final Color quizColor = widget.quiz.color != null
        ? Color(widget.quiz.color!)
        : AppColors.primary;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.quiz.title)),
        body: Center(child: Text(_error!)),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.quiz.title)),
        body: const Center(
          child: Text(
            'No questions available for this quiz.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    double progress = _timeLeft / maxTime;

    if (_quizEndedDueToSchedule) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.quiz.title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          backgroundColor: quizColor,
          elevation: 0,
          foregroundColor: quizColor.computeLuminance() < 0.4
              ? Colors.white
              : Colors.black87,
        ),
        body: Container(
          color: AppColors.textPrimary.withOpacity(0.8),
          child: Center(
            child: Text(
              "Quiz is ended.",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      );
    }

    if (_quizFinished) {
      double percent = questions.isNotEmpty ? _score / questions.length : 0.0;
      String message;
      String emoji;
      if (percent == 1.0) {
        message = "Perfect! 🎉";
        emoji = "🥇";
      } else if (percent >= 0.7) {
        message = "Great job!";
        emoji = "👏";
      } else if (percent >= 0.4) {
        message = "Keep practicing!";
        emoji = "💪";
      } else {
        message = "Try again!";
        emoji = "🙂";
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.quiz.title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          backgroundColor: quizColor,
          elevation: 0,
          foregroundColor: quizColor.computeLuminance() < 0.4
              ? Colors.white
              : Colors.black87,
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                    height: 110,
                    width: 110,
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 80)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: [
                      quizColor,
                      Color(0xFF6FE7FF),
                      Colors.amber,
                      AppColors.success,
                      Colors.pink,
                    ],
                    numberOfParticles: 25,
                    emissionFrequency: 0.09,
                    gravity: 0.3,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Quiz Finished!",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: quizColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 36,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: percent >= 0.5
                          ? quizColor.withOpacity(0.15)
                          : AppColors.error.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: quizColor.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Your Score",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: quizColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "$_score / ${questions.length}",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: percent >= 0.5 ? quizColor : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  PrimaryButtonWithIcon(
                    text: "View Leaderboards",
                    onPressed: () {
                      context.router.push(
                        LeaderboardRoute(quizId: widget.quiz.quizId),
                      );
                    },
                    icon: Icons.leaderboard,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final question = questions[_currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.quiz.title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: quizColor,
        elevation: 0,
        foregroundColor: quizColor.computeLuminance() < 0.4
            ? Colors.white
            : Colors.black87,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
              ),
              if ((widget.quiz.description).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Text(
                    widget.quiz.description,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 18,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: quizColor.withOpacity(0.18),
                    valueColor: AlwaysStoppedAnimation<Color>(quizColor),
                    minHeight: 16,
                  ),
                ),
              ),
              QuestionCard(
                question: question,
                selectedAnswer: _selectedAnswer,
                onChoiceTap: (ChoiceModel choiceModel) async {
                  if (_isAnswerSaved) return; // Prevent multiple answers!
                  setState(() {
                    _selectedAnswer = choiceModel.choiceText;
                    _isAnswerSaved = true;
                  });

                  final isCorrect = choiceModel.isCorrect == 1;

                  if (_userId == null) return;

                  final result = await studentAnswer(
                    _userId!,
                    widget.quiz.quizId,
                    question.questionId,
                    choiceModel.choiceId,
                  );
                  if (result.success) {
                    AppSnack.show(context, result.message, SnackType.success);
                  } else {
                    AppSnack.show(context, result.message, SnackType.error);
                  }
                  // print('Answer saved: ${result.message}');

                  if (isCorrect) _score++;

                  // DO NOT advance! Wait for timer.
                },
              ),
              if (_selectedAnswer != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      "Waiting for time to finish...",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              const Spacer(),
            ],
          ),
          if (_showCountdown) CountdownOverlay(count: _countdown),
          if (showGoMessage) const GoOverlay(),
        ],
      ),
    );
  }
}
