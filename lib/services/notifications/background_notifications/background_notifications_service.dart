import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';

import '../../../models/asset.dart';
import '../notifications_service.dart';

part 'android_background_notifications.dart';
part 'fallback_background_notifications_service.dart';
part 'ios_background_notifications_service.dart';
part 'macos_background_notifications_service.dart';

final _logger = Logger('BackgroundNotificationsService');

@pragma('vm:entry-point')
void _onReceive(int id, String? title, String? body, String? payload) {
  print('Clicked on notification');
}

abstract class BackgroundNotificationsService extends NotificationsService {
  BackgroundNotificationsService() {
    _init();
  }

  static BackgroundNotificationsService forPlatform() {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => _AndroidBackgroundNotificationsService(),
      TargetPlatform.iOS => _IosBackgroundNotificationsService(),
      TargetPlatform.macOS => _MacosBackgroundNotificationsService(),
      TargetPlatform.linux => _FallbackBackgroundNotificationsService(),
      TargetPlatform.windows => _FallbackBackgroundNotificationsService(),
      TargetPlatform.fuchsia => _FallbackBackgroundNotificationsService(),
    };
  }

  final _logger = Logger('BackgroundNotificationsService');

  void _init();

  Future<void> _assets({String? title, required String content});
  Future<void> _activity({String? title, required String content});

  Future<bool> hasPermissions();
  Future<bool> requestPermissions();

  int get _nextId => Random().nextInt(1000);

  @override
  Future<void> assets({
    String? title,
    required String content,
    List<Asset> assets = const [],
  }) async {
    if (!await hasPermissions()) {
      return _logger.info(
        'Background notification permissions not granted.'
        ' Unable to notify',
      );
    }
    return _assets(title: title, content: content);
  }

  @override
  Future<void> activity({
    String? title,
    required String content,
    List<Asset> assets = const [],
  }) async {
    if (!await hasPermissions()) {
      return _logger.info(
        'Background notification permissions not granted.'
        ' Unable to notify',
      );
    }
    return _activity(title: title, content: content);
  }
}
