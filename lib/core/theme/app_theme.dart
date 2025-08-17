import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // For titles
      bodyLarge: TextStyle(fontSize: 14, color: Colors.black87), // General text
      bodyMedium: TextStyle(fontSize: 14, color: Colors.grey), // Secondary text
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // For buttons or emphasized text
    ),
    cardTheme: CardThemeData(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
      secondary: Colors.amber,
      error: Colors.red,
      surface: Colors.grey[300],
      onSurface: Colors.grey,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onError: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey[700],
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // For titles
      bodyLarge: TextStyle(fontSize: 14, color: Colors.white70), // General text
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white60), // Secondary text
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), // For buttons or emphasized text
    ),
    cardTheme: CardThemeData(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.grey[850],
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(
      secondary: Colors.amberAccent,
      error: Colors.redAccent,
      surface: Colors.grey[800],
      onSurface: Colors.white70,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
  );
}
