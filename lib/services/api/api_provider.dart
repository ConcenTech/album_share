
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'api_service.dart';

abstract class ApiProviders {
  /// [Dio] provider.
  static final _dio = Provider((ref) => Dio());

  /// [CookieJar] provider.
  static final cookies = FutureProvider<CookieJar>((ref) async {
    final dir = await getApplicationDocumentsDirectory();
    return PersistCookieJar(storage: FileStorage(dir.path));
  });

  // cookies provider is initialised by init provider so should always be available.
  // If it is not available something has good wrong on start-up, expect an app crash.
  static final _cookieJar = Provider((ref) {
    final cookieJar = ref.watch(cookies).value;
    if (cookieJar == null) {
      throw Exception('Cookie jar has not been initialised.'
          'Verify app has completed initilisation before using apis.');
    }

    return cookieJar;
  });

  /// [ApiService] provider.
  static final service = Provider((ref) {
    return ApiService(
      ref.watch(_dio),
      ref.watch(_cookieJar),
    );
  });
}
