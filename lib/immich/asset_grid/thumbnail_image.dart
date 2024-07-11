import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/asset.dart';
import '../extensions/build_context_extensions.dart';
import 'immich_thumbnail.dart';

class ThumbnailImage extends ConsumerWidget {
  /// The asset to show the thumbnail image for
  final Asset asset;

  /// Whether to show the show stack icon over the image or not
  final bool showStack;

  /// The offset index to apply to this hero tag for animation
  final int heroOffset;

  const ThumbnailImage({
    super.key,
    required this.asset,
    this.showStack = false,
    this.heroOffset = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetContainerColor = context.isDarkTheme
        ? Colors.blueGrey
        : context.themeData.primaryColorLight;

    Widget buildVideoIcon() {
      final minutes = asset.duration.inMinutes;
      final durationString = asset.duration.toString();
      return Positioned(
        top: 5,
        right: 8,
        child: Row(
          children: [
            Text(
              minutes > 59
                  ? durationString.substring(0, 7) // h:mm:ss
                  : minutes > 0
                      ? durationString.substring(2, 7) // mm:ss
                      : durationString.substring(3, 7), // m:ss
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            const Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      );
    }

    Widget buildStackIcon() {
      return Positioned(
        top: !asset.isImage ? 28 : 5,
        right: 8,
        child: Row(
          children: [
            if (asset.stackChildrenCount > 1)
              Text(
                "${asset.stackChildrenCount}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (asset.stackChildrenCount > 1)
              const SizedBox(
                width: 3,
              ),
            const Icon(
              Icons.burst_mode_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      );
    }

    Widget buildImage() {
    return SizedBox(
        width: 300,
        height: 300,
        child: Hero(
          tag: asset.isarId + heroOffset,
          child: ImmichThumbnail(
            asset: asset,
            height: 250,
            width: 250,
          ),
        ),
      );
    }

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.decelerate,
          child: buildImage(),
        ),
        if (!asset.isImage) buildVideoIcon(),
        if (asset.stackChildrenCount > 0) buildStackIcon(),
      ],
    );
  }
}
