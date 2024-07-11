import 'dart:typed_data';

import 'package:album_share/immich/asset_grid/asset_grid_data_structure.dart';
import 'package:album_share/models/asset_group.dart';
import 'package:album_share/services/files/file_service.dart';
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

  static final renderList = FutureProvider.autoDispose(
    (ref) => RenderList.fromAssets(ref.watch(assets), GroupAssetsBy.day),
  );

  /// Listens to a list of assets for the specified album.
  static final assetsFor = Provider.autoDispose.family<List<Asset>, Album>(
    (ref, album) =>
        ref.watch(assets).where((a) => a.albumId == album.id).toList(),
  );

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
