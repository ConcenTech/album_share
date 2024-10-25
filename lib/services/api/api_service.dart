import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:album_share/core/utils/extension_methods.dart';
import 'package:album_share/models/activity.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../models/album.dart';
import '../../models/asset.dart';
import '../../models/endpoint.dart';
import '../../models/json_map.dart';
import '../../models/user.dart';
import '../database/database_service.dart';

const _applicationJson = 'application/json';

final _logger = Logger('ApiService');

class ApiService {
  const ApiService(this._dio, this._cookieJar, this._database);

  final Dio _dio;
  final CookieJar _cookieJar;
  final DatabaseService _database;

  Future<Endpoint> checkAndSetEndpoint(String serverUrl) async {
    final available = await _isEndpointAvailable(serverUrl);

    if (!available) {
      _logger.info('Endpoint $serverUrl could not be reached');
      throw const ApiException(
        ApiExceptionType.timeout,
        'Endpoint unavailable or does not exist.',
      );
    }

    _setServerUrl(serverUrl);
    _logger.info('Endpoint $serverUrl set');

    final isOAuth = await _checkIsOAuth();
    _logger.info('Endpoint is oAuth: $isOAuth');

    return Endpoint(serverUrl, isOAuth);
  }

  void _setServerUrl(String serverUrl) {
    _dio.options.baseUrl = serverUrl;
    _dio.options.headers = {'Accept': _applicationJson};

    _dio.interceptors.clear();
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<bool> _getEndpointFromStorage() async {
    if (_dio.options.baseUrl.isEmpty) {
      final endpoint = await _database.getEndpoint();
      if (endpoint != null) {
        _setServerUrl(endpoint.serverUrl);
        return true;
      }
    }
    return false;
  }

  /// Checks the already set endpoint to see if it is currently reachable.
  Future<bool> checkEndpoint() async {
    final endpointFound = await _getEndpointFromStorage();
    if (!endpointFound) {
      return false;
    }

    final available = await _isEndpointAvailable('');

    if (!available) {
      _logger.info('Endpoint could not be reached');
    }

    return available;
  }

  /// Check to see if oauth has been enabled on the server.
  Future<bool> _checkIsOAuth() async {
    _expectEndpointSet();

    try {
      final body = await _get(
        '/api/server/features',
        expected: JSON_MAP,
      );

      return body['oauth'];
    } on ApiException catch (e, s) {
      _logger.severe(
          'Failed to check oauth status of the server. Defaulting to false.',
          e,
          s);
      return false;
    }
  }

  /// Attempts to ping the server.
  ///
  /// Returns true if a successful response is received, otherwise returns false.
  Future<bool> _isEndpointAvailable(String serverUrl) async {
    try {
      await _dio.get(
        '$serverUrl/api/server/ping',
        options: Options(
          headers: {'Accepts': _applicationJson},
          sendTimeout: const Duration(seconds: 5),
        ),
      );

      return true;
    } on DioException {
      return false;
    }
  }

  /// Attempts to login with the supplied credentials.
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<User> login(String email, String password) async {
    _expectEndpointSet();

    final body = await _post(
      '/api/auth/login',
      data: {
        'email': email,
        'password': password,
      },
      headers: {
        'Accept': _applicationJson,
        'Content-Type': _applicationJson,
      },
      expected: JSON_MAP,
    );

    return User.fromJson(body);
  }

  /// Verify the supplied user authentication token is valid.
  ///
  /// Return true if valid, otherwise returns false.
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<bool> validateAuthToken() async {
    _expectEndpointSet();

    try {
      final body = await _post(
        '/api/auth/validateToken',
        expected: JSON_MAP,
      );

      return body['authStatus'];
    } on DioException catch (e, s) {
      _logger.severe('Unable to validate endpoint token', e, s);
      throw ApiException.fromDioException(e, s);
    }
  }

  /// Gets the profile for the current user.
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<User> currentUser() async {
    _expectEndpointSet();

    final body = await _post(
      '/api/users/me',
      expected: JSON_MAP,
    );

    return User.fromJson(body, await _currentUserToken());
  }

  /// Changes the password for the current authenticated user.
  ///
  /// Throws[ApiException] if unsuccessful
  Future<User> changePassword(String password) async {
    _expectEndpointSet();

    // The change password endpoint doesn't update shouldChangePassword
    final body = await _put(
      '/api/users/me',
      expected: JSON_MAP,
      data: {
        'password': password,
      },
      headers: {
        'Accept': _applicationJson,
        'Content-Type': _applicationJson,
      },
    );

    return User.fromJson(body, await _currentUserToken());
  }

  /// Access token is not always returned in the user object
  ///
  /// However, if the user is authenticated, the access token can be found in
  /// the request cookies.
  Future<String> _currentUserToken() async {
    final cookies =
        await _cookieJar.loadForRequest(Uri.parse(_dio.options.baseUrl));

    return cookies
        .firstWhere((cookie) => cookie.name == 'immich_access_token')
        .value;
  }

  /// Logs out the current user.
  ///
  /// Returns true if user logged out
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<bool> logout() async {
    _expectEndpointSet();

    final body = await _post(
      '/api/auth/logout',
      expected: JSON_MAP,
    );

    return body['successful'] as bool;
  }

  /// Retrieves a list of all albums shared with this user.
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<List<Album>> getSharedAlbums() async {
    _expectEndpointSet();

    final body = await _get(
      '/api/albums',
      queryParameters: {'shared': 'true'},
      expected: JSON_LIST,
    );

    return body.map((e) => Album.fromJson(e)).toList();
  }

  /// Gets assets for the selected album.
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<List<Asset>> getAlbumAssets(Album album) async {
    _expectEndpointSet();

    final body = await _get(
      '/api/albums/${album.id}',
      expected: JSON_MAP,
    );

    final assets = List.from(body['assets']);

    return assets
        .map((e) => Asset.fromJson(
              album.id,
              JsonMap.from(e),
            ))
        .toList();
  }

  Future<Uint8List> downloadVideoData(
    String assetId,
    void Function(int count, int total) onProgress,
  ) async {
    final response = await _dio.get(
      '/api/assets/$assetId/video/playback',
      queryParameters: {'Accept': 'application/octet-stream'},
      onReceiveProgress: onProgress,
    );

    if (response.data is String) {
      final data = const Utf8Encoder().convert(response.data);
      return data;
    }

    return response.data;
  }

  /// Gets a list of activity for the selected album.
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<List<Activity>> getActivity(Album album) async {
    _expectEndpointSet();

    final body = await _get(
      '/api/activities',
      queryParameters: {'albumId': album.id},
      expected: JSON_LIST,
    );

    return body.mapList((e) => Activity.fromJson(album.id, e));
  }

  Future<Activity> uploadComment(
    String comment,
    String albumId,
    String assetId,
  ) {
    return uploadActivity(albumId, assetId, ActivityType.comment, comment);
  }

  Future<Activity> uploadLike(
    String comment,
    String albumId,
    String assetId,
  ) {
    return uploadActivity(albumId, assetId, ActivityType.like);
  }

  Future<Activity> uploadActivity(
    String albumId,
    String assetId,
    ActivityType type, [
    String? comment,
  ]) async {
    final response = await _post(
      '/api/activities',
      data: {
        'albumId': albumId,
        'assetId': assetId,
        'comment': comment,
        'type': type.name,
      },
      expected: JSON_MAP,
    );

    return Activity.fromJson(albumId, response);
  }

  /// Ensures the server url has been set via a call to [checkAndSetEndpoint]
  void _expectEndpointSet() {
    if (_dio.options.baseUrl.isEmpty) {
      _logger.severe('Endpoint was not set before api called');
      throw const ApiException(
          ApiExceptionType.client, 'Server url has not been set');
    }
  }

  /// Extracts a json object from the request.
  ///
  /// Throws [ApiException] if the request was not valid or extraction failed.
  Future<JsonMap> _extractObjectFromResponse(Response response) async {
    if (response.statusCode == null || response.statusCode! > 201) {
      _logger.severe('Unable to extract object from response data. '
          'The server returned a status code of: ${response.statusCode}');
      throw ApiException(ApiExceptionType.server,
          response.statusMessage ?? '${response.data}');
    }

    JsonMap? body;

    if (response.data is String) {
      body = await compute(
        (String j) => json.decode(j),
        response.data as String,
      );
    } else if (response.data != null) {
      body = JsonMap.from(response.data);
    }

    if (body == null ||
        body.isEmpty ||
        response.statusCode == HttpStatus.noContent) {
      _logger.severe('Unable to extract object from response data. '
          'No content included with the response.');
      throw const ApiException(
          ApiExceptionType.server, 'No content included with response');
    }

    return body;
  }

  /// Extracts a list of json objects from the request.
  ///
  /// Throws [ApiException] if the request was not valid or extraction failed.
  Future<List<JsonMap>> _extractObjectListFromResponse(
      Response response) async {
    if (response.statusCode == null || response.statusCode! > 201) {
      _logger.severe('Unable to extract object list from response data. '
          'The server returned a status code of: ${response.statusCode}');
      throw ApiException(ApiExceptionType.server,
          response.statusMessage ?? '${response.data}');
    }

    List<JsonMap>? body;

    if (response.data is String) {
      response.data = await compute(
        (String j) => json.decode(j),
        response.data as String,
      );
    }

    if (response.data != null) {
      body = List.from(response.data).map((e) => JsonMap.from(e)).toList();
    }

    if (body == null ||
        body.isEmpty ||
        response.statusCode == HttpStatus.noContent) {
      _logger.info('No content included with the response');
      return [];
    }

    return body;
  }

  /// Sends a post request with the supplied data.
  ///
  /// Returns the response data as a [String]
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<T> _post<T>(
    String endpoint, {
    JsonMap? data,
    Map<String, String>? headers,
    required T expected,
  }) async {
    assert(expected is JsonMap || expected is List<JsonMap>);

    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );

      return expected is JsonMap?
          ? await _extractObjectFromResponse(response) as T
          : await _extractObjectListFromResponse(response) as T;
    } on DioException catch (e, s) {
      throw ApiException.fromDioException(e, s);
    }
  }

  /// Sends a get request with the supplied data.
  ///
  /// Returns the response data as a [String]
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<T> _get<T>(
    String endpoint, {
    String? data,
    Map<String, String>? queryParameters,
    required T expected,
  }) async {
    assert(expected is JsonMap || expected is List<JsonMap>);

    try {
      final response = await _dio.get(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return expected is JsonMap
          ? await _extractObjectFromResponse(response) as T
          : await _extractObjectListFromResponse(response) as T;
    } on DioException catch (e, s) {
      throw ApiException.fromDioException(e, s);
    }
  }

  /// Sends a put request with the supplied data.
  ///
  /// Returns the response data as a [String]
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<T> _put<T>(
    String endpoint, {
    JsonMap? data,
    Map<String, String>? headers,
    required T expected,
  }) async {
    assert(expected is JsonMap || expected is List<JsonMap>);

    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );

      return expected is JsonMap?
          ? await _extractObjectFromResponse(response) as T
          : await _extractObjectListFromResponse(response) as T;
    } on DioException catch (e, s) {
      throw ApiException.fromDioException(e, s);
    }
  }
}

