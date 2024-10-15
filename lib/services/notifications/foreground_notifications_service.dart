import 'package:flutter/material.dart';

import '../../core/components/app_snackbar.dart';
import '../../core/main/platform_app.dart';
import '../../immich/asset_grid/immich_thumbnail.dart';
import '../../models/asset.dart';
import '../../routes/app_router.dart';
import '../../screens/asset_viewer/asset_viewer_screen_state.dart';
import 'notifications_service.dart';

class ForegroundNotificationsService extends NotificationsService {
  Future<void> _notify({
    String? title,
    required String content,
    List<Asset> assets = const [],
  }) {
    final context = snackbarKey.currentContext!;

    assert(content.isNotEmpty);

    return AppSnackbar.info(
      context: context,
      title: title,
      message: content,
      image: assets.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(2.0),
              constraints: const BoxConstraints(maxHeight: 60),
              child: ImmichThumbnail(
                asset: assets.first,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            )
          : null,
      onClick: assets.isEmpty
          ? null
          : () {
              AppRouter.toNotificationAssetViewer(
                AssetViewerScreenState.fromAssets(assets, true),
              );
            },
    );
  }

  @override
  Future<void> activity({
    String? title,
    required String content,
    List<Asset> assets = const [],
  }) =>
      _notify(
        title: title,
        content: content,
        assets: assets,
      );

  @override
  Future<void> assets({
    String? title,
    required String content,
    List<Asset> assets = const [],
  }) =>
      _notify(
        title: title,
        content: content,
        assets: assets,
      );
}
