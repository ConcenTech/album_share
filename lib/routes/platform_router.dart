import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/components/focus_remover.dart';

class PlatformApp extends StatelessWidget {
  const PlatformApp.builder({
    required this.title,
    required this.theme,
    required this.darkTheme,
    required this.mode,
    this.observers = const [],
    super.key,
  });

  final String title;

  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode mode;
  final List<NavigatorObserver> observers;

  @override
  Widget build(BuildContext context) {
    final routerConfig = GoRouter(routes: []);
    assert(!kIsWeb, 'The web platform is not supported by this application');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        return MaterialApp.router(
            title: title,
            theme: theme,
            darkTheme: darkTheme,
            themeMode: mode,
            routerConfig: routerConfig,
            builder: (_, child) => FocusRemover(child!));
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoApp.router(
            title: title,
            theme: CupertinoThemeData(
                brightness: switch (mode) {
              ThemeMode.system => null,
              ThemeMode.light => Brightness.light,
              ThemeMode.dark => Brightness.dark,
            }),
            routerConfig: routerConfig,
            builder: (_, child) => FocusRemover(child!));
    }
  }
}
