import 'package:flutter/material.dart';

class WebInterstitialAd {
  static void show({required VoidCallback onComplete}) {
    // On mobile/desktop: just continue without showing anything
    onComplete();
  }
}
