import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import 'core/components/app_window/app_window.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_localisations.dart';
import 'routes/app_router_provider.dart';
import 'routes/platform_app.dart';
import 'screens/splash/init_fail_screen.dart';
import 'screens/splash/init_splash_screen.dart';
import 'services/preferences/preferences_providers.dart';
import 'services/providers/app_bar_listener.dart';
import 'services/providers/app_init_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  VideoPlayer.ensureInitialized();

  runApp(
    const ProviderScope(
      child: LocaleScope(
        app: MainApp(),
      ),
    ),
  );

  AppWindow.setWindow();
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = AppLocalizations.of(context);
    if (locale == null) {
      print('Locale not found in current context :(');
    } else {
      print('Locale was found in current context :)');
    }
    return ref.watch(appInitProvider).when(
          loading: () => const InitSplashScreen(),
          error: (error, _) => InitFailScreen(error),
          data: (data) {
            final navigatorKey =
                ref.watch(appRouterProvider.select((r) => r.navigatorKey));
            final routerConfig = ref.watch(routerConfigProvider);
            final themeMode = ref.watch(PreferencesProviders.theme);

            return PlatformApp.router(
              title: AppLocalizations.of(context)!.appTitle,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              mode: themeMode,
              observers: [
                PopObserver(onPop: () {
                  ref.read(appBarListenerProvider.notifier).show();
                }),
              ],
              routerConfig: routerConfig,
              navigatorKey: navigatorKey,
            );
          },
        );
  }
}

class LocaleScope extends StatelessWidget {
  const LocaleScope({
    required this.app,
    super.key,
  });

  final MainApp app;

  @override
  Widget build(BuildContext context) {
    return PlatformApp.base(
      child: app,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

class PopObserver extends NavigatorObserver {
  PopObserver({required this.onPop});
  final VoidCallback onPop;

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    SchedulerBinding.instance.addPostFrameCallback((_) => onPop());
  }
}
