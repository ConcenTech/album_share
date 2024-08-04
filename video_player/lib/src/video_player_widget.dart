import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_player/src/controls/controls.dart';

class VideoPlayer extends StatefulWidget {
  static void ensureInitialized() => MediaKit.ensureInitialized();

  const VideoPlayer({
    required this.media,
    required this.loop,
    required this.autoPlay,
    required this.showControls,
    this.onControlsViewChanged,
    this.onReady,
    super.key,
  });

  VideoPlayer.url({
    required String url,
    Map<String, String> headers = const {},
    this.loop = true,
    this.autoPlay = true,
    this.showControls = true,
    this.onControlsViewChanged,
    this.onReady,
    super.key,
  }) : media = Media(url, httpHeaders: headers);

  final Media media;

  final bool loop;
  final bool autoPlay;
  final bool showControls;
  final void Function(bool show)? onControlsViewChanged;

  final VoidCallback? onReady;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  Player? _player;
  VideoController? _controller;

  @override
  void initState() {
    super.initState();
    _setPlayer();
  }

  void _setPlayer() {
    _player?.dispose();
    _player = Player(
      configuration: PlayerConfiguration(ready: widget.onReady),
    );
    _controller = VideoController(_player!);
    _player!.open(widget.media, play: widget.autoPlay);
    _player!
        .setPlaylistMode(widget.loop ? PlaylistMode.single : PlaylistMode.none);
  }

  @override
  void didUpdateWidget(covariant VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media != widget.media) {
      _setPlayer();
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Placeholder();
    }
    return Video(
      controller: _controller!,
      controls: widget.showControls
          ? (state) => VideoPlayerControls(
                state: state,
                onVisibilityChanged: widget.onControlsViewChanged,
              )
          : NoVideoControls,
    );
  }
}
