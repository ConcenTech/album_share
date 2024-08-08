import 'package:album_share/core/utils/app_localisations.dart';
import 'package:album_share/core/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/scaffold/app_scaffold.dart';
import '../../core/components/titlebar_buttons/preferences_button.dart';
import '../../core/components/titlebar_buttons/refresh_button.dart';
import '../../immich/asset_grid/immich_asset_grid_view.dart';
import '../../services/library/library_providers.dart';
import '../../services/preferences/preferences_providers.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showTitleBar: true,
      titleBarIcons: const [RefreshButton(), PreferencesButton()],
      body: Center(
        child: Consumer(builder: (context, ref, child) {
          final libraryProvider = ref.watch(LibraryProviders.state);

          return libraryProvider.when(
            building: () {
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
            },
            built: (_) {
              final maxExtent = ref.watch(PreferencesProviders.maxExtent);
              final renderList = ref.watch(LibraryProviders.renderList);

              return renderList.when(
                data: (renderList) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: ScrollConfiguration(
                      // Remove default scroll bar
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: ImmichAssetGridView(
                        alwaysVisibleScrollThumb: forPlatform(
                          desktop: () => true,
                          mobile: () => false,
                        ),
                        dynamicLayout: false,
                        showStack: true,
                        renderList: renderList,
                        assetMaxExtent: maxExtent,
                        onRefresh: () =>
                            ref.read(LibraryProviders.state.notifier).update(),
                      ),
                    ),
                  );
                },
                error: (e, _) => Text('$e'),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                skipLoadingOnReload: true,
                skipLoadingOnRefresh: true,
              );
            },
          );
        }),
      ),
    );
  }
}
