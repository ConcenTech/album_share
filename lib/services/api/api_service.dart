import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';

import '../../models/album.dart';
import '../../models/asset.dart';
import '../../models/endpoint.dart';
import '../../models/json_map.dart';
import '../../models/user.dart';

const _applicationJson = 'application/json';

class ApiService {
  const ApiService(this._dio, this._cookieJar);

  final Dio _dio;
  final CookieJar _cookieJar;

  Future<Endpoint> checkAndSetEndpoint(String serverUrl) async {
    final available = await _isEndpointAvailable(serverUrl);

    if (!available) {
      //TODO: Log
      throw const ApiException(
          ApiExceptionType.timeout, 'Enpoint unavailable or does not exist.');
    }

    //TODO: Log, endpoint set.

    _dio.options.baseUrl = serverUrl;
    _dio.options.headers = {'Accept': _applicationJson};

    _dio.interceptors.clear();
    _dio.interceptors.add(CookieManager(_cookieJar));

    final isOAuth = await _checkIsOAuth();

    return Endpoint(serverUrl, isOAuth);
  }

  /// Check to see if oauth has been enabled on the server.
  Future<bool> _checkIsOAuth() {
    return Future.value(false);
    //TODO:
  }

  /// Attempts to ping the server.
  ///
  /// Returns true if a successful response is recieved, otherwise returns false.
  Future<bool> _isEndpointAvailable(String serverUrl) async {
    try {
      await _dio.get(
        '$serverUrl/api/server-info/ping',
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
    } on ApiException catch (e) {
      print('${e.message}: ${e.debugMessage}');
      return false;
    }
  }

  Future<User> currentUser() async {
    _expectEndpointSet();

    final body = await _post(
      '/api/users/me',
      expected: JSON_MAP,
    );

    return User.fromJson(body);
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

    final success = body['successful'] as bool;

    //TODO: Remove test code below once behaviour of cokies verified.
    if (success) {
      final cookies =
          await _cookieJar.loadForRequest(Uri.parse(_dio.options.baseUrl));
      print('User logged out. Remaining cookies:');
      if (cookies.isEmpty) {
        print('EMPTY');
      } else {
        for (var cookie in cookies) {
          print(cookie);
        }
      }
    }

    return success;
  }

  /// Changes the password of the current user.
  ///
  /// Throws [ApiException] if unsuccessful.
  Future<void> changePassword(String password, String newPassword) async {
    _expectEndpointSet();

    await _post(
      '/api/auth/change-password',
      data: {
        "password": password,
        "newPassword": newPassword,
      },
      headers: {
        'Content-Type': _applicationJson,
      },
      expected: JSON_MAP,
    );
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
  Future<List<Asset>> getAlbumAssets(String albumId) async {
    _expectEndpointSet();

    final body = await _get(
      '/api/albums/$albumId',
      expected: JSON_MAP,
    );

    final assets = List.from(body['assets']);

    return assets
        .map((e) => Asset.fromJson(
              albumId,
              JsonMap.from(e),
            ))
        .toList();
  }

  /// Ensures the server url has been set via a call to [checkAndSetEndpoint]
  void _expectEndpointSet() {
    if (_dio.options.baseUrl.isEmpty) {
      throw const ApiException(
          ApiExceptionType.client, 'Server url has not been set');
    }
  }

  /// Extracts a json object from the request.
  ///
  /// Throws [ApiException] if the request was not valid or extraction failed.
  Future<JsonMap> _extractObjectFromResponse(Response response) async {
    if (response.statusCode == null || response.statusCode! > 201) {
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
      //TODO: Should 204 return null to signal data hasn't changed?
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
    } on DioException catch (e) {
      // TODO: log
      throw ApiException.fromDioException(e);
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
    } on DioException catch (e) {
      // Unable to reach endpoint.
      throw ApiException.fromDioException(e);
    }
  }
}

class ApiException implements Exception {
  const ApiException(this.type, this.debugMessage);

  ApiException.fromDioException(DioException e)
      : type = ApiExceptionType.fromDioException(e),
        debugMessage = e.message ?? 'An unknown error occurred.';

  final ApiExceptionType type;
  final String debugMessage;

  String get message {
    return switch (type) {
      ApiExceptionType.client => 'There was an error processing the request.',
      ApiExceptionType.server => 'There was an error processing the response.',
      ApiExceptionType.timeout =>
        'Failed to connect to the server or the request timed out.',
      ApiExceptionType.unauthenticated => 'Authentication error.',
    };
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

    print(e.type);

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
