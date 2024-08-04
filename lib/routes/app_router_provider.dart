import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth/auth_providers.dart';
import 'app_router.dart';

final appRouterProvider = Provider.autoDispose(
  (ref) {
    return AppRouter(ref.watch(AuthProviders.service));
  },
);

final routerConfigProvider = Provider.autoDispose((ref) {
  final config = ref.watch(appRouterProvider).routerConfig;
  ref.onDispose(config.dispose);
  return config;
});
