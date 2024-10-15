import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import '../components/focus_remover.dart';
import '../utils/app_localisations.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

class PlatformApp extends StatelessWidget {
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
          scaffoldMessengerKey: snackbarKey,
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ScaffoldMessenger(
          key: snackbarKey,
          child: CupertinoApp.router(
            title: title,
            theme: CupertinoThemeData(
                brightness: switch (mode) {
              ThemeMode.system =>
                SchedulerBinding.instance.platformDispatcher.platformBrightness,
              ThemeMode.light => Brightness.light,
              ThemeMode.dark => Brightness.dark,
            }),
            routerConfig: routerConfig,
            builder: builder,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        );
    }
  }
}