class ApiException implements Exception {
  const ApiException(this.type, this.message);

  // ApiException.fromDioException(DioException e)
  //     : type = ApiExceptionType.fromDioException(e),
  //       debugMessage = e.message ?? 'An unknown error occurred.';
  factory ApiException.fromDioException(DioException e, StackTrace s) {
    String? error;
    if (e.response?.data is JsonMap &&
        (e.response!.data as JsonMap).containsKey('message')) {
      error = e.response!.data['message'];
    }

    _logger.severe(
      'API request failed.',
      error == null ? e : e.response!.data,
      s,
    );

    final type = ApiExceptionType.fromDioException(e);

    return ApiException(
      type,
      error ?? _messageFromType(type),
    );
  }

  final String message;
  final ApiExceptionType type;

  static String _messageFromType(ApiExceptionType type) {
    return switch (type) {
      ApiExceptionType.client => 'There was an error processing the request.',
      ApiExceptionType.server => 'There was an error processing the response.',
      ApiExceptionType.timeout =>
        'Failed to connect to the server or the request timed out.',
      ApiExceptionType.unauthenticated => 'Authentication error.',
    };
  }

  @override
  String toString() {
    return 'ApiException: $message';
  }
}

enum ApiExceptionType {
  server,
  client,
  timeout,
  unauthenticated,
  ;

