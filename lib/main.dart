import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrouter/vrouter.dart';

import 'constants/constants.dart';
import 'core/components/focus_remover.dart';
import 'core/components/window_titlebar.dart';
import 'routes/app_router_provider.dart';
import 'screens/splash/init_fail_screen.dart';
import 'screens/splash/init_splash_screen.dart';
import 'services/preferences/preferences_providers.dart';
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

            return VRouter(
              title: kAppTitle,
              key: appRouter.vRouterKey,
              initialUrl: appRouter.initialRoute,
              routes: appRouter.routes,
              themeMode: appTheme,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              builder: (_, child) => FocusRemover(child),
            );
          },
        );
  }
}

