import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/asset.dart';
import '../../database/database_providers.dart';

typedef UrlRecord = ({String url, Map<String, String> headers});

final videoPlayerUrlProvider =
    Provider.autoDispose.family<UrlRecord, Asset>((ref, asset) {
  final db = ref.watch(DatabaseProviders.service);
  final endpoint = db.getEndpointSync().serverUrl;
  final headers = {'x-immich-user-token': db.getAuthTokenSync()};
  final String videoUrl = asset.livePhotoVideoId != null
      ? '$endpoint/api/assets/${asset.livePhotoVideoId}/video/playback'
      : '$endpoint/api/assets/${asset.id}/video/playback';

  return (url: videoUrl, headers: headers);
});
