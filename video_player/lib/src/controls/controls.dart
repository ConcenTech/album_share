import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/widgets/video_controls_theme_data_injector.dart';

import './desktop_controls.dart';
import './mobile_controls.dart';

typedef VisibilityCallback = void Function(bool visible);

class VideoPlayerControls extends StatelessWidget {
  const VideoPlayerControls({
    required this.state,
    required this.onVisibilityChanged,
    super.key,
  });

  final VideoState state;
  final VisibilityCallback? onVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    return VideoControlsThemeDataInjector(
      child: switch (Theme.of(state.context).platform) {
        TargetPlatform.android ||
        TargetPlatform.iOS ||
        TargetPlatform.fuchsia =>
          MobileVideoPlayerControls(
            onVisibilityChanged: onVisibilityChanged,
          ),
        TargetPlatform.linux ||
        TargetPlatform.macOS ||
        TargetPlatform.windows =>
          DesktopVideoPlayerControls(
            onVisibilityChanged: onVisibilityChanged,
          ),
      },
    );
  }
}

/// Returns the [VideoController] associated with the [Video] present in the current [BuildContext].
VideoController controller(BuildContext context) =>
    VideoStateInheritedWidget.of(context).state.widget.controller;
