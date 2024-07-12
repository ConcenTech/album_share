import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/preferences.dart';
import '../database/database_service.dart';

class PreferencesService extends StateNotifier<Preferences> {
  PreferencesService(this._db) : super(const Preferences());

  final DatabaseService _db;

  void set(Preferences preferences) {
    state = preferences;
    _db.setPreferences(preferences);
  }

  void setTheme(ThemeMode theme) {
    set(state.copyWith(theme: theme));
  }

  void setSyncFrequency(int syncFrequency) {
    set(state.copyWith(syncFrequency: syncFrequency));
  }

  void setMaxExtent(int maxExtent) {
    set(state.copyWith(maxExtent: maxExtent));
  }
}
