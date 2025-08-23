import 'package:flutter/material.dart';

enum AppLogoType { landscape, portrait }

class AppLogo extends StatelessWidget {
  final double size; // For portrait logo
  final bool showText;
  final AppLogoType type;

  const AppLogo({
    super.key,
    this.size = 120,
    this.showText = false,
    this.type = AppLogoType.portrait,
  });

  @override
  Widget build(BuildContext context) {
    // Choose the image and parameters based on type
    if (type == AppLogoType.landscape) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 400,
            height: 100,
            fit: BoxFit.contain,
          ),
          if (showText)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'MAqUiztA',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
            ),
        ],
      );
    } else {
      // Portrait (default)
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
          if (showText)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'MAqUiztA',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
            ),
        ],
      );
    }
  }
}
