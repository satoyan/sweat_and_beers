import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweat_and_beers/app_routes.dart';
import 'package:sweat_and_beers/app_pages.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sweat_and_beers/core/bindings/app_binding.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';
import 'package:sweat_and_beers/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sweat and Beers',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.search,
      getPages: AppPages.routes,
      initialBinding: AppBinding(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ja', ''), // Japanese
      ],
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', ''),
    );
  }
}