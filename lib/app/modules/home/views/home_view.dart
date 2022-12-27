import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../data/config/menu.dart';
import '../../../data/config/url.dart';
import '../../../routes/app_pages.dart';
import '../../../services/ads_helper.dart';
import '../../../services/launcher.dart';
import '../../../widgets/banner.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  InterstitialAd? interstitialAd;
  int numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    // initial admob
    initGoogleMobileAds();
    createInterstitialAd();
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            log('$ad loaded');
            interstitialAd = ad;
            numInterstitialLoadAttempts = 0;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('InterstitialAd failed to load: $error.');
            numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      log('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => log('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: buildHomeBody(),
      drawer: buildDrawerMenu(),
    );
  }

  // Initialize Google Mobile Ads SDK
  Future<InitializationStatus> initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  // home body
  Center buildHomeBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // wallapager
          ElevatedButton(
            onPressed: () {
              // goto wallpaper page
              showInterstitialAd();
              Get.toNamed(Routes.WALLPAPER);
            },
            child: const Text("Wallpaper"),
          ),

          // show banner ads
          const BannerAdsWidget(type: AdSize.mediumRectangle),

          // video call
          ElevatedButton(
            onPressed: () {
              // goto video call page
              showInterstitialAd();
              Get.toNamed(Routes.VIDEOCALL);
            },
            child: const Text("Video Call"),
          ),

          // more app
          ElevatedButton(
            onPressed: () {
              // goto more app page
              openUrl(url: moreAppUrl);
            },
            child: const Text("More Apps"),
          ),

          // rate app
          ElevatedButton(
            onPressed: () {
              // goto rate app page
              openUrl(url: rateAppUrl);
            },
            child: const Text("Rate App"),
          )
        ],
      ),
    );
  }

  // drawer memu
  Widget buildDrawerMenu() {
    return Drawer(
      child: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(menuItems[index].icon),
            title: Text(menuItems[index].title),
            onTap: () {
              // goto page
              Get.back();
              if (menuItems[index].route.startsWith("http")) {
                openUrl(url: menuItems[index].route);
              } else {
                // if choose wallpaper or videocall show interstitial ads
                if (menuItems[index].route.contains("wallpaper") || menuItems[index].route.contains("video")) {
                  showInterstitialAd();
                }
                Get.toNamed(menuItems[index].route);
              }
            },
          );
        },
      ),
    );
  }
}
