import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaper_fake_call/app/services/ads_helper.dart';

class WallpaperController extends GetxController {
  RxList<String> favoriteWallpapers = <String>[].obs;
}
