import 'package:flutter/material.dart';

import '../../app_colors.dart';

class DarkTheme {
  static final dark = ThemeData.dark().copyWith(
      //buttonColor: Colors.red,
      primaryColor: Colors.black54,
      primaryColorDark: Colors.black38,
      secondaryHeaderColor: AppColors.backgroundColorDark,
      iconTheme: const IconThemeData(color: Colors.white),
      bannerTheme: MaterialBannerThemeData(
        backgroundColor: Colors.amber.shade900.withAlpha(200),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.grey[900],
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[800],
      ),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.yellow),
      scaffoldBackgroundColor: Colors.grey[800],
      splashColor: Colors.grey[900]);
}
