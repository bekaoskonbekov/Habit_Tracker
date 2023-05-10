import 'package:flutter/material.dart';

class LightTheme {
  //light theme
  static final light = ThemeData.light().copyWith(
      primaryColor: Colors.blue,
      primaryColorLight: Colors.blue,
      primaryColorDark: Colors.black,
      iconTheme: const IconThemeData(color: Colors.black54),
      bannerTheme: MaterialBannerThemeData(
        backgroundColor: Colors.amber.shade500,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.black,
      ),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.white),
      splashColor: Colors.white);
}
