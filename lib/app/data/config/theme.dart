import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const menuSpacing = MainAxisAlignment.spaceEvenly;
const wallpapperTabMenuBackgroundColor = Colors.white;

final themeData = ThemeData(
  // color scheme for whole app
  primarySwatch: Colors.blue,

  // background for canvas
  canvasColor: Colors.white,

  // color for button background
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      // button background
      backgroundColor: MaterialStatePropertyAll(Colors.blue),
      // button text color
      foregroundColor: MaterialStatePropertyAll(Colors.white),
    ),
  ),

  // drawer
  drawerTheme: const DrawerThemeData(
    // drawer background color
    backgroundColor: Colors.white,
  ),

  // appbar theme
  appBarTheme: const AppBarTheme(
    // background color
    backgroundColor: Colors.blue,
    // text and icon color
    foregroundColor: Colors.white,
  ),

  // app font style
  textTheme: GoogleFonts.robotoTextTheme(),
);
