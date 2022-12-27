import 'package:get/get.dart';
import 'package:wallpaper_fake_call/app/modules/wallpaper_view_item/controllers/wallpaper_view_item_controller.dart';

import '../controllers/wallpaper_controller.dart';

class WallpaperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WallpaperController>(
      () => WallpaperController(),
    );
    Get.lazyPut<WallpaperItemViewController>(
      () => WallpaperItemViewController(),
    );
  }
}
