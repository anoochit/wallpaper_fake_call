import 'package:get/get.dart';

import '../controllers/wallpaper_view_item_controller.dart';

class WallpaperViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WallpaperItemViewController>(
      () => WallpaperItemViewController(),
    );
  }
}
