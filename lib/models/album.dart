import 'package:isar/isar.dart';

import '../core/utils/db_utils.dart';
import 'json_map.dart';

part 'album.g.dart';

@collection
class Album {
  const Album({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailId,
    required this.isActivityEnabled,
    required this.lastUpdated,
  });

  /// Used only for offline storage
  Id get isarId => fastHash(id);

  final String id;
  final String name;
  final String description;
  final DateTime lastUpdated;

  /// The id of the thumbnail asset for this album
  final String thumbnailId;

  /// If likes and comments are on for this album.
  final bool isActivityEnabled;

  factory Album.fromJson(JsonMap json) {
    return Album(
      id: json['id'],
      name: json['albumName'],
      description: json['description'],
      thumbnailId: json['albumThumbnailAssetId'],
      isActivityEnabled: json['isActivityEnabled'],
      lastUpdated: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  String toString() {
    return '[Album:$id]'
        '\n$name'
        '\n$description'
        '\nThumbnail: $thumbnailId'
        '\n${isActivityEnabled ? "Activity enabled." : "Activity disabled."}'
        '\nLast updated: $lastUpdated';
  }

  @ignore
  int get lastUpdatedMillis => lastUpdated.millisecondsSinceEpoch;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Album && other.id == id;
  }
}

