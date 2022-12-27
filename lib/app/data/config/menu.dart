import 'package:flutter/material.dart';
import 'package:wallpaper_fake_call/app/data/config/url.dart';
import 'package:wallpaper_fake_call/app/data/models/menu.dart';
import 'package:wallpaper_fake_call/app/routes/app_pages.dart';

List<DrawerMenuItem> menuItems = [
  DrawerMenuItem(
    id: 1,
    title: "Home",
    icon: Icons.home,
    route: Routes.HOME,
  ),
  DrawerMenuItem(
    id: 2,
    title: "Wallpaper",
    icon: Icons.wallpaper,
    route: Routes.WALLPAPER,
  ),
  DrawerMenuItem(
    id: 3,
    title: "Video Call",
    icon: Icons.videocam,
    route: Routes.VIDEOCALL,
  ),
  DrawerMenuItem(
    id: 4,
    title: "More App",
    icon: Icons.space_dashboard,
    route: moreAppUrl,
  ),
  DrawerMenuItem(
    id: 5,
    title: "Rate App",
    icon: Icons.star,
    route: rateAppUrl,
  ),
  DrawerMenuItem(
    id: 6,
    title: "Privacy Policy",
    icon: Icons.shield,
    route: privacyPolicyUrl,
  ),
];
