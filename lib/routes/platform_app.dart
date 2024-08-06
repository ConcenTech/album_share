import 'package:album_share/core/utils/app_localisations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/components/focus_remover.dart';

class _PlatformApp extends StatelessWidget {
  const _PlatformApp({
    required this.child,
    required this.localizationsDelegates,
    required this.supportedLocales,
    super.key,
  });

  final Widget child;

  final Iterable<LocalizationsDelegate> localizationsDelegates;
  final Iterable<Locale> supportedLocales;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        return MaterialApp(
          home: child,
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoApp(
          home: child,
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
        );
    }
  }
}

class PlatformApp extends StatelessWidget {
  static base({
    required Widget child,
    required Iterable<LocalizationsDelegate> localizationsDelegates,
    required Iterable<Locale> supportedLocales,
    Key? key,
  }) =>
      _PlatformApp(
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        child: child,
        key: key,
      );

  const PlatformApp.router({
    required this.title,
    required this.theme,
    required this.darkTheme,
    required this.mode,
    this.observers = const [],
    this.routerConfig,
    this.navigatorKey,
    super.key,
  }) : child = null;

  const PlatformApp.splash({
    required this.title,
    required Widget this.child,
    required this.theme,
    required this.darkTheme,
    required this.mode,
    super.key,
  })  : observers = const [],
        routerConfig = null,
        navigatorKey = null;

  final String title;

  final GlobalKey<NavigatorState>? navigatorKey;

  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode mode;
  final List<NavigatorObserver> observers;
  final RouterConfig<Object>? routerConfig;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    assert(!kIsWeb, 'The web platform is not supported by this application');

    final routerConfig = this.routerConfig ?? GoRouter(routes: []);
    Widget builder(_, Widget? child) => this.child ?? FocusRemover(child!);

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
          builder: builder,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
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
          builder: builder,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
    }
  }
}
