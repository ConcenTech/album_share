import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../immich/asset_grid/asset_grid_data_structure.dart';
import '../../immich/asset_grid/immich_thumbnail.dart';
import '../../immich/common/immich_image.dart';
import '../../immich/extensions/build_context_extensions.dart';
import '../../immich/photo_view/photo_view.dart';
import '../../immich/photo_view/photo_view_gallery.dart';
import '../../immich/providers/haptic_feedback.provider.dart';
import '../../models/asset.dart';
import '../../routes/app_router.dart';
import '../../services/preferences/preferences_providers.dart';
import '../../services/providers/app_bar_listener.dart';
import 'asset_viewer_screen_state.dart';
import 'video_viewer/video_viewer.dart';

//TODO: Videos & stacked images.
class AssetViewerWidget extends ConsumerStatefulWidget {
  const AssetViewerWidget({
    required this.viewerState,
    super.key,
  });

  final AssetViewerScreenState viewerState;

  @override
  ConsumerState<AssetViewerWidget> createState() => _AssetViewerWidgetState();
}

class _AssetViewerWidgetState extends ConsumerState<AssetViewerWidget> {
  late final PageController _controller;
  late Asset _currentAsset;

  int _currentIndex = 0;
  bool _isZoomed = false;
  bool _isPlayingVideo = false;
  Offset? _localPosition;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.viewerState.initialIndex;
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateScaleState(PhotoViewScaleState scaleState) {
    _setIfMounted(() {
      _isZoomed = scaleState != PhotoViewScaleState.initial;
    });
  }

  void _setIfMounted(VoidCallback callback) {
    if (mounted) {
      setState(() {
        callback();
      });
    }
  }

  Future<void> precacheNextImage(int index, RenderList renderList) async {
    void onError(Object exception, StackTrace? stackTrace) {
      // swallow error silently
      debugPrint('Error precaching next image: $exception, $stackTrace');
    }

    try {
      if (index < renderList.totalAssets && index >= 0) {
        final asset = renderList.loadAsset(index);
        await precacheImage(
          ImmichImage.imageProvider(
            asset: asset,
            preferences: ref.watch(PreferencesProviders.service),
          ),
          context,
          onError: onError,
        );
      }
    } catch (e) {
      // swallow error silently
      debugPrint('Error precaching next image: $e');
      if (mounted) {
        AppRouter.back(context);
      }
    }
  }

  void handleSwipeUpDown(DragUpdateDetails details, RenderList renderList) {
    const int sensitivity = 15;
    const int dxThreshold = 50;
    const double ratioThreshold = 3.0;

    if (_isZoomed) {
      return;
    }

    // Guard [localPosition] null
    if (_localPosition == null) {
      return;
    }

    // Check for delta from initial down point
    final d = details.localPosition - _localPosition!;
    // If the magnitude of the dx swipe is large, we probably didn't mean to go down
    if (d.dx.abs() > dxThreshold) {
      return;
    }

    final ratio = d.dy / max(d.dx.abs(), 1);
    if (d.dy > sensitivity && ratio > ratioThreshold) {
      ref.read(appBarListenerProvider.notifier).show();
      AppRouter.back(context);
    }
    // else if (d.dy < -sensitivity && ratio < -ratioThreshold) {
    //   showInfo();
    // }

    _setIfMounted(() {
      _isPlayingVideo = false;
    });

    unawaited(
      // Delay this a bit so we can finish loading the page
      Future.delayed(const Duration(milliseconds: 400)).then(
        // Precache the next image
        (_) => precacheNextImage(_currentIndex + 1, renderList),
      ),
    );
  }

