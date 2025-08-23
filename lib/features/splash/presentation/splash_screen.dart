import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/core/routes/app_router.dart';
import '/core/di.dart'; // For locator
import '/shared/app_colors.dart';
import '/shared/widgets/app_logo.dart';
import '/shared/widgets/app_footer.dart'; // import this

// Import your AuthService from domain/services
import '/features/auth/domain/services/auth_service.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthService authService;

  @override
  void initState() {
    super.initState();
    authService = locator<AuthService>();
    _navigateBasedOnAuth();
  }

  Future<void> _navigateBasedOnAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    final result = await authService.checkAuthStatus();

    switch (result.status) {
      case AuthStatus.enrolled:
        context.router.replace(const QuizterNavRoute());
        break;
      case AuthStatus.notProfiled:
        context.router.replace(const ProfileSetupRoute());
        break;
      case AuthStatus.notLoggedIn:
        context.router.replace(const LoginRoute());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // 👈 pushes footer down
          children: [
            const SizedBox(height: 40), // spacer at top
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(),
                const SizedBox(height: 24),
                Text(
                  'Ma Quizta!',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),
                const CircularProgressIndicator(color: Colors.white),
              ],
            ),
            const AppFooter(), // 👈 now sits nicely at the bottom
          ],
        ),
      ),
    );
  }
}
