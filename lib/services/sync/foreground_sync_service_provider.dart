import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_provider.dart';
import '../auth/auth_providers.dart';
import '../database/database_providers.dart';
import '../notifications/foreground_notifications_service.dart';
import '../preferences/preferences_providers.dart';
import 'sync_service.dart';

final foregroundSyncServiceProvider =
    StateNotifierProvider.autoDispose<SyncService, SyncState>((ref) {
  final db = ref.watch(DatabaseProviders.service);
  final api = ref.watch(ApiProviders.service);
  final notifications = ForegroundNotificationsService();
  // Refresh when user auth changes.
  final user = ref.watch(AuthProviders.userStream);

  final service = SyncService(api, db, notifications);

  user.whenData((user) {
    if (user != null) {
      final syncFrequency = ref.watch(PreferencesProviders.syncFrequency);

      service.start(syncFrequency);
    }
  });

  return service;
});
