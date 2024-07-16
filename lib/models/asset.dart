import 'package:album_share/core/utils/extension_methods.dart';
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
    required this.width,
    required this.height,
    required this.durationString,
    required this.stackCount,
    required this.thumbHash,
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
  final String? durationString;
  final int? stackCount;
  final String? thumbHash;

  factory Asset.fromJson(String albumId, JsonMap json) {
    final exif = json['exifInfo'] as Map<String, dynamic>?;
    return Asset(
      id: json['id'],
      albums: [albumId],
      type: AssetType.fromString(json['type']),
      createdAt: DateTime.parse(json['fileCreatedAt']),
      fileName: json['originalFileName'],
      height: exif?['exifImageHeight'] as int?,
      width: exif?['exifImageWidth'] as int?,
      stackCount: json['stackCount'] as int?,
      durationString: json['duration'] as String?,
      thumbHash: json['thumbhash'] as String,
    );
  }

  Asset merge(Asset asset) {
    return Asset(
      id: id,
      albums: [...albums, ...asset.albums],
      type: type,
      createdAt: createdAt,
      fileName: fileName,
      durationString: durationString,
      height: height,
      width: width,
      stackCount: stackCount,
      thumbHash: thumbHash,
    );
  }

  @ignore
  bool get isImage => type == AssetType.image;

  @ignore
  Duration get duration => durationString?.toDuration() ?? Duration.zero;

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
