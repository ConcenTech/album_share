import 'dart:async';

import '../../models/endpoint.dart';
import '../../models/user.dart';
import '../api/api_service.dart';
import '../database/database_service.dart';

class AuthService {
  AuthService(this._db, this._api) {
    _init();
  }

  final DatabaseService _db;
  final ApiService _api;

  late final StreamController<User?> _currentUserStream;

  void _init() {
    _currentUserStream = StreamController(
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
    final endpoint = await _db.getEndpoint();
    if (endpoint == null) {
      return false;
    }

    try {
      await _api.checkAndSetEndpoint(endpoint.serverUrl);
    } on ApiException catch (_) {
      final user = await _db.getUser();
      print('Working offline');
      return user == null;
    }
    return await _api.validateAuthToken();
  }

  /// Attemps to login the user with the specified email and password
  ///
  /// Throws [ApiException] or [DatabaseException] if unsuccessful.
  /// 401 unsuccessful,
  Future<User> login(String email, String password) async {
    final user = await _api.login(email, password);
    // If login flow is triggered by token expiry,
    // we need to ensure its the same user logging back in.
    final oldUser = await _db.getUser();
    if (oldUser != null && oldUser != user) {
      await _db.clear();
    }

    // Save to offline db.
    await _db.setUser(user);
    // Emit user to stream.
    _currentUserStream.add(user);
    return user;
  }

  Future<bool> logout() async {
    final loggedOut = await _api.logout();

    if (loggedOut) {
      // Remove user from offline db
      await _db.clear();
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
    // If subscription has been subscribed to,
    // the data will have already been fetched.
    if (_currentUserStream.hasListener) {
      return userChanges().first;
    }

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

  /// A stream of events for the current user.
  ///
  /// Null if not authenticated.
  Stream<User?> userChanges() => _currentUserStream.stream;
}
