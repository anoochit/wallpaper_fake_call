import 'dart:developer';
import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_fake_call/app/data/config/const.dart';
import 'package:wallpaper_fake_call/app/data/config/wallpaper.dart';
import 'package:wallpaper_fake_call/app/modules/wallpaper/controllers/wallpaper_controller.dart';
import 'package:wallpaper_fake_call/app/widgets/banner.dart';

import '../controllers/wallpaper_view_item_controller.dart';

class WallpaperItemView extends StatefulWidget {
  const WallpaperItemView({Key? key}) : super(key: key);

  @override
  State<WallpaperItemView> createState() => _WallpaperItemViewState();
}

class _WallpaperItemViewState extends State<WallpaperItemView>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    requestPermission();
  }

  requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    log(info);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WallpaperItemViewController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    if (controller.currentIndex.value > 0) {
                      controller.currentIndex.value--;
                    }
                    log('current index = ${controller.currentIndex.value}');
                    controller.update();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                IconButton(
                  onPressed: () {
                    if (controller.currentIndex.value <
                        (wallpaperItems.length - 1)) {
                      controller.currentIndex.value++;
                    }
                    log('current index = ${controller.currentIndex.value}');
                    controller.update();
                  },
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: wallpaperItems
                .map(
                  (index) => SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                      'assets/wallpapers/$index',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                )
                .toList(),
          ),
          bottomNavigationBar: const BannerAdsWidget(
            type: AdSize.banner,
          ),
          floatingActionButton: (GetPlatform.isAndroid)
              ? FloatingActionBubble(
                  items: <Bubble>[
                    Bubble(
                      title: "Lock & Home",
                      iconColor: Colors.white,
                      bubbleColor: Colors.blue,
                      icon: Icons.wallpaper,
                      titleStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                      onPress: () async {
                        // load file
                        final file = await rootBundle.load(
                            "assets/wallpapers/${wallpaperItems[controller.currentIndex.value]}");

                        // set wallpaper if Android able to set wallpaper
                        await setWallpaper(
                            controller, file, AsyncWallpaper.BOTH_SCREENS);
                      },
                    ),
                    Bubble(
                      title: "Home",
                      iconColor: Colors.white,
                      bubbleColor: Colors.blue,
                      icon: Icons.home,
                      titleStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                      onPress: () async {
                        // load file
                        final file = await rootBundle.load(
                            "assets/wallpapers/${wallpaperItems[controller.currentIndex.value]}");

                        // set wallpaper if Android able to set wallpaper
                        await setWallpaper(
                            controller, file, AsyncWallpaper.HOME_SCREEN);
                      },
                    ),
                    Bubble(
                      title: "Lock",
                      iconColor: Colors.white,
                      bubbleColor: Colors.blue,
                      icon: Icons.lock,
                      titleStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                      onPress: () async {
                        // load file
                        final file = await rootBundle.load(
                            "assets/wallpapers/${wallpaperItems[controller.currentIndex.value]}");

                        // set wallpaper if Android able to set wallpaper
                        await setWallpaper(
                            controller, file, AsyncWallpaper.LOCK_SCREEN);
                      },
                    ),
                    Bubble(
                      title: "Favorit",
                      iconColor: Colors.white,
                      bubbleColor: Colors.blue,
                      icon: Icons.star,
                      titleStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                      onPress: () {
                        WallpaperController wallpaperController =
                            Get.find<WallpaperController>();

                        final favoriteList =
                            sharedPreferences.getStringList("favorite") ?? [];

                        log('favorite list = ${favoriteList.length}');

                        if (favoriteList.isEmpty) {
                          favoriteList.add('${controller.currentIndex.value}');
                          sharedPreferences.setStringList(
                              "favorite", favoriteList);
                          wallpaperController.favoriteWallpapers.value =
                              favoriteList;
                          wallpaperController.update(['favorite']);
                          Get.snackbar('Info', 'Save to favorite');
                        } else {
                          log('${favoriteList.length}');

                          final exist = favoriteList.firstWhereOrNull(
                              (element) => (element ==
                                  '${controller.currentIndex.value}'));
                          if (exist == null) {
                            log('favorite item not exist, add to favorite');
                            favoriteList
                                .add('${controller.currentIndex.value}');
                            sharedPreferences.setStringList(
                                "favorite", favoriteList);
                            wallpaperController.favoriteWallpapers.value =
                                favoriteList;
                            wallpaperController.update(['favorite']);
                            Get.snackbar('Info', 'Save to favorite');
                          } else {
                            log('favorite item already exist');
                          }
                        }
                      },
                    ),
                  ],

                  // animation controller
                  animation: _animation,

                  // On pressed change animation state
                  onPress: () => _animationController.isCompleted
                      ? _animationController.reverse()
                      : _animationController.forward(),

                  // Floating Action button Icon color
                  iconColor: Colors.white,

                  // Flaoting Action button Icon
                  iconData: Icons.add,
                  backGroundColor: Colors.blue,
                )
              : FloatingActionButton(
                  onPressed: () async {
                    final file = await rootBundle.load(
                        "assets/wallpapers/${wallpaperItems[controller.currentIndex.value]}");

                    // save image to gallery
                    final result = await saveToGallery(file, controller);

                    if (result) {
                      Get.snackbar('Info', 'Save wallpaper image to gallery');
                    } else {
                      Get.snackbar(
                          'Info', 'cannot save wallpaper image to gallery');
                    }
                  },
                  child: const Icon(Icons.save),
                ),
        );
      },
    );
  }

  Future<void> setWallpaper(WallpaperItemViewController controller,
      ByteData file, int wallpaperLocation) async {
    if (GetPlatform.isAndroid) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      await File('${appDocDir.path}/wallpaper${controller.currentIndex.value}')
          .writeAsBytes(file.buffer.asUint8List());
      log('file path = ${appDocDir.path}/wallpaper${controller.currentIndex.value}');
      final wallpaperFile =
          '${appDocDir.path}/wallpaper${controller.currentIndex.value}';

      AsyncWallpaper.setWallpaperFromFile(
        filePath: wallpaperFile,
        wallpaperLocation: wallpaperLocation,
        goToHome: true,
      );

      Get.back();
    }
  }

  Future<dynamic> saveToGallery(
      ByteData file, WallpaperItemViewController controller) async {
    final result = await ImageGallerySaver.saveImage(file.buffer.asUint8List(),
        quality: 100, name: 'wallpaper${controller.currentIndex.value}');
    log('${result['filePath']}');
    return result;
  }
}
