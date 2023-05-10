import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:habit_tracer/const/styles/app_themes/dark_theme.dart';
import 'package:habit_tracer/const/styles/app_themes/light_theme.dart';
import 'package:habit_tracer/pages/auth/welcome_screen.dart';
import 'package:habit_tracer/widgets/custom_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'firebase/firebase_auth_helper.dart';
import 'firebase/firebase_options.dart';
import 'provider/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ru')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en'),
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      builder: (context, child) {
        return AdaptiveTheme(
          light: LightTheme.light,
          dark: DarkTheme.dark,
          initial: savedThemeMode ?? AdaptiveThemeMode.light,
          builder: (theme, darkTheme) => MaterialApp(
            darkTheme: darkTheme,
            theme: theme,
            showPerformanceOverlay: false,
            debugShowCheckedModeBanner: false,
            navigatorKey: Grock.navigationKey,
            scaffoldMessengerKey: Grock.scaffoldMessengerKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: StreamBuilder(
              stream: FirebaseAuthHelper.instance.getAuthChange,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomBottomBar();
                }
                return Welcome();
              },
            ),
          ),
        );
      },
    );
  }
}
