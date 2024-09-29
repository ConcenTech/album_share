import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../immich/asset_grid/immich_thumbnail.dart';
import '../../../models/activity.dart';
import '../../../models/asset.dart';
import '../../../routes/app_router.dart';
import '../../../screens/asset_viewer/asset_viewer_screen_state.dart';
import '../../../services/activity/activity_providers.dart';
import '../../../services/database/database_providers.dart';
import '../../utils/app_localisations.dart';
import 'app_sidebar.dart';

class NotificationSidebar extends AppSidebar {
  const NotificationSidebar({super.key});

  @override
  AutoDisposeStreamProvider providerBuilder() {
    return ActivityProviders.notifications;
  }

  @override
  Widget itemBuilder(BuildContext context, Activity activity) {
    return _ActivityContentBuilder(activity);
  }
}

class _ActivityContentBuilder extends ConsumerWidget {
  const _ActivityContentBuilder(this.activity);

  final Activity activity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Asset? asset;

    if (activity.assetId != null) {
      asset = ref
          .watch(DatabaseProviders.asset(activity.assetId!))
          .whenOrNull(data: (d) => d);
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: ImmichThumbnail(
              asset: asset,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(activity.describe(AppLocalizations.of(context)!, asset)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (activity.comment != null)
              Text(
                activity.comment!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                activity.approximateTimeAgo(),
                style: theme.textTheme.labelSmall,
              ),
            ),
          ],
        ),
        isThreeLine: activity.comment != null,
        titleTextStyle: theme.textTheme.labelMedium,
        subtitleTextStyle: theme.textTheme.bodySmall,
        onTap: asset == null
            ? null
            : () async {
                AppRouter.toAssetViewer(
                  context,
                  AssetViewerScreenState.fromAssets([asset!], true),
                );
              },
      ),
    );
  }
}
