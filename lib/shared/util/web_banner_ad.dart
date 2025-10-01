import 'package:flutter/material.dart';

class WebBannerAd extends StatelessWidget {
  const WebBannerAd({
    super.key,
    this.adClient,
    this.adSlot,
    this.width = 320,
    this.height = 100,
  });

  final String? adClient;
  final String? adSlot;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    // On mobile/desktop, return nothing
    return const SizedBox.shrink();
  }
}
