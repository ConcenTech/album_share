import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../immich/asset_grid/asset_grid_data_structure.dart';
import '../../models/asset.dart';
import '../../models/asset_group.dart';
import '../../models/library_state.dart';
import '../api/api_provider.dart';
import '../database/database_providers.dart';
import '../files/file_service.dart';
import '../preferences/preferences_providers.dart';
import 'library_service.dart';

abstract class LibraryProviders {
  /// Listens to a list of all assets.
  static final state =
      StateNotifierProvider.autoDispose<LibraryService, LibraryState>((ref) {
    final db = ref.watch(DatabaseProviders.service);
    final api = ref.watch(ApiProviders.service);
    final syncFrequency =
        ref.watch(PreferencesProviders.service.select((p) => p.syncFrequency));

    return LibraryService(syncFrequency, api, db);
  });

  static final renderList = FutureProvider.autoDispose(
    (ref) {
      final libraryState = ref.watch(state);
      final groupBy = ref.watch(PreferencesProviders.groupBy);
      return libraryState.when(
        building: () => Future.value(RenderList([], null, [])),
        built: (assets) => RenderList.fromAssets(assets, groupBy),
      );
    },
  );

  /// Listens to a list of assets for the specified album.
  // static final assetsFor = Provider.autoDispose.family<List<Asset>, Album>(
  //   (ref, album) =>
  //       ref.watch(assets).where((a) => a.albumId == album.id).toList(),
  // );

  static final groupedAssets =
      FutureProvider.autoDispose.family<List<Asset>, AssetGroup>(
    (ref, group) => ref.watch(DatabaseProviders.service).assetsFromGroup(group),
  );

  static final asset = FutureProvider.autoDispose.family<Uint8List, Asset>(
    (ref, asset) => ref.watch(FileService.provider).fetch(asset),
  );

  static final assetPreview =
      FutureProvider.autoDispose.family<Uint8List, Asset>(
    (ref, asset) => ref.watch(FileService.provider).fetch(asset, preview: true),
  );
}
