import 'package:background_fetch/background_fetch.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import '../api/api_service.dart';
import '../database/database_service.dart';
import '../logger/app_logger.dart';
import '../notifications/background_notifications/background_notifications_service.dart';
import 'sync_service.dart';

final _logger = Logger('BackgroundSyncService');

class BackgroundSyncService {
  BackgroundSyncService._();

  static BackgroundSyncService? _instance;

  static BackgroundSyncService get instance {
    return _instance ??= BackgroundSyncService._();
  }

  //TODO: Remove once all platforms are supported.
  /// Not all platforms are currently supported.
  static bool isSupportedPlatform() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  bool _registered = false;

  void register() async {
    assert(
      isSupportedPlatform(),
      'Unable to register background processes on this platform '
      'until a platform specific implementation has been created.',
    );
    if (!_registered) {
      _registered = true;
      return _register();
    } else {
      _logger.warning('Register called multiple times');
    }
  }

  void unregister() async {
    final platform = defaultTargetPlatform;
    if (platform != TargetPlatform.android && platform != TargetPlatform.iOS) {
      return;
    }
    if (_registered) {
      _registered = false;
      try {
        await BackgroundFetch.stop();
        _logger.info('Unregistered');
      } catch (error, stack) {
        _logger.severe('Failed to unregister', error, stack);
      }
    } else {
      _logger.warning('Register called whilst service not registered');
    }
  }

  void _register() async {
    try {
      await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          requiredNetworkType: NetworkType.ANY,
          startOnBoot: true,
          stopOnTerminate: false,
          enableHeadless: true,
        ),
        _onBackgroundFetch,
        _onTimeout,
      );
      _logger.info('Registered');
    } catch (error, stack) {
      _logger.severe('Failed to register', error, stack);
    }
  }

  void _onBackgroundFetch(String taskId) async {
    try {
      final syncService = await _setupDependencies();

      syncService.update();
    } on BackgroundFetchException {
      // Already dealt with error. Just finish and exit.
    } catch (error, stack) {
      _logger.severe('Failed to complete.', error, stack);
    } finally {
      _finish(taskId);
    }
  }

  Future<SyncService> _setupDependencies() async {
    try {
      final db = DatabaseService.instance;
      await db.init();

      // Init logger to listen to events
      AppLogger.instance;
      _logger.info('Background sync started.');

      // Ensure valid user.
      final userExists = await db.userExists();
      if (!userExists) {
        _logger.warning('User not found in database, Stopping sync');
        throw BackgroundFetchException();
      }

      // Setup api service
      final userDir = await getApplicationDocumentsDirectory();
      final cookieJar = PersistCookieJar(storage: FileStorage(userDir.path));
      final api = ApiService(Dio(), cookieJar, db);

      // Set endpoint
      final reachable = await api.checkEndpoint();
      if (!reachable) {
        _logger.warning('Unable to reach endpoint.');
        throw BackgroundFetchException();
      }

      // Background notifications
      final notifications = BackgroundNotificationsService.forPlatform();

      final sync = SyncService(api, db, notifications);

      return sync;
    } on BackgroundFetchException {
      rethrow;
    } catch (error, stack) {
      _logger.severe(
        'Failed to setup dependencies for background task.',
        error,
        stack,
      );
      throw BackgroundFetchException();
    }
  }

  void _onTimeout(String taskId) {
    _logger.warning('Background sync timed out.');
    _finish(taskId);
  }

  Future<void> _finish(String taskId) async {
    AppLogger.instance.flush();
    BackgroundFetch.finish(taskId);
  }
}

class BackgroundFetchException implements Exception {}
