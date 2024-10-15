import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../immich/asset_grid/asset_grid_data_structure.dart';
import '../../models/album.dart';
import '../../models/asset.dart';
import '../../models/asset_group.dart';
import '../database/database_providers.dart';
import '../files/file_service.dart';
import '../preferences/preferences_providers.dart';

abstract class LibraryProviders {
  /// Listen to a stream of assets across all albums.
  static final assets = StreamProvider.autoDispose<List<Asset>>((ref) {
    final db = ref.watch(DatabaseProviders.service);
    return db.assetStream();
  });

  /// Listen to a stream of assets for the selected album.
  static final assetsFor =
      StreamProvider.autoDispose.family<List<Asset>, Album>((ref, album) {
    final db = ref.watch(DatabaseProviders.service);
    return db.assetStream(album);
  });

  static final renderList =
      Provider.autoDispose.family<RenderList, List<Asset>>(
    (ref, assets) {
      final groupBy = ref.watch(PreferencesProviders.groupBy);
      return RenderList.fromAssets(assets, groupBy);
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
  static final albums = StreamProvider.autoDispose((ref) {
    final db = ref.watch(DatabaseProviders.service);
    return db.albumsStream();
  });
}
