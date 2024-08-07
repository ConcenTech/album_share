import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../routes/app_router_provider.dart';
import '../../screens/splash/init_fail_screen.dart';
import '../../screens/splash/init_splash_screen.dart';
import '../../services/preferences/preferences_providers.dart';
import '../../services/providers/app_bar_listener.dart';
import '../../services/providers/app_init_provider.dart';
import '../theme/app_theme.dart';
import '../utils/app_localisations.dart';
import 'platform_app.dart';
import 'pop_observer.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
