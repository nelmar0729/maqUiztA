import '/shared/widgets/app_footer.dart';
import '/shared/util/mobile_banner_ad.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import '/core/routes/app_router.dart';
import '/shared/app_colors.dart';

@RoutePage()
class QuizterNavScreen extends StatelessWidget {
  const QuizterNavScreen({super.key});

  List<Widget> _navBarIcons(int activeIndex) => [
        // Home
        activeIndex == 0
            ? ShaderMask(
                shaderCallback: (Rect bounds) =>
                    AppColors.primaryGradient.createShader(bounds),
                child: const Icon(Iconsax.home_15, size: 30, color: Colors.white),
              )
            : const Icon(Iconsax.home_15, size: 30, color: Colors.white),

        // Subjects
        activeIndex == 1
            ? ShaderMask(
                shaderCallback: (Rect bounds) =>
                    AppColors.primaryGradient.createShader(bounds),
                child: const Icon(Iconsax.teacher5, size: 30, color: Colors.white),
              )
            : const Icon(Iconsax.teacher5, size: 30, color: Colors.white),

        // Quizzes
        activeIndex == 2
            ? ShaderMask(
                shaderCallback: (Rect bounds) =>
                    AppColors.primaryGradient.createShader(bounds),
                child: const Icon(Iconsax.task_square5, size: 30, color: Colors.white),
              )
            : const Icon(Iconsax.task_square5, size: 30, color: Colors.white),

        // Profile
        activeIndex == 3
            ? ShaderMask(
                shaderCallback: (Rect bounds) =>
                    AppColors.primaryGradient.createShader(bounds),
                child: const Icon(Icons.person, size: 30, color: Colors.white),
              )
            : const Icon(Icons.person, size: 30, color: Colors.white),
      ];

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        SubjectsRoute(),
        QuizzesRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),

          // 👇 main tab content + footer (no nav bar here)
          body: Column(
            children: [
              Expanded(child: child),
              const AppFooter(), // your footer
            ],
          ),

          // 👇 sticky ad + curved nav bar at bottom
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MobileBannerAd(), // ✅ banner ad always visible
              CurvedNavigationBar(
                backgroundColor: Colors.transparent,
                color: AppColors.primary,
                buttonBackgroundColor: Colors.white,
                height: 60,
                index: tabsRouter.activeIndex,
                animationDuration: const Duration(milliseconds: 350),
                animationCurve: Curves.easeInOut,
                items: _navBarIcons(tabsRouter.activeIndex),
                onTap: (index) => tabsRouter.setActiveIndex(index),
              ),
            ],
          ),
        );
      },
    );
  }
}
