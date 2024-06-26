import 'package:isar/isar.dart';

import '../core/utils/db_utils.dart';
import 'json_map.dart';

part 'asset.g.dart';

@collection
class Asset {
  const Asset({
    required this.id,
    required this.albumId,
    required this.type,
    required this.createdAt,
    required this.fileName,
  });

  Id get isarId => fastHash(id);

  final String id;
  final String albumId;
  @enumerated
  final AssetType type;
  final DateTime createdAt;
  final String fileName;

  factory Asset.fromJson(String albumId, JsonMap json) {
    return Asset(
      id: json['id'],
      albumId: albumId,
      type: AssetType.fromString(json['type']),
      createdAt: DateTime.parse(json['fileCreatedAt']),
      fileName: json['originalFileName'],
    );
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
  
  @override
  bool operator ==(Object other) {
    return other is Asset && other.id == id && other.type == type;
  }
}

enum AssetType {
  image,
  video,
  audio,
  other;

  factory AssetType.fromString(String value) {
    return AssetType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
    );
  }
}
