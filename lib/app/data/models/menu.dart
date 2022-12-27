import 'package:flutter/material.dart';

class DrawerMenuItem {
  int id;
  String title;
  IconData icon;
  String route;
  DrawerMenuItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
  });
}
