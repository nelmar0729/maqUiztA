import 'package:flutter/foundation.dart' show kIsWeb, VoidCallback;
import 'mobile_interstitial_ad.dart';
import 'web_interstitial_ad.dart';

class UnifiedInterstitialAd {
  static void load() {
    if (!kIsWeb) {
      MobileInterstitialAd.load();
    }
  }

  static void show({required VoidCallback onComplete}) {
    if (kIsWeb) {
      WebInterstitialAd.show(onComplete: onComplete);
    } else {
      MobileInterstitialAd.show(onComplete: onComplete);
    }
  }
}
