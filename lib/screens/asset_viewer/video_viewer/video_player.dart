import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'delayed_loading_indicator.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.controller,
    required this.isMotionVideo,
    this.placeholder,
    required this.hideControlsTimer,
    required this.showControls,
    required this.showDownloadingIndicator,
    required this.loopVideo,
  });

  final VideoPlayerController controller;
  final bool isMotionVideo;
  final Widget? placeholder;
  final Duration hideControlsTimer;
  final bool showControls;
  final bool showDownloadingIndicator;
  final bool loopVideo;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  ChewieController? _controller;

  @override
  void initState() {
    super.initState();
    _setController();
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controllerRebuildRequired(oldWidget)) {
      _setController();
    }
  }

  bool _controllerRebuildRequired(VideoPlayerWidget oldWidget) {
    return widget.controller != oldWidget.controller ||
        widget.placeholder != oldWidget.placeholder ||
        widget.hideControlsTimer != oldWidget.hideControlsTimer ||
        widget.showControls != oldWidget.showControls ||
        widget.isMotionVideo != oldWidget.isMotionVideo ||
        widget.loopVideo != oldWidget.loopVideo;
  }

  void _setController() {
    _controller?.dispose();
    _controller = ChewieController(
      videoPlayerController: widget.controller,
      controlsSafeAreaMinimum: const EdgeInsets.only(
        bottom: 100,
      ),
      placeholder: SizedBox.expand(child: widget.placeholder),

      // customControls: CustomVideoPlayerControls(
      //   hideTimerDuration: widget.hideControlsTimer,
      // ),
      showControls: widget.showControls && !widget.isMotionVideo,
      hideControlsTimer: widget.hideControlsTimer,
      looping: widget.loopVideo,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Unlikely but possible.
    if (_controller == null) {
      return widget.placeholder ??
          const DelayedLoadingIndicator(
            fadeInDuration: Duration(milliseconds: 500),
          );
    }
    return Chewie(
      controller: _controller!,
    );
  }
}
