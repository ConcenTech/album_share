
import '../../models/album.dart';
import '../../models/asset.dart';
import '../../services/database/database_service.dart';
import '../asset_media_size.dart';

String getThumbnailUrl(
  final Asset asset, {
  AssetMediaSize type = AssetMediaSize.thumbnail,
}) {
  return getThumbnailUrlForRemoteId(asset.id, type: type);
}

String getThumbnailCacheKey(
  final Asset asset, {
  AssetMediaSize type = AssetMediaSize.thumbnail,
}) {
  return getThumbnailCacheKeyForRemoteId(asset.id, type: type);
}

String getThumbnailCacheKeyForRemoteId(
  final String id, {
  AssetMediaSize type = AssetMediaSize.thumbnail,
}) {
  if (type == AssetMediaSize.thumbnail) {
    return 'thumbnail-image-$id';
  } else {
    return '${id}_previewStage';
  }
}

String getAlbumThumbnailUrl(
  final Album album, {
  AssetMediaSize type = AssetMediaSize.thumbnail,
}) {
  if (album.thumbnailId.isEmpty) {
    return '';
  }
  return getThumbnailUrlForRemoteId(
    album.thumbnailId,
    type: type,
  );
}

String getAlbumThumbNailCacheKey(
  final Album album, {
  AssetMediaSize type = AssetMediaSize.thumbnail,
}) {
  if (album.thumbnailId.isEmpty) {
    return '';
  }
  return getThumbnailCacheKeyForRemoteId(
    album.thumbnailId,
    type: type,
  );
}

String getImageUrl(final Asset asset) {
  return getImageUrlFromId(asset.id);
}

String get _endpoint => DatabaseService.instance.getEndpointSync().serverUrl;

String getImageUrlFromId(final String id) {
  return '$_endpoint/api/assets/$id/thumbnail?size=preview';
}

String getImageCacheKey(final Asset asset) {
  return '${asset.id}_fullStage';
}

String getThumbnailUrlForRemoteId(
  final String id, {
  AssetMediaSize type = AssetMediaSize.thumbnail,
}) {
  return '$_endpoint/api/assets/$id/thumbnail?size=${type.name}';
}

String getFaceThumbnailUrl(final String personId) {
  return '$_endpoint/api/people/$personId/thumbnail';
}
