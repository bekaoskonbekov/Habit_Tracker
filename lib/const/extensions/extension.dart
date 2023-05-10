import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  //get theme
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
