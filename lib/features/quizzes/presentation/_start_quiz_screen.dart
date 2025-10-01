// ignore_for_file: deprecated_member_use

import '/shared/util/unified_interstitial_ad.dart';
import 'package:no_screenshot/no_screenshot.dart';
import '/shared/util/network_utils.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart'; // 🎵 for background music
import 'package:auto_route/auto_route.dart';
import '/core/routes/app_router.dart';

import '/features/quizzes/domain/usecases/fetch_questions.dart';

import '/shared/text_styles.dart';
import '/shared/helpers.dart';
import '/shared/app_colors.dart';

import 'widgets/countdown_overlay.dart';
import 'widgets/go_overlay.dart';
import 'widgets/question_card.dart';

import '/features/quizzes/data/models/question_model.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import '/features/quizzes/data/datasources/remote_data_source.dart';
import '/features/quizzes/data/repositories/repository_impl.dart';
import '/features/quizzes/domain/usecases/student_answer.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';
import '/shared/widgets/snackbar.dart';
import '/features/quizzes/presentation/widgets/quiz_result.dart';
import '/features/quizzes/presentation/widgets/quiz_ended.dart';
import '/core/routes/route_observer.dart'; // import it

@RoutePage()
class StartQuizScreen extends StatefulWidget {
  final QuizModel quiz;

  const StartQuizScreen({super.key, required this.quiz});

  @override
  State<StartQuizScreen> createState() => _StartQuizScreenState();
}

class _StartQuizScreenState extends State<StartQuizScreen> with RouteAware {
  // Data / Usecases
  late final RemoteDataSource remoteDataSource;
  late final RepositoryImpl repositoryImpl;
  late final FetchQuestions fetchQuestions;
  late final StudentAnswer studentAnswer;
  late final LocalAuthDataSource localAuth;
  final noScreenshot = NoScreenshot.instance;

  // State
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

  late ConfettiController _confettiController;

  // 🎵 Audio
  final AudioPlayer _sfxPlayer = AudioPlayer(); // for correct/wrong sounds

  late String scheduledAtPh;
  late String endsAtPh;
  late String nowPh;
  String? _userId;

  // Ads flag
  bool _adShowing = false;

  // Win streak
  int _streak = 0;
  bool _showStreak = false;

  // Guard to ensure the quiz timer starts once (after both _userId + questions ready)
  bool _quizTimerStarted = false;

