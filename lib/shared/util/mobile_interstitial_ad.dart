import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants.dart';

class MobileInterstitialAd {
  static InterstitialAd? _interstitialAd;
  static bool _isLoading = false;

  /// Load a new ad (if not already loading or available)
  static void load() {
    if (_isLoading || _interstitialAd != null) return;

    _isLoading = true;
    InterstitialAd.load(
      adUnitId: AppConstants.interstitialId, // Replace with your real Ad ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          _interstitialAd = ad;
          debugPrint("✅ Interstitial loaded");
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          _interstitialAd = null;
          debugPrint("❌ Interstitial failed to load: $error");
        },
      ),
    );
  }

  /// Show ad if loaded, otherwise call onComplete immediately
  static void show({required VoidCallback onComplete}) {
    if (_interstitialAd == null) {
      debugPrint("⚠️ No interstitial available, continuing...");
      onComplete();
      load(); // Try to load for next time
      return;
    }

    // 🔑 Use local copy and clear the static reference *before* showing
    final ad = _interstitialAd!;
    _interstitialAd = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        debugPrint("✅ Interstitial dismissed");
        load(); // Preload next one
        onComplete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        debugPrint("❌ Failed to show interstitial: $error");
        load(); // Preload next one
        onComplete();
      },
    );

    ad.show();
  }
}
