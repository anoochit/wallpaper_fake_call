import 'dart:io';

import 'package:wallpaper_fake_call/app/data/config/ads.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return androidAdsBanner;
    } else if (Platform.isIOS) {
      return iosAdsBanner;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return androidAdsInterstitial;
    } else if (Platform.isIOS) {
      return iosAdsInterstitial;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return androidAdsRewarded;
    } else if (Platform.isIOS) {
      return iosAdsRewarded;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
