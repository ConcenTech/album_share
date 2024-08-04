import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../models/asset.dart';
import '../../../services/library/video/video_player_url_provider.dart';
import '../../../services/providers/app_bar_listener.dart';

class VideoViewer extends ConsumerWidget {
  const VideoViewer({
    super.key,
    required this.asset,
    this.isMotionVideo = false,
    this.placeholder,
    this.showControls = true,
    this.loopVideo = false,
  });

  final Asset asset;
  final bool isMotionVideo;
  final Widget? placeholder;
  final bool showControls;
  final bool loopVideo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlProvider = ref.watch(videoPlayerUrlProvider(asset));

    return SizedBox.fromSize(
      size: MediaQuery.sizeOf(context),
      child: VideoPlayer.url(
        url: urlProvider.url,
        headers: urlProvider.headers,
        showControls: showControls && !isMotionVideo,
        loop: loopVideo,
        onControlsViewChanged: (show) {
          final notifier = ref.read(appBarListenerProvider.notifier);
          if (show) {
            notifier.show(true);
          } else {
            notifier.hide(true);
          }
        },
      ),
    );
  }
}
