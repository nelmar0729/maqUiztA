import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '/shared/constants.dart';

class MobileBannerAd extends StatefulWidget {
  const MobileBannerAd({super.key});

  @override
  State<MobileBannerAd> createState() => _MobileBannerAdState();
}

class _MobileBannerAdState extends State<MobileBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // Simple capped retry
  int _retryCount = 0;
  static const int _maxRetries = 3;

  // Reserve at least 50 logical pixels (standard banner height)

  @override
  void initState() {
    super.initState();
    _createBanner();
  }

  void _createBanner() {
    _bannerAd?.dispose();
    _isLoaded = false;

    // NOTE: If you want adaptive instead of fixed 320x50:
    // - Keep a fixed height in the layout while loading.
    // - Then build BannerAd with an adaptive AdSize. (See comment at bottom.)

    final ad = BannerAd(
      adUnitId: AppConstants.bannerId,
      size: AdSize.banner, // fixed 320x50; switch to adaptive if desired
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("✅ Banner loaded");
          if (!mounted) return;
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
            _retryCount = 0; // reset on success
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("❌ Banner failed to load: $error");
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _isLoaded = false;
            _bannerAd = null;
          });

          // retry with simple backoff
          if (_retryCount < _maxRetries) {
            _retryCount++;
            final delayMs =
                math.pow(2, _retryCount).toInt() * 500; // 0.5s,1s,2s,4s...
            Future.delayed(Duration(milliseconds: delayMs), () {
              if (mounted) _createBanner();
            });
          }
        },
      ),
    )..load();

    _bannerAd = ad;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: (_isLoaded && _bannerAd != null)
          ? SafeArea(
              child: Center(
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

/*
👉 If/when you want adaptive:
- Call this AFTER you have a BuildContext (e.g., in didChangeDependencies once), then:
final AnchoredAdaptiveBannerAdSize? adaptiveSize =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(context);
if (adaptiveSize == null) return; // fallback to AdSize.banner

_bannerAd = BannerAd(
  adUnitId: AppConstants.bannerId,
  size: adaptiveSize,
  request: const AdRequest(),
  listener: ...
)..load();

- Use adaptiveSize.width/height for the container size as above.
*/
