import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../core/utils/extension_methods.dart';
import '../../models/asset.dart';
import '../../models/library_state.dart';
import '../api/api_service.dart';
import '../database/database_service.dart';

final _logger = Logger('libraryService');

class LibraryService extends StateNotifier<LibraryState> {
  LibraryService(
    this._syncFrequency,
    this._api,
    this._db,
  ) : super(LibraryService._loadFromDb(_db)) {
    _init();
  }

  /// Checks the offline db for assets.
  /// If nothing found, this is likely the first load of the app.
  /// Check online before setting state to built.
  static LibraryState _loadFromDb(DatabaseService db) {
    final assets = db.allAssetsSync();
    if (assets.isEmpty) {
      return LibraryState.building();
    }
    return LibraryState.built(assets);
  }

  final int _syncFrequency;
  final ApiService _api;
  final DatabaseService _db;

  Timer? timer;

  void _init() async {
    await update();
    timer = Timer.periodic(
      _syncFrequency.seconds,
      (timer) {
        _logger.info('Checking for updates');
        update();
      },
    );
  }

  Future<void> update() async {
    late bool albumFetchFailed;

    final onlineAlbums = await _api.getSharedAlbums().then((albums) {
      albumFetchFailed = false;
      return albums;
    }).onError((ApiException e, _) {
      albumFetchFailed = true;
      return [];
    });

    /// Offline, use local
    if (albumFetchFailed) {
      _logger.info('Album fetch failed');
      if (state.isBuilding) {
        state = LibraryState.built(await _db.assets());
      }
      return;
    }

    final offlineAlbums = await _db.getAlbums();

    // Downloaded new assets.
    bool assetsUpdated = false;

    // Use a set to ensure duplicates are removed.
    final List<Asset> assets = [];
    for (var album in onlineAlbums) {
      final offlineIndex = offlineAlbums.indexOf(album);

      // If album isnt in offline db or album in offline db is out of date
      bool albumUpdated = false;

      if (offlineIndex == -1) {
        _logger.info('Album ${album.id} not found in offline db.');
        albumUpdated = true;
      } else if (offlineAlbums[offlineIndex].lastUpdatedMillis !=
          album.lastUpdatedMillis) {
        _logger.info('Album ${album.id} has been updated.');
        _logger.info(
            'Diff ${offlineAlbums[offlineIndex].lastUpdated} - ${album.lastUpdated}');
        albumUpdated = true;
      } else {
        _logger.info('No changes to album ${album.id}');
      }

      if (albumUpdated) {
        try {
          _logger.info('Fetching new assets for album ${album.id}');
          assets.merge(await _api.getAlbumAssets(album.id));
          assetsUpdated = true;
        } on ApiException catch (_) {
          _logger.info('Failed to reach endpoint, falling back to offline db');
          assets.merge(await _db.assets(album));
        }
      } else {
        assets.merge(await _db.assets(album));
      }
    }

    for (int i = 0; i < assets.length; i++) {
      final asset = assets.elementAt(i);
      final duplicates = assets.where((a) => a.id == asset.id);
      if (duplicates.length > 1) {
        throw 'Duplicate found for asset: $asset';
      }
    }

    // Update offline db if albums or assets have changed.
    if (!onlineAlbums.equals(offlineAlbums) || assetsUpdated) {
      _logger.info('Assets updated: $assetsUpdated');
      _logger.info(
          'Online matches offline: ${onlineAlbums.equals(offlineAlbums)}');
      _logger.info('Saving to db');
      _updateAssets(assets);
      await _db.setAlbums(onlineAlbums);
      await _db.setAssets(state.assets);
    }

    // Nothing online, nothing offline but all checks complete.
    if (state.isBuilding) {
      _updateAssets([]);
    }
  }

  void _updateAssets(List<Asset> assets) {
    state = LibraryState.built(assets.sorted());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
