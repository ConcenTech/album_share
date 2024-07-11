import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/extension_methods.dart';
import '../../models/asset.dart';
import '../../models/preferences.dart';
import '../api/api_service.dart';
import '../database/database_service.dart';

class LibraryService extends StateNotifier<List<Asset>> {
  LibraryService(
    this._prefs,
    this._api,
    this._db,
  ) : super(_db.allAssetsSync()) {
    _init();
  }

  final Preferences _prefs;
  final ApiService _api;
  final DatabaseService _db;

  late Timer timer;

  void _init() async {
    addListener((_) => _didUpdate());
    await update();
    timer = Timer.periodic(
      _prefs.syncFrequency.seconds,
      (timer) {
        print('Checking for updates');
        update();
      },
    );
  }

  Future<void> update() async {
    late bool albumFetchFailed;

    final onlineAlbums = await _api.getSharedAlbums().then((a) {
      albumFetchFailed = false;
      return a;
    }).onError((ApiException e, _) {
      albumFetchFailed = true;
      return [];
    });

    /// Offline, use local
    if (albumFetchFailed) {
      print('Album fetch failed');
      state = await _db.assets();
      return;
    }

    final offlineAlbums = await _db.getAlbums();

    // Downloaded new assets.
    bool assetsUpdated = false;

    final List<Asset> assets = [];
    for (var album in onlineAlbums) {
      final offlineIndex = offlineAlbums.indexOf(album);

      // If album isnt in offline db or album in offline db is out of date
      bool albumUpdated = false;

      //TODO: LOG
      if (offlineIndex == -1) {
        print('Album ${album.id} not found in offline db.');
        albumUpdated = true;
      } else if (offlineAlbums[offlineIndex].lastUpdatedMillis != album.lastUpdatedMillis) {
        print('Album ${album.id} has been updated.');
        print('Diff ${offlineAlbums[offlineIndex].lastUpdated} - ${album.lastUpdated}');
        albumUpdated = true;
      } else {
        print('No changes to album ${album.id}');
      }

      if (albumUpdated) {
        try {
          print('Fetching new assets for album ${album.id}');
          assets.addAll(await _api.getAlbumAssets(album.id));
          assetsUpdated = true;
        } on ApiException catch (_) {
          print('Failed to reach endpoint, falling back to offline db');
          assets.addAll(await _db.assets(album));
        }
      } else {
        assets.addAll(await _db.assets(album));
      }
    }

    // Update offline db if albums or assets have changed.
    if (!onlineAlbums.equals(offlineAlbums) || assetsUpdated) {
      print('Assets updated: $assetsUpdated');
      print('Online matches offline: ${onlineAlbums.equals(offlineAlbums)}');
      print('Saving to db');
      _updateAssets(assets);
      await _db.setAlbums(onlineAlbums);
      await _db.setAssets(state);
    }
  }

  void _updateAssets(List<Asset> assets){
    state = assets.sorted();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _didUpdate() {
    print('State updated');
  }
}
