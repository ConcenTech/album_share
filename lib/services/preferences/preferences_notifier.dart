import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/preferences.dart';
import '../database/database_service.dart';

class PreferencesService extends StateNotifier<Preferences>{

  PreferencesService(this._db) : super(const Preferences());

  final DatabaseService _db;

  void setTheme(ThemeMode theme) {
    state = state.copyWith(theme: theme);
    _db.setPreferences(state);
  }

  void setSyncFrequency(int syncFrequency) {
    state = state.copyWith(syncFrequency: syncFrequency);
    _db.setPreferences(state);
  }
  
}