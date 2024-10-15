import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_provider.dart';
import '../database/database_providers.dart';
import '../sync/background_sync_service.dart';
import 'auth_service.dart';

abstract class AuthProviders {
  static final service = Provider(
    (ref) => AuthService(
      ref.watch(DatabaseProviders.service),
      ref.watch(ApiProviders.service),
      BackgroundSyncService.instance,
    ),
  );

  static final endpoint = FutureProvider.autoDispose(
    (ref) => ref.watch(service).getEndpoint(),
  );

  /// A stream of changes for the current user.
  ///
  /// Null if not signed in.
  static final userStream = StreamProvider.autoDispose(
    (ref) => ref.watch(service).userChanges(),
  );
}
