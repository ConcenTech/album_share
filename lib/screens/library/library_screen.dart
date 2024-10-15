import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:octo_image/octo_image.dart';

import '../../core/components/scaffold/app_navigation_scaffold.dart';
import '../../core/components/scaffold/app_scaffold.dart';
import '../../core/components/sidebar/notifications_sidebar.dart';
import '../../core/components/titlebar_buttons/notification_button.dart';
import '../../core/components/titlebar_buttons/preferences_button.dart';
import '../../core/components/titlebar_buttons/refresh_button.dart';
import '../../core/dialogs/background_sync_dialog.dart';
import '../../core/utils/app_localisations.dart';
import '../../core/utils/platform_utils.dart';
import '../../immich/asset_grid/immich_thumbnail.dart';
import '../../models/album.dart';
import '../../routes/app_router.dart';
import '../../services/database/database_service.dart';
import '../../services/library/library_providers.dart';
import '../../services/preferences/preferences_providers.dart';
import '../../services/sync/background_sync_service.dart';
import '../../services/sync/foreground_sync_service_provider.dart';
import 'library_scroll_view.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  static const id = 'library_screen';

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    _getBackgroundPermissions();
  }

  void _getBackgroundPermissions() async {
    if (!BackgroundSyncService.isSupportedPlatform()) {
      return;
    }
    final prefs = await DatabaseService.instance.getPreferences();
    if (prefs?.backgroundSync == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showBackgroundSyncDialog(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigationScaffold(
      id: LibraryScreen.id,
      showBackButton: false,
      sidebar: const NotificationSidebar(),
      titleBarIcons: const [
        MaybeRefreshButton(),
        PreferencesButton(),
        NotificationButton(LibraryScreen.id),
      ],
      screens: [
        NavigationBarItem(
          builder: (_) => const _AllAssetsScreen(),
          icon: Icon(isCupertino
              ? CupertinoIcons.photo
              : Icons.photo_library_outlined),
          selectedIcon: Icon(isCupertino //
              ? CupertinoIcons.photo_fill
              : Icons.photo_library),
          label: 'Timeline',
        ),
        NavigationBarItem(
          builder: (_) => const _AlbumsScreen(),
          icon:
              Icon(isCupertino ? CupertinoIcons.folder : Icons.folder_outlined),
          selectedIcon: Icon(isCupertino //
              ? CupertinoIcons.folder_fill
              : Icons.folder),
          label: 'Albums',
        ),
      ],
    );
  }
}

class _AllAssetsScreen extends StatelessWidget {
  const _AllAssetsScreen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer(builder: (context, ref, child) {
        final syncService = ref.watch(foregroundSyncServiceProvider);

        if (syncService.firstRun && !syncService.assets) {
          return const BuildingLibraryWidget();
        }

        final libraryProvider = ref.watch(LibraryProviders.assets);

        return libraryProvider.when(
          data: (assets) {
            final maxExtent = ref.watch(PreferencesProviders.maxExtent);
            final dynamicLayout = ref.watch(PreferencesProviders.dynamicLayout);
            final renderList = ref.watch(LibraryProviders.renderList(assets));

            return LibraryScrollView(
              maxExtent: maxExtent,
              dynamicLayout: dynamicLayout,
              renderList: renderList,
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

class _AlbumsScreen extends ConsumerWidget {
  const _AlbumsScreen();

  void _onTap(BuildContext context, Album album) {
    AppRouter.toAlbum(context, album);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncService = ref.watch(foregroundSyncServiceProvider);

    if (syncService.firstRun && !syncService.assets) {
      return const BuildingLibraryWidget();
    }

    final albumsProvider = ref.watch(LibraryProviders.albums);

    return albumsProvider.when(
      data: (albums) {
        return GridView.builder(
          itemCount: albums.length,
          itemBuilder: (context, index) {
            final album = albums[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onTap(context, album),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: OctoImage(
                        placeholderFadeInDuration: Duration.zero,
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: const Duration(milliseconds: 100),
                        // octoSet: blurHashOrPlaceholder(blurhash),
                        image: ImmichThumbnail.imageProvider(
                          assetId: album.thumbnailId,
                        ),
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(album.name, maxLines: 1),
                )
              ],
            );
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          padding: EdgeInsets.symmetric(
            vertical: AppScaffold.appBarHeight(context),
            horizontal: 4,
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
  }
}

class BuildingLibraryWidget extends StatelessWidget {
  const BuildingLibraryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
        Text(AppLocalizations.of(context)!.buildingLibrary)
      ],
    );
  }
}
