import 'package:flutter/material.dart';

class WebRewardedAd {
  static void show({
    required Function(int amount, String type) onRewardEarned,
    required VoidCallback onComplete,
  }) {
    // On mobile/desktop: skip showing anything, just complete
    onComplete();
  }
}
