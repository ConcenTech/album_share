import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../immich/asset_grid/asset_grid_data_structure.dart';
import '../../models/preferences.dart';
import '../database/database_providers.dart';
import 'preferences_notifier.dart';

abstract class PreferencesProviders {
  static final service =
      StateNotifierProvider.autoDispose<PreferencesService, Preferences>(
    (ref) => PreferencesService(ref.watch(DatabaseProviders.service)),
  );

  static final theme = Provider.autoDispose<ThemeMode>(
    (ref) => ref.watch(service.select((p) => p.theme)),
  );

  static final groupBy = Provider.autoDispose<GroupAssetsBy>(
    (ref) => ref.watch(service.select((p) => p.groupBy)),
  );

  static final maxExtent = Provider.autoDispose<int>(
    (ref) => ref.watch(service.select((p) => p.maxExtent)),
  );

  static final shouldLoopVideo = Provider.autoDispose<bool>(
    (ref) => ref.watch(service.select((p) => p.loopVideos)),
  );

  static final syncFrequency = Provider.autoDispose<int>(
    (ref) => ref.watch(service.select((p) => p.syncFrequency)),
  );

  static final dynamicLayout = Provider.autoDispose<bool>(
    (ref) => ref.watch(service.select((p) => p.dynamicLayout)),
  );

  static final backgroundSync = Provider.autoDispose<bool?>(
      (ref) => ref.watch(service.select((p) => p.backgroundSync)));
}
