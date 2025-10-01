import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '/shared/app_colors.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  Future<PackageInfo> _getInfo() => PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FutureBuilder<PackageInfo>(
        future: _getInfo(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink(); // nothing while loading
          }

          final info = snapshot.data!;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Version ${info.version} (${info.buildNumber})",
                style: const TextStyle(
                  color: AppColors.textOnSecondary,
                  fontSize: 9,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Developed by: R&N Techies",
                style: TextStyle(
                  color: AppColors.textOnSecondary,
                  fontSize: 9,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
