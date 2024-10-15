import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit_video/media_kit_video.dart';

import './controls.dart';

class DesktopVideoPlayerControls extends StatefulWidget {
  const DesktopVideoPlayerControls({
    required this.onVisibilityChanged,
    super.key,
  });

  final void Function(bool visible)? onVisibilityChanged;

  @override
  State<DesktopVideoPlayerControls> createState() =>
      _DesktopVideoPlayerControlsState();
}

class _DesktopVideoPlayerControlsState
    extends State<DesktopVideoPlayerControls> {
  late bool mount = _theme(context).visibleOnMount;
  late bool visible = _theme(context).visibleOnMount;

  Timer? _timer;

  late /* private */ var playlist = controller(context).player.state.playlist;
  late bool buffering = controller(context).player.state.buffering;

  DateTime last = DateTime.now();

  final List<StreamSubscription> subscriptions = [];

  void _updateVisibility(bool visible) {
    widget.onVisibilityChanged?.call(visible);
    setState(() {
      this.visible = visible;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (subscriptions.isEmpty) {
      subscriptions.addAll(
        [
          controller(context).player.stream.playlist.listen(
            (event) {
              setState(() {
                playlist = event;
              });
            },
          ),
          controller(context).player.stream.buffering.listen(
            (event) {
              setState(() {
                buffering = event;
              });
            },
          ),
        ],
      );

      if (_theme(context).visibleOnMount) {
        _timer = Timer(
          _theme(context).controlsHoverDuration,
          () => _updateVisibility(false),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  void onTap() {
    if (visible) {
      hideControls();
    } else {
      showControls();
    }
  }

  void showControls() {
    mount = true; // setState called below.
    _updateVisibility(true);
    _timer?.cancel();
    _timer = Timer(
      _theme(context).controlsHoverDuration,
      () => _updateVisibility(false),
    );
  }

  void hideControls() {
    _updateVisibility(false);
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        focusColor: const Color(0x00000000),
        hoverColor: const Color(0x00000000),
        splashColor: const Color(0x00000000),
        highlightColor: const Color(0x00000000),
      ),
      child: CallbackShortcuts(
        bindings: _theme(context).keyboardShortcuts ??
            {
              // Default key-board shortcuts.
              // https://support.google.com/youtube/answer/7631406
              const SingleActivator(LogicalKeyboardKey.mediaPlay): () =>
                  controller(context).player.play(),
              const SingleActivator(LogicalKeyboardKey.mediaPause): () =>
                  controller(context).player.pause(),
              const SingleActivator(LogicalKeyboardKey.mediaPlayPause): () =>
                  controller(context).player.playOrPause(),
              const SingleActivator(LogicalKeyboardKey.mediaTrackNext): () =>
                  controller(context).player.next(),
              const SingleActivator(LogicalKeyboardKey.mediaTrackPrevious):
                  () => controller(context).player.previous(),
              const SingleActivator(LogicalKeyboardKey.space): () =>
                  controller(context).player.playOrPause(),
              const SingleActivator(LogicalKeyboardKey.keyJ): () {
                final rate = controller(context).player.state.position -
                    const Duration(seconds: 10);
                controller(context).player.seek(rate);
              },
              const SingleActivator(LogicalKeyboardKey.keyI): () {
                final rate = controller(context).player.state.position +
                    const Duration(seconds: 10);
                controller(context).player.seek(rate);
              },
              const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
                final rate = controller(context).player.state.position -
                    const Duration(seconds: 2);
                controller(context).player.seek(rate);
              },
              const SingleActivator(LogicalKeyboardKey.arrowRight): () {
                final rate = controller(context).player.state.position +
                    const Duration(seconds: 2);
                controller(context).player.seek(rate);
              },
              const SingleActivator(LogicalKeyboardKey.arrowUp): () {
                final volume = controller(context).player.state.volume + 5.0;
                controller(context).player.setVolume(volume.clamp(0.0, 100.0));
              },
              const SingleActivator(LogicalKeyboardKey.arrowDown): () {
                final volume = controller(context).player.state.volume - 5.0;
                controller(context).player.setVolume(volume.clamp(0.0, 100.0));
              },
              const SingleActivator(LogicalKeyboardKey.keyF): () =>
                  toggleFullscreen(context),
              const SingleActivator(LogicalKeyboardKey.escape): () =>
                  exitFullscreen(context),
            },
        child: Focus(
          autofocus: true,
          child: Material(
            elevation: 0.0,
            borderOnForeground: false,
            animationDuration: Duration.zero,
            color: const Color(0x00000000),
            shadowColor: const Color(0x00000000),
            surfaceTintColor: const Color(0x00000000),
            child: Listener(
              onPointerSignal: _theme(context).modifyVolumeOnScroll
                  ? (e) {
                      if (e is PointerScrollEvent) {
                        if (e.delta.dy > 0) {
                          final volume =
                              controller(context).player.state.volume - 5.0;
                          controller(context)
                              .player
                              .setVolume(volume.clamp(0.0, 100.0));
                        }
                        if (e.delta.dy < 0) {
                          final volume =
                              controller(context).player.state.volume + 5.0;
                          controller(context)
                              .player
                              .setVolume(volume.clamp(0.0, 100.0));
                        }
                      }
                    }
                  : null,
              child: GestureDetector(
                onTapUp: !_theme(context).toggleFullscreenOnDoublePress
                    ? null
                    : (e) {
                        final now = DateTime.now();
                        final difference = now.difference(last);
                        last = now;
                        if (difference < const Duration(milliseconds: 400)) {
                          toggleFullscreen(context);
                        }
                      },
                onPanUpdate: _theme(context).modifyVolumeOnScroll
                    ? (e) {
                        if (e.delta.dy > 0) {
                          final volume =
                              controller(context).player.state.volume - 5.0;
                          controller(context)
                              .player
                              .setVolume(volume.clamp(0.0, 100.0));
                        }
                        if (e.delta.dy < 0) {
                          final volume =
                              controller(context).player.state.volume + 5.0;
                          controller(context)
                              .player
                              .setVolume(volume.clamp(0.0, 100.0));
                        }
                      }
                    : null,
                child: GestureDetector(
                  onTap: onTap,
                  child: Stack(
                    children: [
                      AnimatedOpacity(
                        curve: Curves.easeInOut,
                        opacity: visible ? 1.0 : 0.0,
                        duration: _theme(context).controlsTransitionDuration,
                        onEnd: () {
                          if (!visible) {
                            setState(() {
                              mount = false;
                            });
                          }
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            // Top gradient.
                            if (_theme(context).topButtonBar.isNotEmpty)
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [
                                      0.0,
                                      0.2,
                                    ],
                                    colors: [
                                      Color(0x61000000),
                                      Color(0x00000000),
                                    ],
                                  ),
                                ),
                              ),
                            // Bottom gradient.
                            if (_theme(context).bottomButtonBar.isNotEmpty)
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [
                                      0.5,
                                      1.0,
                                    ],
                                    colors: [
                                      Color(0x00000000),
                                      Color(0x61000000),
                                    ],
                                  ),
                                ),
                              ),
                            if (mount)
                              Padding(
                                padding: _theme(context).padding ??
                                    (
                                        // Add padding in fullscreen!
                                        isFullscreen(context)
                                            ? MediaQuery.of(context).padding
                                            : EdgeInsets.zero),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: _theme(context).buttonBarHeight,
                                      margin:
                                          _theme(context).topButtonBarMargin,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: _theme(context).topButtonBar,
                                      ),
                                    ),
                                    // Only display [primaryButtonBar] if [buffering] is false.
                                    Expanded(
                                      child: AnimatedOpacity(
                                        curve: Curves.easeInOut,
                                        opacity: buffering ? 0.0 : 1.0,
                                        duration: _theme(context)
                                            .controlsTransitionDuration,
                                        child: Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: _theme(context)
                                                .primaryButtonBar,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (_theme(context).displaySeekBar)
                                      Transform.translate(
                                        offset: _theme(context)
                                                .bottomButtonBar
                                                .isNotEmpty
                                            ? const Offset(0.0, 16.0)
                                            : Offset.zero,
                                        child: MaterialDesktopSeekBar(
                                          onSeekStart: () {
                                            _timer?.cancel();
                                          },
                                          onSeekEnd: () {
                                            _timer = Timer(
                                              _theme(context)
                                                  .controlsHoverDuration,
                                              () => _updateVisibility(false),
                                            );
                                          },
                                        ),
                                      ),
                                    if (_theme(context)
                                        .bottomButtonBar
                                        .isNotEmpty)
                                      Container(
                                        height: _theme(context).buttonBarHeight,
                                        margin: _theme(context)
                                            .bottomButtonBarMargin,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children:
                                              _theme(context).bottomButtonBar,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Buffering Indicator.
                      IgnorePointer(
                        child: Padding(
                          padding: _theme(context).padding ??
                              (
                                  // Add padding in fullscreen!
                                  isFullscreen(context)
                                      ? MediaQuery.of(context).padding
                                      : EdgeInsets.zero),
                          child: Column(
                            children: [
                              Container(
                                height: _theme(context).buttonBarHeight,
                                margin: _theme(context).topButtonBarMargin,
                              ),
                              Expanded(
                                child: Center(
                                  child: Center(
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween<double>(
                                        begin: 0.0,
                                        end: buffering ? 1.0 : 0.0,
                                      ),
                                      duration: _theme(context)
                                          .controlsTransitionDuration,
                                      builder: (context, value, child) {
                                        // Only mount the buffering indicator if the opacity is greater than 0.0.
                                        // This has been done to prevent redundant resource usage in [CircularProgressIndicator].
                                        if (value > 0.0) {
                                          return Opacity(
                                            opacity: value,
                                            child: _theme(context)
                                                    .bufferingIndicatorBuilder
                                                    ?.call(context) ??
                                                child!,
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                      child: const CircularProgressIndicator(
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: _theme(context).buttonBarHeight,
                                margin: _theme(context).bottomButtonBarMargin,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [MaterialDesktopVideoControlsThemeData] available in this [context].
  MaterialDesktopVideoControlsThemeData _theme(BuildContext context) =>
      FullscreenInheritedWidget.maybeOf(context) == null
          ? MaterialDesktopVideoControlsTheme.maybeOf(context)?.normal ??
              kDefaultMaterialDesktopVideoControlsThemeData
          : MaterialDesktopVideoControlsTheme.maybeOf(context)?.fullscreen ??
              kDefaultMaterialDesktopVideoControlsThemeDataFullscreen;
}
