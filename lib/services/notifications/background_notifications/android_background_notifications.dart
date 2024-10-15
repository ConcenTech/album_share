part of 'background_notifications_service.dart';

class _AndroidBackgroundNotificationsService
    extends BackgroundNotificationsService {
  late final AndroidFlutterLocalNotificationsPlugin _plugin;

  static const _activityChannelId = 'activity_channel_id';
  static const _activityChannelName = 'Activity Channel';
  static const _activityChannelDescription = 'Receives activity notifications';
  static const _activityNotificationDetails = AndroidNotificationDetails(
    _activityChannelId,
    _activityChannelName,
    channelDescription: _activityChannelDescription,
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );
  static const _activityNotificationChannel = AndroidNotificationChannel(
    _activityChannelId,
    _activityChannelName,
    description: _activityChannelDescription,
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  static const _assetChannelId = 'asset_channel_id';
  static const _assetChannelName = 'Asset Channel';
  static const _assetChannelDescription =
      'Receives notifications about new assets';
  static const _assetNotificationDetails = AndroidNotificationDetails(
    _assetChannelId,
    _assetChannelName,
    channelDescription: _assetChannelDescription,
    importance: Importance.low,
    playSound: true,
    enableVibration: true,
  );
  static const _assetNotificationChannel = AndroidNotificationChannel(
    _assetChannelId,
    _assetChannelName,
    description: _assetChannelDescription,
    importance: Importance.low,
    playSound: true,
    enableVibration: true,
  );

  static const _initialisationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  @override
  void _init() async {
    try {
      final p = FlutterLocalNotificationsPlugin();
      _plugin = p.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!;

      _plugin.createNotificationChannel(_activityNotificationChannel);
      _plugin.createNotificationChannel(_assetNotificationChannel);

      await _plugin.initialize(_initialisationSettings);
      _logger.info('Android notifications initialised');
    } catch (error, stack) {
      _logger.severe(
        'Failed to initialise Android notifications',
        error,
        stack,
      );
    }
  }

  @override
  Future<void> _activity({
    String? title,
    required String content,
  }) {
    return _plugin.show(
      _nextId,
      title,
      content,
      notificationDetails: _activityNotificationDetails,
    );
  }

  @override
  Future<void> _assets({
    String? title,
    required String content,
  }) {
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
    final allow = await _plugin.areNotificationsEnabled() ?? false;
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
      allow = await _plugin.requestNotificationsPermission() ?? false;
      _logger.info('Notification permissions granted: $allow');
    }
    return allow;
  }
}
