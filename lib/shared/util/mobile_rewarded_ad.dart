import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants.dart';

class MobileRewardedAd {
  static RewardedAd? _rewardedAd;
  static bool _isLoading = false;

  /// Load a new rewarded ad
  static void load() {
    if (_isLoading || _rewardedAd != null) return;

    _isLoading = true;
    RewardedAd.load(
      adUnitId: AppConstants.rewardedId, // Replace with your real Ad ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          _rewardedAd = ad;
          debugPrint("✅ RewardedAd loaded");
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          _rewardedAd = null;
          debugPrint("❌ Failed to load RewardedAd: $error");
        },
      ),
    );
  }

  /// Show rewarded ad if available
  static void show({
    required Function(RewardItem reward) onRewardEarned,
    required VoidCallback onComplete,
  }) {
    if (_rewardedAd == null) {
      debugPrint("⚠️ No rewarded ad available, continuing...");
      onComplete();
      load(); // Preload for next use
      return;
    }

    final ad = _rewardedAd!;
    _rewardedAd = null; // Clear reference before showing

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        debugPrint("✅ RewardedAd dismissed");
        load(); // Preload next one
        onComplete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        debugPrint("❌ Failed to show RewardedAd: $error");
        load(); // Preload next one
        onComplete();
      },
    );

    ad.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint("🎁 User earned reward: ${reward.amount} ${reward.type}");
        onRewardEarned(reward);
      },
    );
  }
}
