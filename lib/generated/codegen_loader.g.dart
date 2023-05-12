// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "hi": "Hi!",
  "choose_your_lang": "Choose Your Language",
  "what_a_wonderful_day": "What a wonderful day!",
  "change_lang": "Change language",
  "change_pass": "Change Password",
  "dark_mode": "Dark Mode",
  "about_this_app": "About This App",
  "log_out": "Log Out"
};
static const Map<String,dynamic> ru = {
  "hi": "Привет!",
  "choose_your_lang": "Выберите ваш язык",
  "what_a_wonderful_day": "Какой прекрасный день",
  "change_lang": "Изменить язык",
  "change_pass": "Изменить пароль",
  "dark_mode": "Темный режим",
  "about_this_app": " Об этом приложении",
  "log_out": "Выйти"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "ru": ru};
}
