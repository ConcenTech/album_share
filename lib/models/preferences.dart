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
    this.syncFrequency = 1800,
    this.loadPreview = true,
    this.loadOriginal = false,
    this.maxExtent = 60,
  });

  static const id = 0;

  final Id isarId = id;

  @enumerated
  final ThemeMode theme;

  /// How often in seconds to check for updates.
  final int syncFrequency;

  /// If true, loads a medium-resolution image instead of the original
  /// or thumbnail.
  ///
  /// Defaults to `true`
  final bool loadPreview;

  /// If true, loads the full-size original image.
  ///
  /// Will increase data usage.
  /// Defaults to `false`
  final bool loadOriginal;

  @enumerated
  final GroupAssetsBy groupBy;

  final bool enableHapticFeedback;

  /// The maximum size of thumbnails in the library view.
  final int maxExtent;

  Preferences copyWith({
    ThemeMode? theme,
    int? syncFrequency,
    GroupAssetsBy? groupBy,
    bool? enableHapticFeedback,
    bool? loadPreview,
    bool? loadOriginal,
    int? maxExtent,
  }) {
    return Preferences(
      theme: theme ?? this.theme,
      syncFrequency: syncFrequency ?? this.syncFrequency,
      groupBy: groupBy ?? this.groupBy,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      loadPreview: loadPreview ?? this.loadPreview,
      loadOriginal: loadOriginal ?? this.loadOriginal,
      maxExtent: maxExtent ?? this.maxExtent,
    );
  }
}
