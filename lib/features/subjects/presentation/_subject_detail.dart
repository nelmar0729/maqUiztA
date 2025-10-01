// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:maquizta/core/routes/app_router.dart';
import '/shared/app_colors.dart';
import '/shared/text_styles.dart';
import '/features/subjects/data/models/subject_model.dart';
import '/shared/widgets/snackbar.dart';
import '/shared/util/mobile_banner_ad.dart'; // ✅ our cross-platform banner

@RoutePage()
class SubjectDetailScreen extends StatelessWidget {
  final SubjectModel subject;
  const SubjectDetailScreen({super.key, required this.subject});

  void _showComingSoon(BuildContext context, String feature) {
    AppSnack.show(context, "$feature will be coming soon!", SnackType.info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          subject.subjectName,
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                // 📌 Subject Info
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      subject.subjectName,
                      style: AppTextStyles.titleMedium,
                    ),
                    subtitle: Text(
                      "Code: ${subject.subjectCode}\nInstructor: ${subject.instructor}",
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 📌 Quizzes
                _SectionCard(
                  title: "Quizzes",
                  icon: Icons.quiz,
                  color: Colors.blueAccent,
                  onTap: () {
                    context.router.push(SubjectQuizzesRoute(subject: subject));
                  },
                ),

                const SizedBox(height: 14),

                // 📌 Modules / Notes
                _SectionCard(
                  title: "Modules & Notes",
                  icon: Icons.menu_book,
                  color: Colors.green,
                     onTap: () {
                    context.router.push(SubjectModulesRoute(subject: subject));
                  },
                ),

                const SizedBox(height: 14),

                // 📌 Faculty Evaluation
                _SectionCard(
                  title: "Faculty Evaluation",
                  icon: Icons.rate_review,
                  color: Colors.orange,
                  onTap: () => _showComingSoon(context, "Faculty Evaluation"),
                ),
              ],
            ),
          ),

          // ✅ Unified Banner Ad (works for both Mobile & Web)
          const MobileBannerAd(),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
