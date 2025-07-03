import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'generated/l10n/app_localizations.dart';
import 'screens/splash_native.dart';
import 'theme/theme_controller.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = ThemeController();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.themeMode,
      builder: (context, themeMode, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Agenda Pessoal',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        supportedLocales: const [
          Locale('pt'),
          Locale('en'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: const SplashNative(),
      ),
    );
  }
}
