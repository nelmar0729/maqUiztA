import 'package:flutter/material.dart';
import '/shared/text_styles.dart';

class GreetingHeader extends StatelessWidget {
  final String avatarUrl;
  final String name;

  const GreetingHeader({
    super.key,
    required this.avatarUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    // Choose avatar: if empty or only spaces, use asset
    final hasAvatar = avatarUrl.trim().isNotEmpty;

    // Choose name: if empty or only spaces, use "Student"
    final displayName = name.trim().isEmpty ? "Student" : name;

    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.grey.shade200,
          child: ClipOval(
            child: hasAvatar
                ? Image.network(
                    avatarUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // If loading from network fails, show asset image
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hi there,', style: AppTextStyles.titleLarge),
              Text(displayName, style: AppTextStyles.titleLarge),
            ],
          ),
        ),
      ],
    );
  }
}
