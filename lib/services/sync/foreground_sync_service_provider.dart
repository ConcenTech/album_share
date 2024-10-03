import 'package:album_share/services/notifications/foreground_notifications_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_provider.dart';
import '../database/database_providers.dart';
import '../preferences/preferences_providers.dart';
import 'sync_service.dart';

final foregroundSyncServiceProvider =
    StateNotifierProvider.autoDispose<SyncService, SyncState>((ref) {
  final db = ref.watch(DatabaseProviders.service);
  final api = ref.watch(ApiProviders.service);
  final syncFrequency = ref.watch(PreferencesProviders.syncFrequency);
  final notifications = ForegroundNotificationsService();

  final service = SyncService(syncFrequency, api, db, notifications);

  service.start();

  return service;
});