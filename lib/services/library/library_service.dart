import 'dart:async';

import 'package:album_share/models/asset_group.dart';
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
  ) : super(const []) {
    _init();
  }

  final Preferences _prefs;
  final ApiService _api;
  final DatabaseService _db;

  late Timer timer;

  void _init() {
    timer = Timer.periodic(
      _prefs.syncFrequency.seconds,
      (timer) => update(),
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
      } else if (offlineAlbums[offlineIndex].lastUpdated != album.lastUpdated) {
        print('Album ${album.id} has been updated.');
        albumUpdated = true;
      } else {
        print('No changes to album ${album.id}');
      }

      if (albumUpdated) {
        try {
          print('Fetching new assets');
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

    state = assets;

    // Update offline db if albums or assets have changed.
    if (onlineAlbums != offlineAlbums || assetsUpdated) {
      print('Saving to db');
      await _db.setAlbums(onlineAlbums);
      await _db.setAssets(state);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
