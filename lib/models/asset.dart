import 'package:isar/isar.dart';

import '../core/utils/extension_methods.dart';
import 'json_map.dart';

part 'asset.g.dart';

@collection
class Asset {
  const Asset({
    required this.id,
    required this.ownerId,
    required this.albums,
    required this.type,
    required this.createdAt,
    required this.fileName,
    required this.width,
    required this.height,
    required this.durationString,
    required this.stackCount,
    required this.thumbHash,
    required this.livePhotoVideoId,
  });

  Id get isarId => Isar.autoIncrement;

  final String id;
  final String ownerId;

  /// A list of album ids associated with this asset.
  final List<String> albums;
  @enumerated
  final AssetType type;
  final DateTime createdAt;
  final String fileName;

  final int? width;
  final int? height;
  final String? durationString;
  final int? stackCount;
  final String? thumbHash;
  final String? livePhotoVideoId;

  factory Asset.fromJson(String albumId, JsonMap json) {
    final exif = json['exifInfo'] as Map<String, dynamic>?;
    return Asset(
      id: json['id'],
      ownerId: json['ownerId'],
      albums: [albumId],
      type: AssetType.fromString(json['type']),
      createdAt: DateTime.parse(json['fileCreatedAt']),
      fileName: json['originalFileName'],
      height: exif?['exifImageHeight'] as int?,
      width: exif?['exifImageWidth'] as int?,
      stackCount: json['stackCount'] as int?,
      durationString: json['duration'] as String?,
      thumbHash: json['thumbhash'] as String,
      livePhotoVideoId: json['livePhotoVideoId'] as String?,
    );
  }

  Asset merge(Asset asset) {
    assert(this == asset);
    final newAlbums = asset.albums.where((e) => !albums.contains(e));
    return Asset(
      id: id,
      ownerId: ownerId,
      albums: [...newAlbums, ...albums],
      type: type,
      createdAt: createdAt,
      fileName: fileName,
      durationString: durationString,
      height: height,
      width: width,
      stackCount: stackCount,
      thumbHash: thumbHash,
      livePhotoVideoId: livePhotoVideoId,
    );
  }

  String videoUrl(String serverUrl) {
    return livePhotoVideoId != null
        ? '$serverUrl/api/assets/$livePhotoVideoId/video/playback'
        : '$serverUrl/api/assets/$id/video/playback';
  }

  @ignore
  bool get isImage => type == AssetType.image;

  @ignore
  bool get isVideo => type == AssetType.video;

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

extension AssetListSorter on List<Asset> {
  List<Asset> sorted() {
    return [...this]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void merge(List<Asset> assets) {
    if (isEmpty) {
      addAll(assets);
      return;
    }
    final a = this;
    for (var asset in assets) {
      final ind = a.indexWhere((ass) => ass.id == asset.id);
      if (ind == -1) {
        a.add(asset);
      } else {
        a[ind] = a[ind].merge(asset);
      }
    }
  }

  List<Asset> merged(List<Asset> assets) {
    return [...this]..merge(assets);
  }
}
