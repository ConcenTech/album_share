import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../immich/asset_grid/asset_grid_data_structure.dart';

part 'preferences.g.dart';

@collection
class Preferences {
  const Preferences({
    this.theme = ThemeMode.system,
    this.groupBy = GroupAssetsBy.auto,
    this.enableHapticFeedback = true,
    this.syncFrequency = 300,
    this.loadPreview = true,
    this.loadOriginal = false,
    this.maxExtent = 90,
    this.dynamicLayout = true,
    this.loopVideos = false,
    this.backgroundSync,
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

  final bool dynamicLayout;

  final bool loopVideos;

  /// If the background sync is enabled.
  ///
  /// null if not yet set by the user.
  final bool? backgroundSync;

  Preferences copyWith({
    ThemeMode? theme,
    int? syncFrequency,
    GroupAssetsBy? groupBy,
    bool? enableHapticFeedback,
    bool? loadPreview,
    bool? loadOriginal,
    int? maxExtent,
    bool? dynamicLayout,
    bool? loopVideos,
    bool? backgroundSync,
  }) {
    return Preferences(
      theme: theme ?? this.theme,
      syncFrequency: syncFrequency ?? this.syncFrequency,
      groupBy: groupBy ?? this.groupBy,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      loadPreview: loadPreview ?? this.loadPreview,
      loadOriginal: loadOriginal ?? this.loadOriginal,
      maxExtent: maxExtent ?? this.maxExtent,
      dynamicLayout: dynamicLayout ?? this.dynamicLayout,
      loopVideos: loopVideos ?? this.loopVideos,
      backgroundSync: backgroundSync ?? this.backgroundSync,
    );
  }
}
