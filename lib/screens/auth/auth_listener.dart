import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/auth/auth_providers.dart';
import '../../services/sync/foreground_sync_service_provider.dart';

class AuthListener extends ConsumerWidget {
  const AuthListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(AuthProviders.userStream);

    user.whenData((u) {
      if (u != null) {
        ref.watch(foregroundSyncServiceProvider);
      }
    });

    return child;
  }
}