  // void showInfo() {
  //     showModalBottomSheet(
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(15.0)),
  //       ),
  //       barrierColor: Colors.transparent,
  //       isScrollControlled: true,
  //       showDragHandle: true,
  //       enableDrag: true,
  //       context: context,
  //       useSafeArea: true,
  //       builder: (context) {
  //         return FractionallySizedBox(
  //           heightFactor: 0.75,
  //           child: Padding(
  //             padding: EdgeInsets.only(
  //               bottom: MediaQuery.viewInsetsOf(context).bottom,
  //             ),
  //             child: ref
  //                     .watch(appSettingsServiceProvider)
  //                     .getSetting<bool>(AppSettingsEnum.advancedTroubleshooting)
  //                 ? AdvancedBottomSheet(assetDetail: asset)
  //                 : ExifBottomSheet(asset: asset),
  //           ),
  //         );
  //       },
  //     );
  //   }

  RenderList get renderList => widget.viewerState.renderList;

  @override
  Widget build(BuildContext context) {
    _currentAsset = renderList.loadAsset(_currentIndex);
    final shouldLoopVideo = ref.watch(PreferencesProviders.shouldLoopVideo);
    //TODO: waiting on framework update for PopScope to work as expected.
    // https://github.com/flutter/flutter/issues/138737
    return PopScope(
      canPop: !_isZoomed,
      onPopInvoked: (pop) {
        if (!pop) {
          _setIfMounted(() {
            _isZoomed = false;
          });
        }
      },
      child: PhotoViewGallery.builder(
        pageController: _controller,
        itemCount: renderList.totalAssets,
        scrollDirection: Axis.horizontal,
        scrollPhysics: _isZoomed
            ? const NeverScrollableScrollPhysics() // Don't allow paging while scrolled in
            : (Platform.isIOS
                ? const ScrollPhysics() // Use bouncing physics for iOS
                : const ClampingScrollPhysics() // Use heavy physics for Android
            ),
        scaleStateChangedCallback: _updateScaleState,
        onPageChanged: (value) async {
          final next = _currentIndex < value ? value + 1 : value - 1;

          ref.read(hapticFeedbackProvider.notifier).selectionClick();

          _currentIndex = value;
          _isPlayingVideo = false;

          // Wait for page change animation to finish
          await Future.delayed(const Duration(milliseconds: 400));
          // Then precache the next image
          unawaited(precacheNextImage(next, renderList));
        },
        builder: (context, index) {
          final a = index == _currentIndex
              ? _currentAsset
              : renderList.loadAsset(index);
          final ImageProvider provider = ImmichImage.imageProvider(
            asset: a,
            preferences: ref.watch(PreferencesProviders.service),
          );

          if (a.isImage && !_isPlayingVideo) {
            return PhotoViewGalleryPageOptions(
              onDragStart: (_, details, __) =>
                  _localPosition = details.localPosition,
              onDragUpdate: (_, details, __) =>
                  handleSwipeUpDown(details, renderList),
              onTapDown: (_, __, ___) {
                ref.read(appBarListenerProvider.notifier).toggle();
              },
              onLongPressStart: (_, __, ___) {
                if (_currentAsset.livePhotoVideoId != null) {
                  _setIfMounted(() {
                    _isPlayingVideo = true;
                  });
                }
              },
              imageProvider: provider,
              heroAttributes: PhotoViewHeroAttributes(
                tag: '${_currentAsset.id}_${widget.viewerState.heroOffset}',
                transitionOnUserGestures: true,
              ),
              filterQuality: FilterQuality.high,
              tightMode: true,
              minScale: PhotoViewComputedScale.contained,
              errorBuilder: (context, error, stackTrace) => ImmichImage(
                a,
                fit: BoxFit.contain,
              ),
            );
          } else {
            return PhotoViewGalleryPageOptions.customChild(
              onDragStart: (_, details, __) {
                _setIfMounted(() {
                  _localPosition = details.localPosition;
                });
              },
              onDragUpdate: (_, details, __) {
                handleSwipeUpDown(details, renderList);
              },
              heroAttributes: PhotoViewHeroAttributes(
                tag: '${_currentAsset.id}_${widget.viewerState.heroOffset}',
              ),
              filterQuality: FilterQuality.high,
              maxScale: 1.0,
              minScale: 1.0,
              basePosition: Alignment.center,
              child: VideoViewer(
                key: ValueKey(a),
                asset: a,
                isMotionVideo: a.livePhotoVideoId != null,
                loopVideo: shouldLoopVideo,
                placeholder: Image(
                  image: provider,
                  fit: BoxFit.contain,
                  height: context.height,
                  width: context.width,
                  alignment: Alignment.center,
                ),
              ),
            );
          }
        },
        loadingBuilder: (context, event, index) {
          return ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ),
                ),
                ImmichThumbnail(
                  asset: _currentAsset,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
