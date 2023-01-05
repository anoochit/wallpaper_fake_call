import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const menuSpacing = MainAxisAlignment.spaceEvenly;
const wallpapperTabMenuBackgroundColor = Colors.red;

final themeData = ThemeData(
  // color scheme for whole app
  primarySwatch: Colors.amber,

  // background for canvas
  canvasColor: Colors.green,

  // color for button background
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      // button background
      backgroundColor: MaterialStatePropertyAll(Colors.amber),
      // button text color
      foregroundColor: MaterialStatePropertyAll(Colors.black),
    ),
  ),

  // drawer
  drawerTheme: const DrawerThemeData(
    // drawer background color
    backgroundColor: Colors.yellow,
  ),

  // appbar theme
  appBarTheme: const AppBarTheme(
    // background color
    backgroundColor: Colors.orange,
    // text and icon color
    foregroundColor: Colors.green,
  ),

  // app font style
  textTheme: GoogleFonts.pacificoTextTheme(),
);
