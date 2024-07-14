import 'package:isar/isar.dart';

import 'json_map.dart';

part 'asset.g.dart';

@collection
class Asset {
  const Asset({
    required this.id,
    required this.albums,
    required this.type,
    required this.createdAt,
    required this.fileName,
    this.width,
    this.height,
    this.durationInSeconds,
    this.stackCount = 0,
    this.thumbHash,
  });

  Id get isarId => Isar.autoIncrement;

  final String id;

  /// A list of album ids associated with this asset.
  final List<String> albums;
  @enumerated
  final AssetType type;
  final DateTime createdAt;
  final String fileName;

  //TODO:
  final int? width;
  final int? height;
  final int? durationInSeconds;
  final int? stackCount;
  final String? thumbHash;

  factory Asset.fromJson(String albumId, JsonMap json) {
    return Asset(
      id: json['id'],
      albums: [albumId],
      type: AssetType.fromString(json['type']),
      createdAt: DateTime.parse(json['fileCreatedAt']),
      fileName: json['originalFileName'],
    );
  }

  Asset merge(Asset asset) {
    return Asset(
      id: id,
      albums: [...albums, ...asset.albums],
      type: type,
      createdAt: createdAt,
      fileName: fileName,
    );
  }

  @ignore
  bool get isImage => type == AssetType.image;

  @ignore
  Duration get duration => durationInSeconds == null
      ? Duration.zero
      : Duration(seconds: durationInSeconds!);

  @ignore
  int get stackChildrenCount => stackCount ?? 0;

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
