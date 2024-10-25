import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:system_theme/system_theme.dart';

class AppTheme {
  static Future<void> ensureInitialized() async {
    SystemTheme.fallbackColor = Colors.purple;
    await SystemTheme.accentColor.load();
  }

  static Color systemThemeColour() {
    return SystemTheme.accentColor.accent;
  }

  static ThemeData base(Brightness brightness) {
    final base = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: systemThemeColour(),
        brightness: brightness,
      ),
    );

    return base.copyWith(
      appBarTheme: base.appBarTheme.copyWith(
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
      ),
    );
  }

  static ThemeData light() => base(Brightness.light);

  static ThemeData dark() => base(Brightness.dark);

  ThemeData themeFromBrightness(Brightness brightness) {
    return switch (brightness) {
      Brightness.light => light(),
      Brightness.dark => dark(),
    };
  }
}
