import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../core/utils/app_localisations.dart';
import '../../core/utils/extension_methods.dart';
import '../../models/activity.dart';
import '../../models/activity_count.dart';
import '../../models/album.dart';
import '../../models/asset.dart';
import '../../models/asset_count.dart';
import '../../models/user_detail.dart';
import '../api/api_service.dart';
import '../database/database_service.dart';
import '../notifications/notifications_service.dart';

class SyncService extends StateNotifier<SyncState> {
  SyncService(
    this._api,
    this._db,
    this._notifications,
  ) : super(_getInitialState(_db));

  final ApiService _api;
  final DatabaseService _db;
  final NotificationsService _notifications;

  final _logger = Logger('SyncService');

  Timer? _timer;

  static SyncState _getInitialState(DatabaseService db) {
    final haveAssets = db.haveAssetsSync();
    return SyncState(!haveAssets);
  }

  void start(int syncFrequency) async {
    _logger.info('Starting');
    await update();
    _timer = Timer.periodic(
      syncFrequency.seconds,
      (_) {
        _logger.info('Checking for updates');
        unawaited(update());
      },
    );
  }

  Future<void> update() async {
    state = state.started();
    final albums = await _syncAlbums();
    state = state.assetSyncComplete();
    await _syncActivity(albums);
    state = state.activitySyncComplete();
    state = state.syncComplete();
  }

  Future<List<Album>> _syncAlbums() async {
    ({Object? error, StackTrace stack})? albumFetchFailure;

    final onlineAlbums = await _api.getSharedAlbums().then((albums) {
      return albums;
    }).onError((error, stack) {
      albumFetchFailure = (error: error, stack: stack);
      return [];
    });

    final offlineAlbums = await _db.allAlbums();

    // Client offline, use local only
    if (albumFetchFailure != null) {
      _logger.warning(
        'Album fetch failed',
        albumFetchFailure?.error,
        albumFetchFailure?.stack,
      );
      return offlineAlbums;
    }

    // All assets downloaded from server.
    final List<Asset> assets = [];
    // Assets downloaded from server not found in db.
    final List<Asset> newAssets = [];
    // If offline assets differs to online assets.
    bool assetsUpdated = false;

    for (Album album in onlineAlbums) {
      final offlineIndex = offlineAlbums.indexOf(album);

      bool albumUpdated;
      // If album is not in offline db
      if (offlineIndex == -1) {
        _logger.info('Album ${album.id} not found in offline db.');
        albumUpdated = true;
      }
      // Or album in offline db is out of date.
      else if (offlineAlbums[offlineIndex].lastUpdatedMillis !=
          album.lastUpdatedMillis) {
        _logger.info('Album ${album.id} has been updated.');
        albumUpdated = true;
      }
      // Otherwise album is up to date
      else {
        _logger.info('No changes to album ${album.id}');
        albumUpdated = false;
      }

      final offlineAssets = await _db.assets(album);
      final onlineAssets = await _api.getAlbumAssets(album);

      if (!onlineAssets.equals(offlineAssets)) {
        assetsUpdated = true;
      }

      if (albumUpdated) {
        try {
          _logger.info('Fetching new assets.');

          assets.merge(onlineAssets);
          newAssets.merge(onlineAssets.listWhere((asset) {
            if (state.firstRun) {
              final now = DateTime.now();
              return now.difference(asset.createdAt).inDays < 1;
            }
            return !offlineAssets.contains(asset);
          }));
        } on ApiException {
          _logger.warning('Failed to update assets for album.');
          assets.merge(offlineAssets);
        }
      } else {
        assets.merge(offlineAssets);
      }
    }

    if (newAssets.isNotEmpty || assetsUpdated) {
      _logger.info('Assets updated, saving to offline DB.');
      // Send notification.
      _notifyAssets(newAssets, _createUserMap(onlineAlbums));
      // Save changes
      await _db.setAlbums(onlineAlbums);
      await _db.setAssets(assets.sorted());
    }

    // Return albums to allow checking for activity.
    return onlineAlbums;
  }

  /// Returns a map of users across all albums.
  ///
  /// Key is the user's id, value is the user's name.
  Map<String, String> _createUserMap(List<Album> albums) {
    Map<String, String> userMap = {};
    for (Album album in albums) {
      for (UserDetail user in album.users) {
        userMap[user.id] = user.name;
      }
    }
    return userMap;
  }