  factory ApiExceptionType.fromCode(int code) {
    switch (code) {
      /// Information and success codes.
      case < 300:
        throw const FormatException('Success code thrown as an error');

      /// Redirects
      case < 400:
        return ApiExceptionType.server;

      /// Unauthorised, forbidden, proxy auth required and network auth required.
      case 401 || 403 || 407 || 511:
        return ApiExceptionType.unauthenticated;

      /// Client error responses.
      case < 500:
        return ApiExceptionType.client;

      /// Server error responses.
      default:
        return ApiExceptionType.server;
    }
  }

  factory ApiExceptionType.fromDioException(DioException e) {
    if (e.response?.statusCode != null) {
      return ApiExceptionType.fromCode(e.response!.statusCode!);
    }

    return switch (e.type) {
      DioExceptionType.sendTimeout => ApiExceptionType.timeout,
      DioExceptionType.receiveTimeout => ApiExceptionType.timeout,
      DioExceptionType.connectionTimeout => ApiExceptionType.timeout,
      DioExceptionType.badCertificate => ApiExceptionType.unauthenticated,
      DioExceptionType.badResponse => ApiExceptionType.server,
      DioExceptionType.cancel => ApiExceptionType.client,
      DioExceptionType.unknown => ApiExceptionType.client,
      DioExceptionType.connectionError => ApiExceptionType.timeout,
    };
  }
}
