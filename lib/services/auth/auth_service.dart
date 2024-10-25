import 'dart:async';

import '../../immich/image/cache/remote_image_cache_manager.dart';
import '../../immich/image/cache/thumbnail_image_cache_manager.dart';
import '../../models/endpoint.dart';
import '../../models/user.dart';
import '../api/api_service.dart';
import '../database/database_service.dart';
import '../sync/background_sync_service.dart';

class AuthService {
  AuthService(this._db, this._api, this._backgroundSync) {
    _init();
  }
  final DatabaseService _db;
  final ApiService _api;
  final BackgroundSyncService _backgroundSync;

  late final StreamController<User?> _currentUserStream;

  void _init() {
    _currentUserStream = StreamController.broadcast(
      onListen: _startAuthStream,
    );
  }

  void _startAuthStream() async {
    final authenticated = await checkAuthStatus();
    if (authenticated) {
      _currentUserStream.add(await _db.getUser());
    } else {
      _currentUserStream.add(null);
    }
  }

  Future<Endpoint?> getEndpoint() {
    return _db.getEndpoint();
  }

  /// Sets the current server url endpoint.
  ///
  /// Returns true for oauth login, otherwise returns false for password login.
  ///
  /// Throws [ApiException] or [DatabaseException] if unsuccessful.
  Future<bool> setEndpoint(String serverUrl) async {
    final endpoint = await _api.checkAndSetEndpoint(serverUrl);

    await _db.setEndpoint(endpoint);

    return endpoint.isOAuth;
  }

  Future<bool> checkAuthStatus() async {
    final userExists = await _db.userExists();
    if (!userExists) {
      return false;
    }

    try {
      return await _api.validateAuthToken();
    } on ApiException catch (e) {
      // User previously logged in, currently offline so assume authenticated still.
      // This avoids redirect to login screen when offline.
      if (e.type == ApiExceptionType.timeout) {
        return userExists;
      }
      return false;
    }
  }

  /// Attempts to login the user with the specified email and password
  ///
  /// Throws [ApiException] or [DatabaseException] if unsuccessful.
  /// 401 unsuccessful,
  Future<User> login(String email, String password) async {
    final user = await _api.login(email, password);
    // If login flow is triggered by token expiry,
    // we need to ensure its the same user logging back in.
    final oldUser = await _db.getUser();
    if (oldUser != null && oldUser != user) {
      await _clearUserData();
    }

    // Save to offline db.
    await _db.setUser(user);
    // Emit user to stream.
    _currentUserStream.add(user);
    return user;
  }

  Future<void> _clearUserData() async {
    await _db.clear();
    await RemoteImageCacheManager().emptyCache();
    await ThumbnailImageCacheManager().emptyCache();
  }

  Future<bool> logout() async {
    final loggedOut = await _api.logout();

    if (loggedOut) {
      // Remove user from offline db
      await _clearUserData();
      // Stop background events from firing.
      _backgroundSync.unregister();
      // Emit new event to user stream.
      _currentUserStream.add(null);
    }

    return loggedOut;
  }

  /// Gets the currently signed in user.
  ///
  /// Returns null if not authenticated.
  /// Gets the currently signed in user, or null if not authenticated.
  Future<User?> currentUser() async {
    final authenticated = await checkAuthStatus();

    if (!authenticated) {
      return null;
    }

    var user = await _db.getUser();

    if (user != null) {
      return user;
    }

    user = await _api.currentUser();
    await _db.setUser(user);

    return user;
  }

  Future<void> changePassword(String password) async {
    final user = await _api.changePassword(password);

    await _db.setUser(user);
    _currentUserStream.add(user);
  }

  /// A stream of events for the current user.
  ///
  /// Null if not authenticated.
  Stream<User?> userChanges() => _currentUserStream.stream;
}