  @override
  void initState() {
    super.initState();

    maxTime = widget.quiz.timerPerQuestion ?? 15;
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    localAuth = LocalAuthDataSource();

    remoteDataSource = RemoteDataSourceImpl();
    repositoryImpl = RepositoryImpl(remoteDataSource);
    fetchQuestions = FetchQuestions(repositoryImpl, localAuth);
    studentAnswer = StudentAnswer(repositoryImpl);

    // Load in parallel; start quiz only when both are ready
    _fetchQuestions();
    _getUserData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();

    _sfxPlayer.dispose();

    routeObserver.unsubscribe(this);
    noScreenshot.screenshotOn(); // safety reset
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPush() {
    noScreenshot.screenshotOff(); // block screenshots when quiz page shown
  }

  @override
  void didPopNext() {
    noScreenshot.screenshotOff(); // back to quiz page → block again
  }

  @override
  void didPushNext() {
    noScreenshot.screenshotOn(); // another page pushed on top → allow
  }

  @override
  void didPop() {
    noScreenshot.screenshotOn(); // leaving quiz page → allow
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

    _maybeStartQuiz();
  }

  void _getUserData() async {
    final userId = await localAuth.getUserId();
    if (!mounted) return;
    setState(() {
      _userId = userId;
    });
    _maybeStartQuiz();
  }

  // Start quiz only once when both _userId and questions are available
  void _maybeStartQuiz() {
    if (_quizTimerStarted) return;
    if (_userId == null) return;
    if (questions.isEmpty) return;

    _quizTimerStarted = true;
    _setupQuiz();
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

      _timer?.cancel();
      _timer = AppHelpers.startCountdown(
        totalSeconds: diff,
        onTick: (remaining) {
          if (!mounted) return;
          setState(() {
            _countdown = remaining;
          });
        },
        onComplete: () async {
          await AppHelpers.playSound(
            'sounds/final.mp3',
            audioPlayer: _sfxPlayer,
          );
          if (!mounted) return;
          setState(() {
            _showCountdown = false;
            showGoMessage = true;
          });
          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) return;
            setState(() => showGoMessage = false);
            _currentQuestion = 0;
            _selectedAnswer = null;
            _timeLeft = maxTime;
            _startQuestionTimer();
          });
        },
        onBeep: () async {
          await AppHelpers.playBeep(audioPlayer: _sfxPlayer);
        },
      );
      return;
    }

    // Quiz started late
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
      _timeLeft = timeLeft;
    });

    _startQuestionTimer();
  }

  void _startQuestionTimer() {
    // 🎵 Start background music if not already playing

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) return;
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
        if (_timeLeft <= 5 && _timeLeft > 0) {
          await AppHelpers.playBeep(audioPlayer: _sfxPlayer);
        }
      } else {
        timer.cancel();
        _goToNextQuestion();
      }
    });
  }

  void _goToNextQuestion() async {
    _timer?.cancel(); // prevent double timers
    final question = questions[_currentQuestion];

    if (_userId == null || _selectedAnswer == null) {
      await _handleNoAnswer();
    } else {
      final selectedChoice = question.choices.firstWhere(
        (c) => c.choiceText == _selectedAnswer,
      );

      try {
        final result = await studentAnswer(
          _userId!,
          widget.quiz.quizId,
          question.questionId,
          selectedChoice.choiceId,
        );

        if (!result.success) {
          AppSnack.show(context, result.message, SnackType.error);
          await _handleWrongAnswer();
        } else {
          if (selectedChoice.isCorrect == 1) {
            await _handleCorrectAnswer();
          } else {
            await _handleWrongAnswer();
          }
        }
      } catch (e) {
        AppSnack.show(
          context,
          'Submitting failed. Continuing…',
          SnackType.error,
        );
        await _handleWrongAnswer();
      }
    }

    if (!mounted) return;
    setState(() {
      if (_currentQuestion >= questions.length - 1) {
        _showAd(
          onComplete: () {
            if (!mounted) return;
            setState(() {
              _quizFinished = true;
              Future.delayed(const Duration(milliseconds: 300), () {
                _confettiController.play();
              });
            });
          },
        );
      } else {
        // Still more questions → move forward
        setState(() {
          _currentQuestion++;
          _selectedAnswer = null;
          _timeLeft = maxTime;
        });
        _startQuestionTimer();
      }
    });
  }

  Future<void> _handleNoAnswer() async {
    await _sfxPlayer.stop();
    await AppHelpers.playSound('sounds/not.wav', audioPlayer: _sfxPlayer);
  }

  Future<void> _handleCorrectAnswer() async {
    await _sfxPlayer.stop();
    _score++;
    _streak++;

    await AppHelpers.playSound('sounds/correct.mp3', audioPlayer: _sfxPlayer);

    setState(() => _showStreak = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showStreak = false);
    });

    _confettiController.play();
    await AppHelpers.playSound('sounds/winstreak.mp3', audioPlayer: _sfxPlayer);
  }

  Future<void> _handleWrongAnswer() async {
    _streak = 0;
    await AppHelpers.playSound('sounds/wrong.mp3', audioPlayer: _sfxPlayer);
  }

  void _showAd({VoidCallback? onComplete}) {
    if (_adShowing) {
      onComplete?.call();
      return;
    }
    _adShowing = true;

    UnifiedInterstitialAd.show(
      onComplete: () {
        _adShowing = false;
        onComplete?.call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

    final double progress = _timeLeft / maxTime;

    if (_quizEndedDueToSchedule) {
      return QuizEndedScreen(
        quizTitle: widget.quiz.title,
        onCheckUpcoming: () {
          context.router.push(const QuizterNavRoute());
        },
      );
    }

    if (_quizFinished) {
      return QuizResultScreen(
        quizId: widget.quiz.quizId,
        quizTitle: widget.quiz.title,
        score: _score,
        totalQuestions: questions.length,
        quizColor: quizColor,
        confettiController: _confettiController,
      );
    }

    final question = questions[_currentQuestion];
    final primaryLuminance = AppColors.primary.computeLuminance();

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
        backgroundColor: AppColors.primary, // Fixed primary app bar
        elevation: 0,
        foregroundColor: primaryLuminance < 0.4 ? Colors.white : Colors.black87,
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Optional description
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
                  const SizedBox(height: 16),

                  // Header row: "Question x of N" + linear progress
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Question ${_currentQuestion + 1} of ${questions.length}",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value:
                                    (_currentQuestion + 1) / questions.length,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  quizColor,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Circular timer
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 1.0, end: progress),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, _) => SizedBox(
                            height: 120,
                            width: 120,
                            child: CircularProgressIndicator(
                              value: value,
                              strokeWidth: 18,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress > 0.6
                                    ? quizColor
                                    : progress > 0.3
                                    ? quizColor.withOpacity(0.7)
                                    : Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: _timeLeft <= 5 ? 110 : 100,
                          width: _timeLeft <= 5 ? 110 : 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _timeLeft <= 5
                                ? Colors.red.withOpacity(0.2)
                                : Colors.transparent,
                          ),
                        ),
                        Text(
                          "$_timeLeft",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: _timeLeft <= 5 ? 38 : 32,
                            fontWeight: FontWeight.bold,
                            color: _timeLeft <= 5
                                ? Colors.redAccent
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Question + choices
                  QuestionCard(
                    question: question,
                    selectedAnswer: _selectedAnswer,
                    onChoiceTap: (choiceModel) {
                      setState(() {
                        _selectedAnswer = choiceModel.choiceText;
                      });
                      // If you want instant advance instead of “wait for time”:
                      // _goToNextQuestion();
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
                ],
              ),
            ),

            // Win Streak Overlay
            if (_showStreak && _streak > 1)
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: _showStreak ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: Center(
                    child: AnimatedScale(
                      scale: 1.2,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.elasticOut,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          "🔥 $_streak in a row!",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            if (_showCountdown)
              CountdownOverlay(
                count: _countdown,
                total: widget.quiz.timerPerQuestion ?? 15,
              ),

            if (showGoMessage) const GoOverlay(),
          ],
        ),
      ),
    );
  }
}
