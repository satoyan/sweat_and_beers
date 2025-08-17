import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweat_and_beers/features/search/presentation/screens/search_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sweat and Beers',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SearchScreen(),
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
      locale: const Locale('ja', ''), // Default to Japanese
    );
  }
}

