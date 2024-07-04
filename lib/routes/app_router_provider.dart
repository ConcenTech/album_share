import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth/auth_providers.dart';
import 'app_router.dart';

final appRouterProvider = Provider.autoDispose(
  (ref) => AppRouter(ref.watch(AuthProviders.service)),
);
