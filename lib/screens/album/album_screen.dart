import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/scaffold/app_scaffold.dart';
import '../../core/components/titlebar_buttons/refresh_button.dart';
import '../../core/utils/platform_utils.dart';
import '../../immich/asset_grid/immich_asset_grid_view.dart';
import '../../models/album.dart';
import '../../routes/app_router.dart';
import '../../services/sync/foreground_sync_service_provider.dart';
import '../../services/library/library_providers.dart';
import '../../services/preferences/preferences_providers.dart';
import '../library/library_screen.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({
    required this.album,
    super.key,
  });

  static const id = 'album_screen';

  final Album album;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      id: id,
      showTitleBar: true,
      showBackButton: true,
      header: album.name,
      titleBarIcons: const [MaybeRefreshButton()],
      body: _AlbumsScreen(album),
    );
  }
}

class _AlbumsScreen extends ConsumerWidget {
  const _AlbumsScreen(this.album);

  final Album album;

  Future<void> _refresh(WidgetRef ref) {
    return ref.read(foregroundSyncServiceProvider.notifier).update();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Consumer(builder: (context, ref, child) {
        final syncService = ref.watch(foregroundSyncServiceProvider);

        if (syncService.firstRun && !syncService.assets) {
          return const BuildingLibraryWidget();
        }

        final libraryProvider = ref.watch(LibraryProviders.assetsFor(album));

        return libraryProvider.when(
          data: (assets) {
            final maxExtent = ref.watch(PreferencesProviders.maxExtent);
            final dynamicLayout = ref.watch(PreferencesProviders.dynamicLayout);
            final renderList = ref.watch(LibraryProviders.renderList(assets));

            return Padding(
              padding: const EdgeInsets.only(left: 4),
              child: ScrollConfiguration(
                // Remove default scroll bar
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ImmichAssetGridView(
                  alwaysVisibleScrollThumb: forPlatform(
                    desktop: () => true,
                    mobile: () => false,
                  ),
                  dynamicLayout: dynamicLayout,
                  showStack: true,
                  renderList: renderList,
                  assetMaxExtent: maxExtent,
                  onRefresh: platformValue(
                    desktop: null,
                    mobile: () => _refresh(ref),
                  ),
                  onTap: (state) {
                    AppRouter.toAssetViewer(context, state.withAlbum(album));
                  },
                ),
              ),
            );
          },
          error: (e, _) {
            return Center(
              child: Text('$e'),
            );
          },
          loading: () {
            return const SizedBox();
          },
        );
      }),
    );
  }
}