  void _notifyAssets(List<Asset> assets, Map<String, String> userMap) async {
    if (assets.isEmpty) {
      return;
    }

    final currentUser = await _db.getUser();

    // Key: asset owner name
    Map<String, AssetCount> map = {};
    for (Asset asset in assets) {
      // Don;t notify if uploaded by current user.
      if (asset.ownerId == currentUser?.id) {
        continue;
      }

      final name = userMap[asset.ownerId] ?? 'unknown';
      final count = map[name] ?? AssetCount();

      switch (asset.type) {
        case AssetType.image:
          count.photos++;
          break;
        case AssetType.video:
          count.videos++;
          break;
        default:
          count.others++;
          break;
      }
    }

    if (map.isEmpty) {
      return;
    }

    final buf = StringBuffer();
    final locale = AppLocale.instance.current;

    for (var entry in map.entries) {
      entry.value.describe(buf, entry.key, locale);
    }

    await _notifications.assets(
      title: locale.newAssetsNotification,
      content: buf.toString(),
      assets: assets,
    );
  }

  Future<void> _syncActivity(List<Album> albums) async {
    final List<Activity> activity = [];
    List<Activity> newActivity = [];

    for (final album in albums) {
      await _getAlbumActivity(album, activity, newActivity, state.firstRun);
    }

    if (newActivity.isNotEmpty) {
      _logger.info('Sending activity notification');
      _notifyActivity(newActivity);
    }

    await _db.setActivity(activity);
  }

  Future<void> _getAlbumActivity(
    Album album,
    List<Activity> activity,
    List<Activity> newActivity,
    bool firstRun,
  ) async {
    _logger.info('Fetching activity for album ${album.id}');
    late final bool activityFetchFailed;

    final onlineActivity = await _api.getActivity(album).then((activity) {
      activityFetchFailed = false;
      return activity;
    }).onError((e, s) {
      _logger.warning('Activity fetch failed', e, s);
      activityFetchFailed = true;
      return const [];
    });

    final offlineActivity = await _db.getActivity(album: album);

    if (activityFetchFailed) {
      activity.addAll(offlineActivity);
      return;
    }

    activity.addAll(onlineActivity);
    newActivity.addAll(onlineActivity.where((a) {
      if (firstRun) {
        final now = DateTime.now();
        return now.difference(a.createdAt).inDays < 1;
      }
      return !offlineActivity.contains(a);
    }));
  }

  void _notifyActivity(List<Activity> activity) async {
    if (activity.isEmpty) {
      return;
    }

    final currentUser = await _db.getUser();

    Map<String, ActivityCount> map = {};
    for (Activity event in activity) {
      // Don't notify if created by current user.
      if (event.user.id == currentUser?.id) {
        continue;
      }

      final count = map[event.user.name] ?? ActivityCount();
      // TODO: Should we separate asset types?
      // This would involve looking up each asset in the db.
      // Maybe only do this if there is only a small number of activity.
      switch (event.type) {
        case ActivityType.like:
          count.otherLikes++;
        case ActivityType.comment:
          count.otherComments++;
          break;
      }
    }

    if (map.isEmpty) {
      return;
    }

    final buf = StringBuffer();
    final locale = AppLocale.instance.current;

    for (var entry in map.entries) {
      entry.value.describe(buf, entry.key, locale);
    }

    await _notifications.activity(
      title: locale.newActivityNotification,
      content: buf.toString(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class SyncState {
  /// True if the offline database doesn't contain any assets
  /// and there has not yet been a sync since the app has been opened.
  final bool firstRun;

  /// If false, service is waiting until next sync period.
  /// If assets is true, at least one sync has already been completed;
  final bool syncing;

  /// True if assets have been synced at least once since the app has
  /// been opened.
  final bool assets;

  /// True if activity has been synced at least once since the app has
  /// been opened;
  final bool activity;

  const SyncState._({
    required this.firstRun,
    required this.syncing,
    required this.assets,
    required this.activity,
  });

  const SyncState(this.firstRun)
      : syncing = false,
        assets = false,
        activity = false;

  SyncState assetSyncComplete() {
    return SyncState._(
      firstRun: firstRun,
      syncing: syncing,
      assets: true,
      activity: activity,
    );
  }

  SyncState activitySyncComplete() {
    return SyncState._(
      firstRun: firstRun,
      syncing: syncing,
      assets: assets,
      activity: true,
    );
  }

  SyncState syncComplete() {
    return SyncState._(
      firstRun: false,
      syncing: false,
      assets: assets,
      activity: activity,
    );
  }

  SyncState started() {
    return SyncState._(
      firstRun: firstRun,
      syncing: true,
      assets: false,
      activity: false,
    );
  }
}
