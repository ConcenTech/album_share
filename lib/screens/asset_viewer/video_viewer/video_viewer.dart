import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../services/providers/app_bar_listener.dart';

class VideoViewer extends ConsumerWidget {
  const VideoViewer({
    super.key,
    required this.path,
    this.isMotionVideo = false,
    this.placeholder,
    this.showControls = true,
    this.loopVideo = false,
  });

  final String path;
  final bool isMotionVideo;
  final Widget? placeholder;
  final bool showControls;
  final bool loopVideo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.fromSize(
      size: MediaQuery.sizeOf(context),
      child: VideoPlayer.asset(
        path: path,
        showControls: showControls && !isMotionVideo,
        loop: loopVideo,
        onControlsViewChanged: (show) {
          // onControlsViewChanged fires some time after widget is disposed.
          if (!context.mounted) {
            return;
          }
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
