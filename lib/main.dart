import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/constants.dart';
import 'core/components/window_titlebar.dart';
import 'routes/app_router_provider.dart';
import 'routes/platform_app.dart';
import 'screens/splash/init_fail_screen.dart';
import 'screens/splash/init_splash_screen.dart';
import 'services/preferences/preferences_providers.dart';
import 'services/providers/app_bar_listener.dart';
import 'services/providers/app_init_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );

  DesktopWindowTitlebar.openWindow();
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(appInitProvider).when(
          loading: () => const InitSplashScreen(),
          error: (error, _) => InitFailScreen(error),
          data: (data) {
            final appRouter = ref.watch(appRouterProvider);
            final appTheme = ref.watch(PreferencesProviders.theme);

            return PlatformApp.router(
              title: kAppTitle,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              mode: appTheme,
              observers: [
                MyNavObserver(onPop: () {
                  ref.read(appBarListenerProvider.notifier).show();
                }),
              ],
              routerConfig: appRouter.routerConfig,
            );
          },
        );
  }
}

class MyNavObserver extends NavigatorObserver {
  MyNavObserver({required this.onPop});
  final VoidCallback onPop;

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    SchedulerBinding.instance.addPostFrameCallback((_) => onPop());
  }
}
