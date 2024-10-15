import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/platform_utils.dart';
import '../../immich/asset_grid/asset_grid_data_structure.dart';
import '../../immich/asset_grid/immich_asset_grid_view.dart';
import '../../routes/app_router.dart';
import '../../services/sync/foreground_sync_service_provider.dart';

class LibraryScrollView extends ConsumerStatefulWidget {
  const LibraryScrollView({
    required this.dynamicLayout,
    required this.renderList,
    required this.maxExtent,
    super.key,
  });

  final bool dynamicLayout;
  final RenderList renderList;
  final int maxExtent;

  @override
  ConsumerState<LibraryScrollView> createState() => _LibraryScrollViewState();
}

class _LibraryScrollViewState extends ConsumerState<LibraryScrollView>
    with AutomaticKeepAliveClientMixin {
  Future<void> _refresh(WidgetRef ref) {
    return ref.read(foregroundSyncServiceProvider.notifier).update();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: ScrollConfiguration(
        // Remove default scroll bar
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ImmichAssetGridView(
          alwaysVisibleScrollThumb: forPlatform(
            desktop: () => true,
            mobile: () => false,
          ),
          dynamicLayout: widget.dynamicLayout,
          showStack: true,
          renderList: widget.renderList,
          assetMaxExtent: widget.maxExtent,
          onRefresh: platformValue(
            desktop: null,
            mobile: () => _refresh(ref),
          ),
          onTap: (state) {
            AppRouter.toAssetViewer(context, state);
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
