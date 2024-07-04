import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}
