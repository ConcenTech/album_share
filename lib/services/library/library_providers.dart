import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/album.dart';
import '../../models/asset.dart';
import '../api/api_provider.dart';
import '../database/database_providers.dart';
import '../preferences/preferences_providers.dart';
import 'library_service.dart';

abstract class LibraryProviders {
  /// Listens to a list of all assets.
  static final assets =
      StateNotifierProvider.autoDispose<LibraryService, List<Asset>>((ref) {
    final db = ref.watch(DatabaseProviders.service);
    final api = ref.watch(ApiProviders.service);
    final prefs = ref.watch(PreferencesProviders.service);

    return LibraryService(prefs, api, db);
  });

  /// Listens to a list of assets for the specified album.
  static final assetsFor = Provider.autoDispose.family<List<Asset>, Album>(
    (ref, album) =>
        ref.watch(assets).where((a) => a.albumId == album.id).toList(),
  );
}
