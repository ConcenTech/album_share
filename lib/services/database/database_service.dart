import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/utils/extension_methods.dart';
import '../../models/album.dart';
import '../../models/asset.dart';
import '../../models/asset_group.dart';
import '../../models/endpoint.dart';
import '../../models/log.dart';
import '../../models/preferences.dart';
import '../../models/user.dart';

//TODO: Consider drift https://pub.dev/packages/drift.
// Isar is not currently being updated.

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  DatabaseService._();
  static DatabaseService get instance {
    return _instance;
  }

  Isar? _isar;

  Isar get _db {
    if (_isar == null) {
      throw DatabaseException('The database has not been opened.', 'get _db');
    }
    return _isar!;
  }

  Future<T> _readTxn<T>(Future<T> Function() callback, String origin) async {
    try {
      return await _db.txn(callback);
    } on IsarError catch (e) {
      throw DatabaseException(e.message, origin);
    }
  }

  T _readTxnSync<T>(T Function() callback, String origin) {
    try {
      return _db.txnSync(callback);
    } on IsarError catch (e) {
      throw DatabaseException(e.message, origin);
    }
  }

  Future<void> _writeTxn<T>(
      Future<T> Function() callback, String origin) async {
    try {
      await _db.writeTxn(callback);
    } on IsarError catch (e) {
      throw DatabaseException(e.message, origin);
    }
  }

  void _writeTxnSync<T>(T Function() callback, String origin) {
    try {
      _db.writeTxnSync(callback);
    } on IsarError catch (e) {
      throw DatabaseException(e.message, origin);
    }
  }

  /// Opens the database ready for reading and writing.
  Future<void> init() async {
    if (_isar != null) {
      return;
    }
    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([
        EndpointSchema,
        UserSchema,
        AlbumSchema,
        AssetSchema,
        PreferencesSchema,
        LogSchema,
      ], directory: dir.path);
    } catch (e) {
      throw DatabaseException('Failed to open the database.', 'init', '$e');
    }
  }

  /// Removes all data from the offline database.
  ///
  /// Endpoint retained unless [endpoint] set to true.
  Future<void> clear([bool endpoint = false]) async {
    try {
      await _db.writeTxn(() async {
        await _db.users.clear();
        await _db.albums.clear();
        await _db.assets.clear();
        await _db.preferences.clear();
        if (endpoint) {
          await _db.endpoints.clear();
        }
      });
    } on IsarError catch (e) {
      throw DatabaseException(
          'Failed to clear the database', 'clear', e.message);
    }
  }

  /// Gets the server url endpoint if set, otherwise returns null.
  ///
  /// Throws [DatabaseException] if the operation fails.
  Future<Endpoint?> getEndpoint() {
    return _readTxn(
      () => _db.endpoints.get(Endpoint.id),
      'getEndpoint',
    );
  }

  /// Synchronously retrieves the server url endpoint.
  ///
  /// Throws [DatabaseException] if endpoint not set.
  Endpoint getEndpointSync() {
    final endpoint = _readTxnSync(
      () => _db.endpoints.getSync(Endpoint.id),
      'getEndpointSync',
    );
    if (endpoint == null) {
      throw DatabaseException('Endpoint not set', 'getEndpointSync');
    }
    return endpoint;
  }

  /// Inserts or updates the server url endpoint.
  ///
  /// Throws [DatabaseException] if the operation fails.
  Future<void> setEndpoint(Endpoint endpoint) {
    return _writeTxn(
      () => _db.endpoints.put(endpoint),
      'setEndpoint',
    );
  }

  /// Gets the current user if set, otherwise returns null.
  ///
  /// Throws [DatabaseException] if the operation fails.
  Future<User?> getUser() {
    return _readTxn<User?>(
      () => _db.users.get(User.defaultIsarId),
      'getUser',
    );
  }

  /// Returns true if a user object is found within the database,
  /// otherwise returns false.
  ///
  /// Throws [DatabaseException] if the operation fails.
  Future<bool> userExists() async {
    try {
      final count = await _db.txn(() {
        return _db.users.count();
      });
      return count > 0;
    } on IsarError catch (e) {
      throw DatabaseException(e.message, 'userExists');
    }
  }

  /// Inserts or updates the current user.
  ///
  /// Throws [DatabaseException] if the operation fails.
  Future<void> setUser(User user) {
    return _writeTxn(() => _db.users.put(user), 'setUser');
  }

  Future<List<Album>> getAlbums() {
    return _readTxn(
      () => _db.albums.where().anyIsarId().findAll(),
      'getAlbums',
    );
  }

  Future<void> setAlbums(List<Album> albums) {
    return _writeTxn(
      () async {
        await _db.albums.clear();
        await _db.albums.putAll(albums);
      },
      'setAlbums',
    );
  }

  /// Retrieves assets for the selected album.
  ///
  /// If album is null, all assets are retrieved.
  Future<List<Asset>> assets([Album? album]) {
    return _readTxn(
      () => album == null
          ? _db.assets.where().anyIsarId().sortByCreatedAtDesc().findAll()
          : _db.assets
              .where()
              .filter()
              .albumsElementContains(album.id)
              .sortByCreatedAtDesc()
              .findAll(),
      'getAssets',
    );
  }

  /// Listens to a list of assets for the selected album.
  ///
  /// If album is null, all albums are listened to.
  Stream<List<Asset>> assetStream([Album? album]) {
    return _readTxnSync(
      () => album == null
          ? _db.assets
              .where()
              .anyIsarId()
              .sortByCreatedAtDesc()
              .watch(fireImmediately: true)
          : _db.assets
              .where()
              .filter()
              .albumsElementContains(album.id)
              .sortByCreatedAtDesc()
              .watch(fireImmediately: true),
      'assetStream',
    );
  }

  Stream<List<Album>> albumsStream() {
    return _readTxnSync(
      () => _db.albums //
          .where()
          .anyIsarId()
          .watch(fireImmediately: true),
      'albumsStream',
    );
  }

  List<Asset> allAssetsSync() {
    return _readTxnSync(
      () => _db.assets.where().anyIsarId().sortByCreatedAtDesc().findAllSync(),
      'allAssetsSync',
    );
  }

  /// Checks if any assets have been stored in the offline db.
  bool haveAssetsSync() {
    final count = _readTxnSync(
      () => _db.assets.countSync(),
      'haveAssetsSync',
    );
    return count > 0;
  }

  /// Retrieves assets for the passed [AssetGroup]
  ///
  /// Removes any entries that could not be found in the database.
  Future<List<Asset>> assetsFromGroup(AssetGroup group) {
    return _readTxn(() async {
      final assets = await _db.assets.getAll(group.isarIds);
      return assets.listWhereType<Asset>();
    }, 'assetsFromGroup');
  }

  Future<void> setAssets(List<Asset> assets) {
    return _writeTxn(
      () async {
        await _db.assets.clear();
        await _db.assets.putAll(assets);
      },
      'setAssets',
    );
  }

  /// Returns the preferences for the current user,
  /// or null if no preferences have been saved.
  ///
  /// Throws [DatabaseException] if the operation fails.
  Future<Preferences?> getPreferences() {
    return _readTxn(
      () => _db.preferences.get(Preferences.id),
      'getPreferences',
    );
  }

  /// Stores the preferences for the current user.
  ///
  /// Throws [DatabaseException] if the operation fails.
  Future<void> setPreferences(Preferences preferences) {
    return _writeTxn(
      () => _db.preferences.put(preferences),
      'setPreferences',
    );
  }

  /// Retrieves the token for the current user.
  ///
  /// Throws [DatabaseException] if not signed in.
  Future<String> getAuthToken() async {
    final user = await _readTxn(
      () => _db.users.get(User.defaultIsarId),
      'getAuthToken',
    );
    if (user == null) {
      throw DatabaseException('Not authenticated', 'getAuthToken');
    }
    return user.token;
  }

  /// Synchronously retrieves the token for the current user.
  ///
  /// Throws [DatabaseException] if not signed in.
  String getAuthTokenSync() {
    final user = _readTxnSync(
      () => _db.users.getSync(User.defaultIsarId),
      'getAuthTokenSync',
    );
    if (user == null) {
      throw DatabaseException('Not authenticated', 'getAuthTokenSync');
    }
    return user.token;
  }

  Future<void> addLogs(List<Log> logs) async {
    return _writeTxn(
      () => _db.logs.putAll(logs),
      'addLogs(async)',
    );
  }

  void addLogsSync(List<Log> logs) {
    return _writeTxnSync(
      () => _db.logs.putAllSync(logs),
      'addLogsSync',
    );
  }

  List<Log> getLogsSync() {
    return _readTxnSync(
      () => _db.logs.where().findAllSync(),
      'getLogsSync',
    );
  }

  Future<void> clearLogs() {
    return _writeTxn(
      () => _db.logs.clear(),
      'clearLogs',
    );
  }

  int logCount() {
    return _readTxnSync(
      () => _db.logs.countSync(),
      'logCount',
    );
  }

  void deleteLogs(int count) {
    return _writeTxnSync(
      () => _db.logs.where().limit(count).deleteAllSync(),
      'deleteLogs',
    );
  }
}

class DatabaseException implements Exception {
  DatabaseException(
    this.message,
    this.method, [
    this.details,
  ]);

  final String message;
  final String? details;
  final String method;

  String debugMessage() => 'DatabaseService.$method: $message \n$details';

  @override
  String toString() {
    return 'DatabaseException: ${debugMessage()}';
  }
}
