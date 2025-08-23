import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';
import '/shared/theme.dart';
import '/shared/constants.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/di.dart';

void main() {
  tz.initializeTimeZones();
  setupLocator();
  final appRouter = AppRouter(); // ✅ Initialize here
  runApp(MyApp(appRouter: appRouter)); // ✅ Pass it down
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter.config(), // ✅ Use injected instance
    );
  }
}
