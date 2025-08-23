// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ChangePasswordScreen]
class ChangePasswordRoute extends PageRouteInfo<void> {
  const ChangePasswordRoute({List<PageRouteInfo>? children})
    : super(ChangePasswordRoute.name, initialChildren: children);

  static const String name = 'ChangePasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChangePasswordScreen();
    },
  );
}

/// generated route for
/// [EditProfileScreen]
class EditProfileRoute extends PageRouteInfo<void> {
  const EditProfileRoute({List<PageRouteInfo>? children})
    : super(EditProfileRoute.name, initialChildren: children);

  static const String name = 'EditProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EditProfileScreen();
    },
  );
}

/// generated route for
/// [EmailVerificationScreen]
class EmailVerificationRoute extends PageRouteInfo<EmailVerificationRouteArgs> {
  EmailVerificationRoute({
    Key? key,
    String email = 'your@email.com',
    List<PageRouteInfo>? children,
  }) : super(
         EmailVerificationRoute.name,
         args: EmailVerificationRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'EmailVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EmailVerificationRouteArgs>(
        orElse: () => const EmailVerificationRouteArgs(),
      );
      return EmailVerificationScreen(key: args.key, email: args.email);
    },
  );
}

class EmailVerificationRouteArgs {
  const EmailVerificationRouteArgs({this.key, this.email = 'your@email.com'});

  final Key? key;

  final String email;

  @override
  String toString() {
    return 'EmailVerificationRouteArgs{key: $key, email: $email}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EmailVerificationRouteArgs) return false;
    return key == other.key && email == other.email;
  }

  @override
  int get hashCode => key.hashCode ^ email.hashCode;
}

/// generated route for
/// [ForgotPasswordScreen]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [LeaderboardScreen]
class LeaderboardRoute extends PageRouteInfo<LeaderboardRouteArgs> {
  LeaderboardRoute({
    Key? key,
    required int quizId,
    List<PageRouteInfo>? children,
  }) : super(
         LeaderboardRoute.name,
         args: LeaderboardRouteArgs(key: key, quizId: quizId),
         initialChildren: children,
       );

  static const String name = 'LeaderboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LeaderboardRouteArgs>();
      return LeaderboardScreen(key: args.key, quizId: args.quizId);
    },
  );
}

class LeaderboardRouteArgs {
  const LeaderboardRouteArgs({this.key, required this.quizId});

  final Key? key;

  final int quizId;

  @override
  String toString() {
    return 'LeaderboardRouteArgs{key: $key, quizId: $quizId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LeaderboardRouteArgs) return false;
    return key == other.key && quizId == other.quizId;
  }

  @override
  int get hashCode => key.hashCode ^ quizId.hashCode;
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [NewEmailVerificationScreen]
class NewEmailVerificationRoute
    extends PageRouteInfo<NewEmailVerificationRouteArgs> {
  NewEmailVerificationRoute({
    Key? key,
    String email = 'your@email.com',
    List<PageRouteInfo>? children,
  }) : super(
         NewEmailVerificationRoute.name,
         args: NewEmailVerificationRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'NewEmailVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NewEmailVerificationRouteArgs>(
        orElse: () => const NewEmailVerificationRouteArgs(),
      );
      return NewEmailVerificationScreen(key: args.key, email: args.email);
    },
  );
}

class NewEmailVerificationRouteArgs {
  const NewEmailVerificationRouteArgs({
    this.key,
    this.email = 'your@email.com',
  });

  final Key? key;

  final String email;

  @override
  String toString() {
    return 'NewEmailVerificationRouteArgs{key: $key, email: $email}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NewEmailVerificationRouteArgs) return false;
    return key == other.key && email == other.email;
  }

  @override
  int get hashCode => key.hashCode ^ email.hashCode;
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [ProfileSetupScreen]
class ProfileSetupRoute extends PageRouteInfo<void> {
  const ProfileSetupRoute({List<PageRouteInfo>? children})
    : super(ProfileSetupRoute.name, initialChildren: children);

  static const String name = 'ProfileSetupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileSetupScreen();
    },
  );
}

/// generated route for
/// [QuizHistoryDetailScreen]
class QuizHistoryDetailRoute extends PageRouteInfo<QuizHistoryDetailRouteArgs> {
  QuizHistoryDetailRoute({
    Key? key,
    required QuizHistoryModel quiz,
    List<PageRouteInfo>? children,
  }) : super(
         QuizHistoryDetailRoute.name,
         args: QuizHistoryDetailRouteArgs(key: key, quiz: quiz),
         initialChildren: children,
       );

  static const String name = 'QuizHistoryDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuizHistoryDetailRouteArgs>();
      return QuizHistoryDetailScreen(key: args.key, quiz: args.quiz);
    },
  );
}

class QuizHistoryDetailRouteArgs {
  const QuizHistoryDetailRouteArgs({this.key, required this.quiz});

  final Key? key;

  final QuizHistoryModel quiz;

  @override
  String toString() {
    return 'QuizHistoryDetailRouteArgs{key: $key, quiz: $quiz}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! QuizHistoryDetailRouteArgs) return false;
    return key == other.key && quiz == other.quiz;
  }

  @override
  int get hashCode => key.hashCode ^ quiz.hashCode;
}

/// generated route for
/// [QuizHistoryScreen]
class QuizHistoryRoute extends PageRouteInfo<void> {
  const QuizHistoryRoute({List<PageRouteInfo>? children})
    : super(QuizHistoryRoute.name, initialChildren: children);

  static const String name = 'QuizHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QuizHistoryScreen();
    },
  );
}

/// generated route for
/// [QuizterNavScreen]
class QuizterNavRoute extends PageRouteInfo<void> {
  const QuizterNavRoute({List<PageRouteInfo>? children})
    : super(QuizterNavRoute.name, initialChildren: children);

  static const String name = 'QuizterNavRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QuizterNavScreen();
    },
  );
}

/// generated route for
/// [QuizzesScreen]
class QuizzesRoute extends PageRouteInfo<void> {
  const QuizzesRoute({List<PageRouteInfo>? children})
    : super(QuizzesRoute.name, initialChildren: children);

  static const String name = 'QuizzesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QuizzesScreen();
    },
  );
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [StartQuizScreen]
class StartQuizRoute extends PageRouteInfo<StartQuizRouteArgs> {
  StartQuizRoute({
    Key? key,
    required QuizModel quiz,
    List<PageRouteInfo>? children,
  }) : super(
         StartQuizRoute.name,
         args: StartQuizRouteArgs(key: key, quiz: quiz),
         initialChildren: children,
       );

  static const String name = 'StartQuizRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StartQuizRouteArgs>();
      return StartQuizScreen(key: args.key, quiz: args.quiz);
    },
  );
}

class StartQuizRouteArgs {
  const StartQuizRouteArgs({this.key, required this.quiz});

  final Key? key;

  final QuizModel quiz;

  @override
  String toString() {
    return 'StartQuizRouteArgs{key: $key, quiz: $quiz}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! StartQuizRouteArgs) return false;
    return key == other.key && quiz == other.quiz;
  }

  @override
  int get hashCode => key.hashCode ^ quiz.hashCode;
}

/// generated route for
/// [SubjectsScreen]
class SubjectsRoute extends PageRouteInfo<void> {
  const SubjectsRoute({List<PageRouteInfo>? children})
    : super(SubjectsRoute.name, initialChildren: children);

  static const String name = 'SubjectsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SubjectsScreen();
    },
  );
}
