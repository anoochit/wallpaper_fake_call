import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaper_fake_call/app/data/config/const.dart';
import 'package:wallpaper_fake_call/app/data/config/wallpaper.dart';
import 'package:wallpaper_fake_call/app/modules/wallpaper_view_item/controllers/wallpaper_view_item_controller.dart';
import 'package:wallpaper_fake_call/app/routes/app_pages.dart';
import 'package:wallpaper_fake_call/app/services/launcher.dart';
import 'package:wallpaper_fake_call/app/widgets/banner.dart';

import '../../../data/config/theme.dart';
import '../../../data/config/url.dart';
import '../controllers/wallpaper_controller.dart';

class WallpaperView extends StatefulWidget {
  const WallpaperView({super.key});

  @override
  State<WallpaperView> createState() => _WallpaperViewState();
}

class _WallpaperViewState extends State<WallpaperView> {
  late double width;
  int numAdsInsert = 0;
  int wallpaperIndex = 0;
  int stackIndex = 0;

  String title = "Wallpaper";

  WallpaperController wallpaperController = Get.find<WallpaperController>();

  @override
  void initState() {
    super.initState();
    // load favorite list form share preference
    loadFavoriteWallpaper();
  }

  void loadFavoriteWallpaper() {
    final favoriteWallpaper = sharedPreferences.getStringList("favorite") ?? [];
    wallpaperController.favoriteWallpapers.value = favoriteWallpaper;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    numAdsInsert = wallpaperItems.length ~/ 8;
    log('num ads insert total = $numAdsInsert');
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // menu
          Container(
            color: wallpapperTabMenuBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    // open wallpaper view
                    setState(() {
                      stackIndex = 0;
                      title = "Wallpaper";
                    });
                  },
                  child: const Text("Wallpaper"),
                ),
                TextButton(
                  onPressed: () {
                    // open favorite view
                    setState(() {
                      stackIndex = 1;
                      title = "Favorite";
                    });
                  },
                  child: const Text("Favorite"),
                ),
                TextButton(
                  onPressed: () {
                    // open more app url
                    openUrl(url: moreAppUrl);
                  },
                  child: const Text("More Apps"),
                ),
              ],
            ),
          ),

          // body
          Expanded(
            child: IndexedStack(
              index: stackIndex,
              children: [
                buildWallpaperGridView(),
                buildFavoriteGridView(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SizedBox(
        height: 60,
        child: BannerAdsWidget(
          type: AdSize.banner,
        ),
      ),
    );
  }

  Widget buildFavoriteGridView() {
    return GetBuilder<WallpaperController>(
        id: 'favorite',
        builder: (controller) {
          return SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: controller.favoriteWallpapers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                return WallpaperItemWidget(
                  wallpaperIndex: int.parse(controller.favoriteWallpapers[index]) + 1,
                );
              },
            ),
          );
        });
  }

  Widget buildWallpaperGridView() {
    return GetBuilder<WallpaperController>(
      builder: (controller) {
        // make a separate items
        wallpaperIndex = 0;
        return SingleChildScrollView(
          child: GridView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
            ),
            children: List.generate((wallpaperItems.length + numAdsInsert), (index) {
              if ((index != 0) && ((index % 8) == 7)) {
                return const AdsItemWidget();
              } else {
                wallpaperIndex = wallpaperIndex + 1;
                log('wallpaper view current index = ${wallpaperIndex - 1}');
                return WallpaperItemWidget(wallpaperIndex: wallpaperIndex);
              }
            }),
          ),
        );
      },
    );
  }
}

class AdsItemWidget extends StatelessWidget {
  const AdsItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        color: Colors.grey.shade100,
        child: const BannerAdsWidget(type: AdSize.mediumRectangle),
      ),
    );
  }
}

class WallpaperItemWidget extends StatelessWidget {
  WallpaperItemWidget({
    Key? key,
    required this.wallpaperIndex,
  }) : super(key: key);

  final int wallpaperIndex;

  final WallpaperItemViewController wallpaperItemViewController = Get.find<WallpaperItemViewController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          // view wallpaper
          wallpaperItemViewController.currentIndex.value = (wallpaperIndex - 1);
          log('wallpaper view tap index = ${wallpaperIndex - 1}');
          Get.toNamed(Routes.WALLPAPER_VIEW);
        },
        child: SizedBox(
          child: Image.asset(
            'assets/wallpapers/${wallpaperItems[(wallpaperIndex - 1)]}',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
