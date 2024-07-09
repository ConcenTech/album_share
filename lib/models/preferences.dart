import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../immich/asset_grid/asset_grid_data_structure.dart';

part 'preferences.g.dart';

@collection
class Preferences {
  const Preferences({
    this.theme = ThemeMode.system,
    this.groupBy = GroupAssetsBy.day,
    this.enableHapticFeedback = true,
    this.syncFrequency = 300,
  });

  static const id = 0;

  final Id isarId = id;

  @enumerated
  final ThemeMode theme;

  /// How often in seconds to check for updates.
  final int syncFrequency;

  @enumerated
  final GroupAssetsBy groupBy;

  final bool enableHapticFeedback;

  Preferences copyWith({
    ThemeMode? theme,
    int? syncFrequency,
    GroupAssetsBy? groupBy,
    bool? enableHapticFeedback,
  }) {
    return Preferences(
      theme: theme ?? this.theme,
      syncFrequency: syncFrequency ?? this.syncFrequency,
      groupBy: groupBy ?? this.groupBy,
      enableHapticFeedback: enableHapticFeedback??this.enableHapticFeedback,
    );
  }
}
