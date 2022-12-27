import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_fake_call/app/data/config/theme.dart';
import 'package:wallpaper_fake_call/app/routes/root_binding.dart';

import 'app/data/config/const.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init share preference
  sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    GetMaterialApp(
      title: "Wallpaper & Fake Call",
      theme: themeData,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: RootBinding(),
    ),
  );
}
