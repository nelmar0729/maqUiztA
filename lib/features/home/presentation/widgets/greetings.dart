// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '/shared/text_styles.dart';
import '/shared/app_colors.dart';

class GreetingHeader extends StatelessWidget {
  final String avatarUrl;
  final String name;

  const GreetingHeader({
    super.key,
    required this.avatarUrl,
    required this.name,
  });

  /// Returns greeting based on the time of day
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "☀️ Good morning,";
    if (hour < 18) return "🌤️ Good afternoon,";
    return "🌙 Good evening,";
  }

  @override
  Widget build(BuildContext context) {
    // Check avatar
    final hasAvatar = avatarUrl.trim().isNotEmpty;

    // Fallback name
    final displayName = name.trim().isEmpty ? "Student" : name;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent], // UA-inspired gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: hasAvatar
                  ? Image.network(
                      avatarUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/user.png',
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/user.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // Greeting text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  displayName,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // Example gamification streak
                // Row(
                //   children: const [
                //     Icon(
                //       Icons.local_fire_department,
                //       color: Colors.yellow,
                //       size: 18,
                //     ),
                //     SizedBox(width: 4),
                //     Text(
                //       "3-day streak!",
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ],
                // ),
            
              ],
            ),
          ),
        ],
      ),
    );
  }
}
