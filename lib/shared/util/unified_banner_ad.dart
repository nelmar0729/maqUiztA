import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'web_banner_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class UnifiedBannerAd extends StatefulWidget {
  const UnifiedBannerAd({super.key});

  @override
  State<UnifiedBannerAd> createState() => _UnifiedBannerAdState();
}

class _UnifiedBannerAdState extends State<UnifiedBannerAd> {
  // 👇 Singleton BannerAd for mobile
  static BannerAd? _bannerAd;
  static bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb && _bannerAd == null && !_isLoading) {
      _isLoading = true;

      _bannerAd = BannerAd(
        adUnitId:
            "<YOUR_BANNER_AD_UNIT_ID>", // 👈 Replace with your real AdMob ID
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            debugPrint("✅ Mobile banner ad loaded");
            _isLoading = false;
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint("❌ Mobile banner failed: $error");
            ad.dispose();
            _bannerAd = null;
            _isLoading = false;
          },
        ),
      )..load();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // ✅ Web banner stays as-is
      return const WebBannerAd(
        adClient: 'ca-pub-1234567890123456',
        adSlot: '1234567890',
        width: 320,
        height: 100,
      );
    }

    // Mobile banner (singleton)
    if (_bannerAd == null) {
      return const SizedBox(height: 50); // placeholder during load
    }

    return SizedBox(
      height: _bannerAd!.size.height.toDouble(),
      width: _bannerAd!.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  @override
  void dispose() {
    // ❌ Don’t dispose banner here — keep alive across app
    super.dispose();
  }
}
