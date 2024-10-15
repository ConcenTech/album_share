part of 'background_notifications_service.dart';

class _IosBackgroundNotificationsService
    extends BackgroundNotificationsService {
  late final IOSFlutterLocalNotificationsPlugin _plugin;

  static const _assetNotificationCategory = 'asset_notification';
  static const _assetNotificationDetails = DarwinNotificationDetails(
    categoryIdentifier: _assetNotificationCategory,
    interruptionLevel: InterruptionLevel.active,
    threadIdentifier: _assetNotificationCategory,
  );

  static const _activityNotificationCategory = 'activity_notification';
  static const _activityNotificationDetails = DarwinNotificationDetails(
    categoryIdentifier: _activityNotificationCategory,
    interruptionLevel: InterruptionLevel.active,
    threadIdentifier: _activityNotificationCategory,
  );

  static const _initialisationSettings = DarwinInitializationSettings(
    defaultPresentAlert: true,
    defaultPresentBadge: false,
    defaultPresentBanner: true,
    defaultPresentSound: true,
    notificationCategories: [
      DarwinNotificationCategory(_assetNotificationCategory),
      DarwinNotificationCategory(_activityNotificationCategory),
    ],
  );

  @override
  void _init() {
    try {
      _plugin = FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!;
      _plugin.initialize(_initialisationSettings);
      _logger.info('Initialised iOS notifications');
    } catch (error, stack) {
      _logger.severe(
        'Failed to initialise iOS notifications',
        error,
        stack,
      );
    }
  }

  @override
  Future<void> _activity({String? title, required String content}) {
    return _plugin.show(
      _nextId,
      title,
      content,
      notificationDetails: _activityNotificationDetails,
    );
  }

  @override
  Future<void> _assets({String? title, required String content}) {
    return _plugin.show(
      _nextId,
      title,
      content,
      notificationDetails: _assetNotificationDetails,
    );
  }

  @override
  Future<bool> hasPermissions() async {
    _logger.info('Checking for notification permissions');
    final options = await _plugin.checkPermissions();
    final allow = options?.isAlertEnabled ?? false;
    _logger.info('Notification permissions granted: $allow');
    return allow;
  }

  @override
  Future<bool> requestPermissions() async {
    bool allow = await hasPermissions();
    if (!allow) {
      _logger.info(
        'Notification permissions not yet granted. '
        'Requesting permissions',
      );
      allow =
          await _plugin.requestPermissions(sound: true, alert: true) ?? false;
      _logger.info('Notification permissions granted: $allow');
    }
    return allow;
  }
}
