part of 'background_notifications_service.dart';

/// An empty notifications service for use on platforms where background
/// notifications are not yet supported.
class _FallbackBackgroundNotificationsService
    extends BackgroundNotificationsService {
  @override
  Future<bool> hasPermissions() => Future.value(true);

  @override
  Future<bool> requestPermissions() => Future.value(true);

  @override
  Future<void> _activity({String? title, required String content}) =>
      Future.value();

  @override
  Future<void> _assets({String? title, required String content}) =>
      Future.value();

  @override
  void _init() {
    _logger.info(
      'Using fallback notifications service as this platform '
      'does not currently support background notifications.',
    );
  }
}
