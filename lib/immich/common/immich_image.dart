import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:octo_image/octo_image.dart';

import '../../models/asset.dart';
import '../../models/preferences.dart';
import '../../services/preferences/preferences_providers.dart';
import '../asset_grid/thumbnail_placeholder.dart';
import '../extensions/build_context_extensions.dart';
import '../image/immich_remote_image_provider.dart';

class ImmichImage extends ConsumerWidget {
  const ImmichImage(
    this.asset, {
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder = const ThumbnailPlaceholder(),
    super.key,
  });

  final Asset? asset;
  final Widget? placeholder;
  final double? width;
  final double? height;
  final BoxFit fit;

  // Helper function to return the image provider for the asset
  // either by using the asset ID or the asset itself
  /// [asset] is the Asset to request, or else use [assetId] to get a remote
  /// image provider
  /// Use [isThumbnail] and [thumbnailSize] if you'd like to request a thumbnail
  /// The size of the square thumbnail to request. Ignored if isThumbnail
  /// is not true
  static ImageProvider imageProvider({
    Asset? asset,
    String? assetId,
    required Preferences preferences,
  }) {
    if (asset == null && assetId == null) {
      throw Exception('Must supply either asset or assetId');
    }

    return ImmichRemoteImageProvider(
      assetId: assetId ?? asset!.id,
      preferences: preferences,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (asset == null) {
      return Container(
        color: Colors.grey,
        width: width,
        height: height,
        child: const Center(
          child: Icon(Icons.no_photography),
        ),
      );
    }

    return OctoImage(
      fadeInDuration: const Duration(milliseconds: 0),
      fadeOutDuration: const Duration(milliseconds: 200),
      placeholderBuilder: (context) {
        if (placeholder != null) {
          // Use the gray box placeholder
          return placeholder!;
        }
        // No placeholder
        return const SizedBox();
      },
      image: ImmichImage.imageProvider(
        preferences: ref.watch(PreferencesProviders.service),
        asset: asset,
      ),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        if (error is PlatformException &&
            error.code == "The asset not found!") {
          debugPrint(
            "Asset ${asset?.id} does not exist anymore on device!",
          );
        } else {
          debugPrint(
            "Error getting thumb for assetId=${asset?.id}: $error",
          );
        }
        return Icon(
          Icons.image_not_supported_outlined,
          color: context.primaryColor,
        );
      },
    );
  }
}
