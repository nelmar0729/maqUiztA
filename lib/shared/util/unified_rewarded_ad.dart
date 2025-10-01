import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'mobile_rewarded_ad.dart';
import 'web_rewarded_ad.dart';

class UnifiedRewardedAd {
  static void load() {
    if (!kIsWeb) {
      MobileRewardedAd.load();
    }
    // On web: no need to load, since it's just a dialog
  }

  static void show({
    required Function(int amount, String type) onRewardEarned,
    required VoidCallback onComplete,
  }) {
    if (kIsWeb) {
      WebRewardedAd.show(
        onRewardEarned: onRewardEarned, // already int in web mock
        onComplete: onComplete,
      );
    } else {
      MobileRewardedAd.show(
        onRewardEarned: (reward) {
          onRewardEarned(reward.amount.toInt(), reward.type); // ✅ enforce int
        },
        onComplete: onComplete,
      );
    }
  }
}
