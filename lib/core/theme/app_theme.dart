import 'package:flutter/material.dart';

class AppTheme {
  ThemeData lightTheme() => ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
      );

  ThemeData darkTheme() => ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
      );

  ThemeData themeFromBrightness(Brightness brightness) {
    return switch (brightness) {
      Brightness.light => lightTheme(),
      Brightness.dark => darkTheme(),
    };
  }
}
