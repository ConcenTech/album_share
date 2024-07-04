import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'preferences.g.dart';

@collection
class Preferences {
  const Preferences({
    this.theme = ThemeMode.system,
    this.syncFrequency = 300,
  });

  static const id = 0;

  final Id isarId = id;

  @enumerated
  final ThemeMode theme;

  /// How often in seconds to check for updates.
  final int syncFrequency;

  Preferences copyWith({ThemeMode? theme, int? syncFrequency}) {
    return Preferences(
      theme: theme ?? this.theme,
      syncFrequency: syncFrequency ?? this.syncFrequency,
    );
  }
}
