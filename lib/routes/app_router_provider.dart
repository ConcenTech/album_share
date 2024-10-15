import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/main/pop_observer.dart';
import '../services/auth/auth_providers.dart';
import '../services/providers/app_bar_listener.dart';
import 'app_router.dart';

final appRouterProvider = Provider.autoDispose(
  (ref) => AppRouter(ref.watch(AuthProviders.service)),
);

final routerConfigProvider = Provider.autoDispose((ref) {
  final observers = [
    PopObserver(onPop: () {
      ref.read(appBarListenerProvider.notifier).show();
    }),
  ];
  final config =
      ref.watch(appRouterProvider).routerConfig(observers: observers);
  ref.onDispose(config.dispose);
  return config;
});
