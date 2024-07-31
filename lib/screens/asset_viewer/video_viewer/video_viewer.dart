import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/asset.dart';
import '../../../routes/app_router.dart';
import '../../../services/library/video/video_player_controller_provider.dart';
import 'delayed_loading_indicator.dart';
import 'video_player.dart';

class VideoViewer extends ConsumerWidget {
  const VideoViewer({
    super.key,
    required this.asset,
    this.isMotionVideo = false,
    this.placeholder,
    this.showControls = true,
    this.hideControlsTimer = const Duration(seconds: 5),
    this.showDownloadingIndicator = true,
    this.loopVideo = false,
  });

  final Asset asset;
  final bool isMotionVideo;
  final Widget? placeholder;
  final Duration hideControlsTimer;
  final bool showControls;
  final bool showDownloadingIndicator;
  final bool loopVideo;

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoController =
        ref.watch(videoPlayerControllerProvider(asset));

    return videoController.when(
      data: (controller) {
        return VideoPlayerWidget(
          controller: controller,
          isMotionVideo: isMotionVideo,
          placeholder: placeholder,
          hideControlsTimer: hideControlsTimer,
          showControls: showControls,
          showDownloadingIndicator: showDownloadingIndicator,
          loopVideo: loopVideo,
        );
      },
      loading: () {
        return const DelayedLoadingIndicator();
      },
      error: (e, _) {
        SchedulerBinding.instance.addPostFrameCallback((_){
          AppRouter.back(context);
        });
        return const SizedBox();

      },
    );
  }
}
