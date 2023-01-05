import 'package:get/get.dart';

import '../modules/makecall/controllers/makecall_controller.dart';
import '../modules/wallpaper_view_item/controllers/wallpaper_view_item_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(WallpaperItemViewController());
    Get.put(MakecallController());
  }
}
