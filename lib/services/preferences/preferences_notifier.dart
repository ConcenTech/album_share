import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../immich/asset_grid/asset_grid_data_structure.dart';
import '../../models/preferences.dart';
import '../database/database_service.dart';

class PreferencesService extends StateNotifier<Preferences> {
  PreferencesService(this._db) : super(const Preferences()) {
    _init();
  }

  final DatabaseService _db;

  void _init() async {
    final prefs = await _db.getPreferences();
    if (prefs != null) {
      state = prefs;
    }
  }

  void set(Preferences preferences) {
    state = preferences;
    _db.setPreferences(preferences);
  }

  void setValue(
      {bool? dynamicLayout,
      bool? enableHapticFeedback,
      GroupAssetsBy? groupBy,
      bool? loadOriginal,
      bool? loadPreview,
      ThemeMode? theme,
      int? syncFrequency,
      int? maxExtent,
      bool? loopVideos,
      bool? backgroundSync}) {
    set(state.copyWith(
      dynamicLayout: dynamicLayout,
      enableHapticFeedback: enableHapticFeedback,
      groupBy: groupBy,
      loadOriginal: loadOriginal,
      loadPreview: loadPreview,
      maxExtent: maxExtent,
      syncFrequency: syncFrequency,
      theme: theme,
      loopVideos: loopVideos,
      backgroundSync: backgroundSync,
    ));
  }
}
