import 'package:humanizer/humanizer.dart' show ApproximateTimeExtensions;
import 'package:isar/isar.dart';

import '../core/utils/app_localisations.dart';
import '../core/utils/db_utils.dart';
import 'asset.dart';
import 'json_map.dart';
import 'user_detail.dart';

part 'activity.g.dart';

@Collection(accessor: 'activity')
class Activity {
  Id get isarId => fastHash(id);

  final String id;
  final String? assetId;
  final String albumId;
  final DateTime createdAt;
  final String? comment;
  @enumerated
  final ActivityType type;
  final UserDetail user;

  const Activity({
    required this.id,
    required this.assetId,
    required this.albumId,
    required this.createdAt,
    required this.comment,
    required this.type,
    required this.user,
  });

  factory Activity.fromJson(String albumId, JsonMap json) {
    return Activity(
      id: json['id'],
      assetId: json['assetId'],
      albumId: albumId,
      createdAt: DateTime.parse(json['createdAt']),
      comment: json['comment'],
      type: ActivityType.fromString(json['type']),
      user: UserDetail.fromJson(json['user']),
    );
  }

  String describe(AppLocalizations locale, Asset? asset) {
    final userName = user.name;

    if (asset == null) {
      return locale.userCommentedOther(1, userName);
    }

    switch (type) {
      case ActivityType.comment:
        return switch (asset.type) {
          AssetType.image => locale.userCommentedImages(1, userName),
          AssetType.video => locale.userCommentedVideos(1, userName),
          AssetType _ => locale.userCommentedOther(1, userName),
        };
      case ActivityType.like:
        return switch (asset.type) {
          AssetType.image => locale.userLikedImages(1, userName),
          AssetType.video => locale.userLikedVideos(1, userName),
          AssetType _ => locale.userLikedOther(1, userName),
        };
    }
  }

  String approximateTimeAgo() =>
      createdAt.difference(DateTime.now()).toApproximateTime();

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Activity && other.id == id;
  }
}

enum ActivityType {
  like,
  comment,
  ;

  factory ActivityType.fromString(String value) {
    return ActivityType.values.firstWhere((e) => e.name == value);
  }
}
