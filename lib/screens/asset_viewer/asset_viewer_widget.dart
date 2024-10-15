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
import '../../services/video/cache/video_cache.dart';
import 'asset_viewer_screen_state.dart';
import 'video_viewer/asset_video_viewer.dart';

class AssetViewerWidget extends ConsumerStatefulWidget {
  const AssetViewerWidget({
    required this.viewerState,
    this.onChanged,
    super.key,
  });

  final AssetViewerScreenState viewerState;

  final void Function(Asset asset)? onChanged;

  @override
  ConsumerState<AssetViewerWidget> createState() => _AssetViewerWidgetState();
}

class _AssetViewerWidgetState extends ConsumerState<AssetViewerWidget> {
  late final PageController _controller;
  late final PhotoViewScaleStateController _scaleController;

  // Used to determine scroll direction.
  int _previousIndex = 0;
  int _currentIndex = 0;

  bool _isZoomed = false;
  bool _isPlayingVideo = false;
  Offset? _localPosition;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.viewerState.initialIndex;
    _controller = PageController(initialPage: _currentIndex);
    _scaleController = PhotoViewScaleStateController();
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
      setState(callback);
    }
  }

  Future<void> precacheNextAsset(int index, RenderList renderList) async {
    void onError(Object exception, StackTrace? stackTrace) {
      // swallow error silently
      debugPrint('Error precaching next image: $exception, $stackTrace');
    }

    try {
      if (index < renderList.totalAssets && index >= 0) {
        final asset = renderList.loadAsset(index);

        if (asset.isVideo) {
          await precacheVideo(asset);
        } else {
          await precacheImage(
            ImmichImage.imageProvider(
              asset: asset,
              preferences: ref.watch(PreferencesProviders.service),
            ),
            context,
            onError: onError,
          );
        }
      }
    } catch (e) {
      // swallow error silently
      debugPrint('Error precaching next asset: $e');
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

    // Swipe down
    if (d.dy > sensitivity && ratio > ratioThreshold) {
      ref.read(appBarListenerProvider.notifier).show();
      AppRouter.back(context);
      // Stops AppRouter.back being called twice.
      _localPosition = null;
    }
    // swipe up
    else if (d.dy < -sensitivity && ratio < -ratioThreshold) {
      //   showInfo();
    }

    _setIfMounted(() {
      _isPlayingVideo = false;
    });
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
    final shouldLoopVideo = ref.watch(PreferencesProviders.shouldLoopVideo);
    return PopScope(
      canPop: !_isZoomed,
      onPopInvokedWithResult: (pop, _) {
        if (_isZoomed) {
          _scaleController.reset();
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
        onPageChanged: (index) async {
          _previousIndex = _currentIndex;
          _currentIndex = index;
          final next = _previousIndex < index ? index + 1 : index - 1;

          ref.read(hapticFeedbackProvider.notifier).selectionClick();

          _setIfMounted(() {
            _isPlayingVideo = false;
          });

          // Wait for page change animation to finish
          await Future.delayed(const Duration(milliseconds: 400));
          // Then precache the next image
          unawaited(precacheNextAsset(next, renderList));
          // Notify callback
          widget.onChanged?.call(renderList.loadAsset(index));
        },
        builder: (context, index) {
          final asset = renderList.loadAsset(index);
          final heroTag = index == _currentIndex
              ? '${asset.id}_${widget.viewerState.heroOffset}'
              : '${asset.id}_out_of_view';
          final ImageProvider provider = ImmichImage.imageProvider(
            asset: asset,
            preferences: ref.watch(PreferencesProviders.service),
          );

          if (asset.isImage && !_isPlayingVideo) {
            return PhotoViewGalleryPageOptions(
              onDragStart: (_, details, __) =>
                  _localPosition = details.localPosition,
              onDragUpdate: (_, details, __) =>
                  handleSwipeUpDown(details, renderList),
              onTapDown: (_, __, ___) {
                ref.read(appBarListenerProvider.notifier).toggle();
              },
              onLongPressStart: (_, __, ___) {
                if (asset.livePhotoVideoId != null) {
                  _setIfMounted(() {
                    _isPlayingVideo = true;
                  });
                }
              },
              scaleStateController: _scaleController,
              imageProvider: provider,
              heroAttributes: PhotoViewHeroAttributes(
                tag: heroTag,
                transitionOnUserGestures: true,
              ),
              filterQuality: FilterQuality.high,
              tightMode: true,
              minScale: PhotoViewComputedScale.contained,
              errorBuilder: (context, error, stackTrace) => ImmichImage(
                asset,
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
              scaleStateController: _scaleController,
              heroAttributes: PhotoViewHeroAttributes(
                tag: heroTag,
              ),
              filterQuality: FilterQuality.high,
              maxScale: 1.0,
              minScale: 1.0,
              basePosition: Alignment.center,
              child: AssetVideoViewer(
                key: ValueKey(asset),
                asset: asset,
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
                  asset: renderList.loadAsset(index),
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
