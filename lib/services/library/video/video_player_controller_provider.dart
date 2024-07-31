import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../models/asset.dart';
import '../../database/database_providers.dart';


final videoPlayerControllerProvider = FutureProvider.autoDispose
    .family<VideoPlayerController, Asset>((ref, asset) async {
  final db = ref.watch(DatabaseProviders.service);
  final endpoint = db.getEndpointSync().serverUrl;
  final headers = {'x-immich-user-token': db.getAuthTokenSync()};
  final String videoUrl = asset.livePhotoVideoId != null
      ? '$endpoint/assets/${asset.livePhotoVideoId}/video/playback'
      : '$endpoint/assets/${asset.id}/video/playback';
  
  final controller = VideoPlayerController.networkUrl(
    Uri.parse(videoUrl),
    httpHeaders: headers,
    videoPlayerOptions: asset.livePhotoVideoId != null
        ? VideoPlayerOptions(mixWithOthers: true)
        : VideoPlayerOptions(mixWithOthers: false),
  );

  ref.onDispose(() {
    controller.dispose();
  });

  return controller;
});
