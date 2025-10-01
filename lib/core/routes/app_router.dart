// lib/core/routes/app_router.dart
/*
Required Dependency
dependencies:
  auto_route: ^7.8.4
  auto_route_annotations: ^7.3.0

dev_dependencies:
  build_runner: ^2.4.8
  auto_route_generator: ^7.3.0

!!!! Important !!!!
In your terminal, run:
flutter pub run build_runner build --delete-conflicting-outputs
or
dart run build_runner build --delete-conflicting-outputs
dart run build_runner build --delete-conflicting-outputs


flutter clean
dart run build_runner clean

Read This for documentation
https://pub.dev/packages/auto_route#setup-and-usage
dart run build_runner build
*/
import 'package:get_it/get_it.dart';
import 'auth_guard.dart'; // Import your guard
import 'package:flutter/material.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

import 'package:auto_route/auto_route.dart';

/**Splash */
import '/features/splash/presentation/splash_screen.dart';
/**End Splash */

/**Auth */
import '/features/auth/presentation/login_screen.dart';
import '/features/auth/presentation/registerscreen.dart';
import '/features/auth/presentation/email_verification_screen.dart';
import '/features/auth/presentation/forgot_password_screen.dart';
import '/features/auth/presentation/program_setup.dart';
/**End Auth */

import '/features/mainNavigation/presentation/curved_navigation_bar.dart'; // The Widget

/**Home */
import '/features/home/presentation/homescreen.dart';
/**End Home */

/**subjects */
import '/features/subjects/presentation/subjects_screen.dart';
import '/features/subjects/presentation/_subject_detail.dart';
import '/features/subjects/data/models/subject_model.dart';
import '/features/subjects/presentation/_subject_quizzes.dart';
import '/features/subjects/presentation/_subject_modules_screen.dart';
/**End subjects */

/**Profile */
import '/features/profile/presentation/profile_screen.dart';
import '/features/profile/presentation/_change_password.dart';
import '/features/profile/presentation/_edit_profile_screen.dart';
import '/features/profile/presentation/_quiz_history_screen.dart';
import '/features/profile/presentation/_new_email_verification.dart';
import '/features/profile/presentation/_quiz_history_detail_screen.dart';
import '/features/profile/data/models/quiz_history_model.dart';
/**End Profile */

/**Quizzes */
import '/features/quizzes/presentation/quizzes_screen.dart';
import '/features/quizzes/presentation/_leaderboard_screen.dart';
import '/features/quizzes/presentation/_start_quiz_screen.dart';
import '/features/quizzes/data/models/quiz_model.dart';
/**End Quizzes */

/// This file defines all your app routes using auto_route.
/// Add new screens below by adding more AutoRoute entries.

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  // Create an instance of your guard (can be passed via constructor if needed)
  final _authGuard = AuthGuard(GetIt.I<LocalAuthDataSource>());
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: EmailVerificationRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: ChangePasswordRoute.page),
    AutoRoute(page: ProfileSetupRoute.page),

    // PROTECT YOUR MAIN NAV ROUTE WITH THE GUARD!
    AutoRoute(
      page: QuizterNavRoute.page,
      guards: [_authGuard], // <-- protect with AuthGuard!
      children: [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: SubjectsRoute.page),
        AutoRoute(page: QuizzesRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),

    AutoRoute(page: StartQuizRoute.page),
    AutoRoute(page: QuizHistoryDetailRoute.page),
    AutoRoute(page: QuizHistoryRoute.page),
    AutoRoute(page: EditProfileRoute.page),
    AutoRoute(page: LeaderboardRoute.page),
    AutoRoute(page: NewEmailVerificationRoute.page),
    AutoRoute(page: SubjectDetailRoute.page),
    AutoRoute(page: SubjectQuizzesRoute.page),
    AutoRoute(page: SubjectModulesRoute.page),

    // ...other routes!
  ];
}



/** Example usage
 * import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage() // <-- Required for auto_route 10.x
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Login Screen')),
    );
  }
}

 */

// ======== AutoRoute Navigation Quick Reference ========
/*
// 1. LOGIN FLOW
// Replace current route (Login) with Home after successful login
context.router.replace(const HomeRoute()); // use after login

// 2. LOGOUT FLOW
// Clear the navigation stack and return to Login screen (prevents back navigation)
context.router.replaceAll([const LoginRoute()]); // use after logout

// 3. NEXT PAGE (e.g. tap Next or navigate deeper)
// Push a new route on top of the stack
context.router.push(const DetailsRoute());

// 4. BACK NAVIGATION (AppBar arrow or system back button)
// Pops current page and returns to previous
context.router.pop();

// If you want to go back to a specific screen by route name (e.g. Home)
context.router.popUntilRouteWithName('HomeRoute');

// 5. POP-UP / MODAL DIALOG
// Define the modal route in AppRouter with type: RouteType.dialog:
//   AutoRoute(page: MyModalRoute.page, type: RouteType.dialog)
// Then, open it like a page:
context.router.push(const MyModalRoute());
// To close the modal:
context.router.pop();

// ======== End Quick Reference ========


// ==== AutoRoute Navigation Cheat Sheet ====
// (auto_route v10+)

// Access the router instance from a BuildContext
// - Use either one of these in your widgets:

AutoRouter.of(context);      // Old style
context.router;              // Preferred extension

// ------------- BASIC NAVIGATION --------------

// Navigate to a new page (pushes a route onto the stack)
//   User can go back
context.router.push(const BooksListRoute());

// Navigate to a route by path (useful for web/deep links)
context.router.pushPath('/books');

// Replace the current page (removes current from backstack)
context.router.replace(const BooksListRoute());
context.router.replacePath('/books');

// Replace the whole navigation stack with a new list of routes
//   (useful for logout, onboarding, etc.)
context.router.replaceAll([
  LoginRoute(),
]);

// Push multiple routes at once (creates a stack)
context.router.pushAll([
  BooksListRoute(),
  BookDetailsRoute(id: 1),
]);

// ------------- GOING BACK / POPPING -------------

// Go back to the previous page
context.router.pop();

// Try to pop, but only if possible (does nothing if at root)
context.router.maybePop();

// Go back to the root page (pops everything else)
context.router.popUntilRoot();

// Go back until a specific route name is found
context.router.popUntilRouteWithName('HomeRoute');

// ------------- ADVANCED -------------

// Remove the top-most page, even if it's the last one (force remove)
context.router.removeLast();

// Remove pages that satisfy a condition (like removing items from a list)
context.router.removeWhere((route) => route.settings.name == 'SomeRouteName');

// Push a modal/dialog route (if defined with RouteType.dialog)
context.router.push(const MyModalRoute());

// ------------- ALTERNATIVE SYNTAX --------------

// Same actions with context helpers:
context.pushRoute(const BooksListRoute());
context.replaceRoute(const BooksListRoute());
context.navigateTo(const BooksListRoute());
context.navigateToPath('/books');
context.back();
context.maybePop();
context.pop();

// ==== End Cheat Sheet ====
*/