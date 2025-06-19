import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';

import './controls.dart';

class MobileVideoPlayerControls extends StatefulWidget {
  const MobileVideoPlayerControls({
    required this.onVisibilityChanged,
    super.key,
  });

  final void Function(bool visible)? onVisibilityChanged;

  @override
  State<MobileVideoPlayerControls> createState() =>
      _MobileVideoPlayerControlsState();
}

class _MobileVideoPlayerControlsState extends State<MobileVideoPlayerControls> {
  late bool mount = _theme(context).visibleOnMount;
  late bool visible = _theme(context).visibleOnMount;

  Timer? _timer;

  double _brightnessValue = 0.0;
  bool _brightnessIndicator = false;
  Timer? _brightnessTimer;

  double _volumeValue = 0.0;
  bool _volumeIndicator = false;
  Timer? _volumeTimer;
  // The default event stream in package:volume_controller is buggy.
  bool _volumeInterceptEventStream = false;

  late /* private */ var playlist = controller(context).player.state.playlist;
  late bool buffering = controller(context).player.state.buffering;

  bool _mountSeekBackwardButton = false;
  bool _mountSeekForwardButton = false;
  bool _hideSeekBackwardButton = false;
  bool _hideSeekForwardButton = false;

  final ValueNotifier<Duration> _seekBarDeltaValueNotifier =
      ValueNotifier<Duration>(Duration.zero);

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
    // --------------------------------------------------
    // package:screen_brightness
    Future.microtask(() async {
      try {
        await ScreenBrightness().resetApplicationScreenBrightness();
      } catch (_) {}
    });
    // --------------------------------------------------
    super.dispose();
  }

  void onTap() {
    if (!visible) {
      mount = true;
      _updateVisibility(true);
      _timer?.cancel();
      _timer = Timer(
        _theme(context).controlsHoverDuration,
        () => _updateVisibility(false),
      );
    } else {
      _updateVisibility(false);
      _timer?.cancel();
    }
  }

  void onDoubleTapSeekBackward() {
    setState(() {
      _mountSeekBackwardButton = true;
    });
  }

  void onDoubleTapSeekForward() {
    setState(() {
      _mountSeekForwardButton = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // --------------------------------------------------
    // package:volume_controller
    Future.microtask(() async {
      try {
        final vc = VolumeController.instance;
        vc.showSystemUI = false;
        _volumeValue = await vc.getVolume();
        vc.addListener((value) {
          if (mounted && !_volumeInterceptEventStream) {
            setState(() {
              _volumeValue = value;
            });
          }
        });
      } catch (_) {}
    });
    // --------------------------------------------------
    // --------------------------------------------------
    // package:screen_brightness
    Future.microtask(() async {
      try {
        _brightnessValue = await ScreenBrightness().application;
        ScreenBrightness().onApplicationScreenBrightnessChanged.listen((value) {
          if (mounted) {
            setState(() {
              _brightnessValue = value;
            });
          }
        });
      } catch (_) {}
    });
    // --------------------------------------------------
  }

  Future<void> setVolume(double value) async {
    // --------------------------------------------------
    // package:volume_controller
    try {
      VolumeController.instance.setVolume(value);
    } catch (_) {}
    setState(() {
      _volumeValue = value;
      _volumeIndicator = true;
      _volumeInterceptEventStream = true;
    });
    _volumeTimer?.cancel();
    _volumeTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _volumeIndicator = false;
          _volumeInterceptEventStream = false;
        });
      }
    });
    // --------------------------------------------------
  }

  Future<void> setBrightness(double value) async {
    // --------------------------------------------------
    // package:screen_brightness
    try {
      await ScreenBrightness().setApplicationScreenBrightness(value);
    } catch (_) {}
    setState(() {
      _brightnessIndicator = true;
    });
    _brightnessTimer?.cancel();
    _brightnessTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _brightnessIndicator = false;
        });
      }
    });
    // --------------------------------------------------
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
      child: Focus(
        autofocus: true,
        child: Material(
          elevation: 0.0,
          borderOnForeground: false,
          animationDuration: Duration.zero,
          color: const Color(0x00000000),
          shadowColor: const Color(0x00000000),
          surfaceTintColor: const Color(0x00000000),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Volume Indicator.
              AnimatedOpacity(
                curve: Curves.easeInOut,
                opacity: !mount && _volumeIndicator ? 1.0 : 0.0,
                duration: _theme(context).controlsTransitionDuration,
                child: _theme(context)
                        .volumeIndicatorBuilder
                        ?.call(context, _volumeValue) ??
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0x88000000),
                        borderRadius: BorderRadius.circular(64.0),
                      ),
                      height: 52.0,
                      width: 108.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 52.0,
                            width: 42.0,
                            alignment: Alignment.centerRight,
                            child: Icon(
                              _volumeValue == 0.0
                                  ? Icons.volume_off
                                  : _volumeValue < 0.5
                                      ? Icons.volume_down
                                      : Icons.volume_up,
                              color: const Color(0xFFFFFFFF),
                              size: 24.0,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              '${(_volumeValue * 100.0).round()}%',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                        ],
                      ),
                    ),
              ),
              // Brightness Indicator.
              AnimatedOpacity(
                curve: Curves.easeInOut,
                opacity: !mount && _brightnessIndicator ? 1.0 : 0.0,
                duration: _theme(context).controlsTransitionDuration,
                child: _theme(context)
                        .brightnessIndicatorBuilder
                        ?.call(context, _volumeValue) ??
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0x88000000),
                        borderRadius: BorderRadius.circular(64.0),
                      ),
                      height: 52.0,
                      width: 108.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 52.0,
                            width: 42.0,
                            alignment: Alignment.centerRight,
                            child: Icon(
                              _brightnessValue < 1.0 / 3.0
                                  ? Icons.brightness_low
                                  : _brightnessValue < 2.0 / 3.0
                                      ? Icons.brightness_medium
                                      : Icons.brightness_high,
                              color: const Color(0xFFFFFFFF),
                              size: 24.0,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              '${(_brightnessValue * 100.0).round()}%',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                        ],
                      ),
                    ),
              ),
              // Controls:
              AnimatedOpacity(
                curve: Curves.easeInOut,
                opacity: visible ? 1.0 : 0.0,
                duration: _theme(context).controlsTransitionDuration,
                onEnd: () {
                  setState(() {
                    if (!visible) {
                      mount = false;
                    }
                  });
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Fallback from the controls to the video & show/hide controls on tap.
                    Positioned.fill(
                      child: GestureDetector(
                        onVerticalDragUpdate: (e) {
                          onTap();
                        },
                        onHorizontalDragUpdate: (e) {
                          onTap();
                        },
                        child: Container(
                          color: _theme(context).backdropColor,
                        ),
                      ),
                    ),
                    // We are adding 16.0 boundary around the actual controls (which contain the vertical drag gesture detectors).
                    // This will make the hit-test on edges (e.g. swiping to: show status-bar, show navigation-bar, go back in navigation) not activate the swipe gesture annoyingly.
                    Positioned.fill(
                      left: 16.0,
                      top: 16.0,
                      right: 16.0,
                      bottom: 16.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: onTap,
                              onDoubleTap:
                                  !mount && _theme(context).seekOnDoubleTap
                                      ? onDoubleTapSeekBackward
                                      : () {},
                              onVerticalDragUpdate: !mount &&
                                      _theme(context).brightnessGesture
                                  ? (e) async {
                                      final delta = e.delta.dy;
                                      final brightness =
                                          _brightnessValue - delta / 100.0;
                                      final result = brightness.clamp(0.0, 1.0);
                                      setBrightness(result);
                                    }
                                  : null,
                              child: Container(
                                color: const Color(0x00000000),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: onTap,
                              onDoubleTap:
                                  !mount && _theme(context).seekOnDoubleTap
                                      ? onDoubleTapSeekForward
                                      : () {},
                              onVerticalDragUpdate:
                                  !mount && _theme(context).volumeGesture
                                      ? (e) async {
                                          final delta = e.delta.dy;
                                          final volume =
                                              _volumeValue - delta / 100.0;
                                          final result = volume.clamp(0.0, 1.0);
                                          setVolume(result);
                                        }
                                      : null,
                              child: Container(
                                color: const Color(0x00000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (mount)
                      Padding(
                        padding: _theme(context).padding ??
                            MediaQuery.of(context).padding.add(
                                  const EdgeInsets.only(bottom: 12),
                                ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: _theme(context).buttonBarHeight,
                              margin: _theme(context).topButtonBarMargin,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: _theme(context).topButtonBar,
                              ),
                            ),
                            // Only display [primaryButtonBar] if [buffering] is false.
                            Expanded(
                              child: AnimatedOpacity(
                                curve: Curves.easeInOut,
                                opacity: buffering ? 0.0 : 1.0,
                                duration:
                                    _theme(context).controlsTransitionDuration,
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: _theme(context).primaryButtonBar,
                                  ),
                                ),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                if (_theme(context).displaySeekBar)
                                  Padding(
                                    padding: _theme(context).seekBarMargin,
                                    child: MaterialSeekBar(
                                      onSeekStart: () {
                                        _timer?.cancel();
                                      },
                                      onSeekEnd: () {
                                        _timer = Timer(
                                          _theme(context).controlsHoverDuration,
                                          () => _updateVisibility(false),
                                        );
                                      },
                                    ),
                                  ),
                                Container(
                                  height: _theme(context).buttonBarHeight,
                                  margin: _theme(context).bottomButtonBarMargin,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: _theme(context).bottomButtonBar,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // Double-Tap Seek Seek-Bar:
              if (!mount)
                if (_mountSeekBackwardButton || _mountSeekForwardButton)
                  Column(
                    children: [
                      const Spacer(),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          if (_theme(context).displaySeekBar)
                            MaterialSeekBar(
                              delta: _seekBarDeltaValueNotifier,
                            ),
                          Container(
                            height: _theme(context).buttonBarHeight,
                            margin: _theme(context).bottomButtonBarMargin,
                          ),
                        ],
                      ),
                    ],
                  ),
              // Buffering Indicator.
              IgnorePointer(
                child: Padding(
                  padding:
                      _theme(context).padding ?? MediaQuery.of(context).padding,
                  child: Column(
                    children: [
                      Container(
                        height: _theme(context).buttonBarHeight,
                        margin: _theme(context).topButtonBarMargin,
                      ),
                      Expanded(
                        child: Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0.0,
                              end: buffering ? 1.0 : 0.0,
                            ),
                            duration:
                                _theme(context).controlsTransitionDuration,
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
                      Container(
                        height: _theme(context).buttonBarHeight,
                        margin: _theme(context).bottomButtonBarMargin,
                      ),
                    ],
                  ),
                ),
              ),
              // Double-Tap Seek Button(s):
              if (!mount)
                if (_mountSeekBackwardButton || _mountSeekForwardButton)
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          child: _mountSeekBackwardButton
                              ? TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: 0.0,
                                    end: _hideSeekBackwardButton ? 0.0 : 1.0,
                                  ),
                                  duration: const Duration(milliseconds: 200),
                                  builder: (context, value, child) => Opacity(
                                    opacity: value,
                                    child: child,
                                  ),
                                  onEnd: () {
                                    if (_hideSeekBackwardButton) {
                                      setState(() {
                                        _hideSeekBackwardButton = false;
                                        _mountSeekBackwardButton = false;
                                      });
                                    }
                                  },
                                  child: _BackwardSeekIndicator(
                                    onChanged: (value) {
                                      _seekBarDeltaValueNotifier.value = -value;
                                    },
                                    onSubmitted: (value) {
                                      setState(() {
                                        _hideSeekBackwardButton = true;
                                      });
                                      var result = controller(context)
                                              .player
                                              .state
                                              .position -
                                          value;
                                      result = result.clamp(
                                        Duration.zero,
                                        controller(context)
                                            .player
                                            .state
                                            .duration,
                                      );
                                      controller(context).player.seek(result);
                                    },
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _mountSeekForwardButton
                              ? TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: 0.0,
                                    end: _hideSeekForwardButton ? 0.0 : 1.0,
                                  ),
                                  duration: const Duration(milliseconds: 200),
                                  builder: (context, value, child) => Opacity(
                                    opacity: value,
                                    child: child,
                                  ),
                                  onEnd: () {
                                    if (_hideSeekForwardButton) {
                                      setState(() {
                                        _hideSeekForwardButton = false;
                                        _mountSeekForwardButton = false;
                                      });
                                    }
                                  },
                                  child: _ForwardSeekIndicator(
                                    onChanged: (value) {
                                      _seekBarDeltaValueNotifier.value = value;
                                    },
                                    onSubmitted: (value) {
                                      setState(() {
                                        _hideSeekForwardButton = true;
                                      });
                                      var result = controller(context)
                                              .player
                                              .state
                                              .position +
                                          value;
                                      result = result.clamp(
                                        Duration.zero,
                                        controller(context)
                                            .player
                                            .state
                                            .duration,
                                      );
                                      controller(context).player.seek(result);
                                    },
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  // [MaterialVideoControlsThemeData] available in this [context].
  MaterialVideoControlsThemeData _theme(BuildContext context) =>
      const MaterialVideoControlsThemeData(
        bottomButtonBar: [MaterialPositionIndicator()],
        seekBarMargin: EdgeInsets.symmetric(horizontal: 12),
      );
}

class _BackwardSeekIndicator extends StatefulWidget {
  final void Function(Duration) onChanged;
  final void Function(Duration) onSubmitted;
  const _BackwardSeekIndicator({
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  State<_BackwardSeekIndicator> createState() => _BackwardSeekIndicatorState();
}

class _BackwardSeekIndicatorState extends State<_BackwardSeekIndicator> {
  Duration value = const Duration(seconds: 10);

  Timer? timer;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(milliseconds: 400), () {
      widget.onSubmitted.call(value);
    });
  }

  void increment() {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 400), () {
      widget.onSubmitted.call(value);
    });
    widget.onChanged.call(value);
    setState(() {
      value += const Duration(seconds: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0x88767676),
            Color(0x00767676),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: InkWell(
        splashColor: const Color(0x44767676),
        onTap: increment,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.fast_rewind,
                size: 24.0,
                color: Color(0xFFFFFFFF),
              ),
              const SizedBox(height: 8.0),
              Text(
                '${value.inSeconds} seconds',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForwardSeekIndicator extends StatefulWidget {
  final void Function(Duration) onChanged;
  final void Function(Duration) onSubmitted;
  const _ForwardSeekIndicator({
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  State<_ForwardSeekIndicator> createState() => _ForwardSeekIndicatorState();
}

class _ForwardSeekIndicatorState extends State<_ForwardSeekIndicator> {
  Duration value = const Duration(seconds: 10);

  Timer? timer;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(milliseconds: 400), () {
      widget.onSubmitted.call(value);
    });
  }

  void increment() {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 400), () {
      widget.onSubmitted.call(value);
    });
    widget.onChanged.call(value);
    setState(() {
      value += const Duration(seconds: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0x00767676),
            Color(0x88767676),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: InkWell(
        splashColor: const Color(0x44767676),
        onTap: increment,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.fast_forward,
                size: 24.0,
                color: Color(0xFFFFFFFF),
              ),
              const SizedBox(height: 8.0),
              Text(
                '${value.inSeconds} seconds',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
