import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/makecall/bindings/makecall_binding.dart';
import '../modules/makecall/views/makecall_view.dart';
import '../modules/videocall/bindings/videocall_binding.dart';
import '../modules/videocall/views/videocall_view.dart';
import '../modules/wallpaper/bindings/wallpaper_binding.dart';
import '../modules/wallpaper/views/wallpaper_view.dart';
import '../modules/wallpaper_view_item/bindings/wallpaper_view_item_binding.dart';
import '../modules/wallpaper_view_item/views/wallpaper_view_item.dart';

part 'app_routes.dart';

// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart
class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.VIDEOCALL,
      page: () => const VideocallView(),
      binding: VideocallBinding(),
    ),
    GetPage(
      name: _Paths.WALLPAPER,
      page: () => const WallpaperView(),
      binding: WallpaperBinding(),
    ),
    GetPage(
      name: _Paths.MAKECALL,
      page: () => const MakecallView(),
      binding: MakecallBinding(),
    ),
    GetPage(
      name: _Paths.WALLPAPER_VIEW,
      page: () => WallpaperItemView(),
      binding: WallpaperViewBinding(),
    ),
  ];
}
