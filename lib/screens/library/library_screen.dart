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
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  Text('Please wait. Building Library')
                ],
              );
            },
            built: (_) {
              final maxExtent = ref.watch(PreferencesProviders.maxExtent);
              final dynamicLayout =
                  ref.watch(PreferencesProviders.dynamicLayout);
              final renderList = ref.watch(LibraryProviders.renderList);

              return renderList.when(
                data: (renderList) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: ImmichAssetGridView(
                      dynamicLayout: dynamicLayout,
                      showStack: true,
                      renderList: renderList,
                      assetMaxExtent: maxExtent,
                      onRefresh: () =>
                          ref.read(LibraryProviders.state.notifier).update(),
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
