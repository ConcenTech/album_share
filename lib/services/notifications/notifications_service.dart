import '../../models/asset.dart';

abstract class NotificationsService {
  Future<void> assets({
    String? title,
    required String content,
    List<Asset> assets = const [],
  });

  Future<void> activity({
    String? title,
    required String content,
    List<Asset> assets = const [],
  });
}
