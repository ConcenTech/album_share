import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/app_scaffold.dart';
import '../../core/components/titlebar_buttons/preferences_button.dart';
import '../../core/components/titlebar_buttons/refresh_button.dart';
import '../../immich/asset_grid/immich_asset_grid_view.dart';
import '../../services/library/library_providers.dart';
import '../../services/preferences/preferences_providers.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

   /// assets need different hero tags across tabs / modals
    /// otherwise, hero animations are performed across tabs (looks buggy!)
    int heroOffset() {
      const int range = 1152921504606846976; // 2^60
      return range * 7;
    }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showTitleBar: true,
      titleBarIcons: const [RefreshButton(), PreferencesButton()],
      body: Center(
        child: Consumer(builder: (context, ref, child) {
          final maxExtent = ref.watch(PreferencesProviders.maxExtent);

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
              final renderList = ref.watch(LibraryProviders.renderList);
              return renderList.when(
                data: (renderList) {
                  return ImmichAssetGridView(
                    renderList: renderList,
                    assetMaxExtent: maxExtent,
                    onRefresh: () =>
                        ref.read(LibraryProviders.state.notifier).update(),
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
