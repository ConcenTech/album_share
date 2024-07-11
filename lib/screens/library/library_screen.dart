import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/app_scaffold.dart';
import '../../core/components/titlebar_buttons/preferences_button.dart';
import '../../core/components/titlebar_buttons/refresh_button.dart';
import '../../immich/asset_grid/immich_asset_grid_view.dart';
import '../../services/library/library_providers.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showTitleBar: true,
      titleBarIcons: const [RefreshButton(),PreferencesButton()],
      body: Center(
        child: Consumer(builder: (context, ref, child) {
          final renderList = ref.watch(LibraryProviders.renderList);
          return renderList.when(
            data: (renderList) {
              if (renderList.isEmpty) {
                return Center(
                  child: Column(
                    
                    children: [
                      const Text('No files shared with you yet.'),
                      FilledButton(
                        onPressed: () {
                          ref.read(LibraryProviders.assets.notifier).update();
                        },
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                );
              }
              return ImmichAssetGridView(
                renderList: renderList,
                assetsPerRow: 4,
                onRefresh: () =>
                    ref.read(LibraryProviders.assets.notifier).update(),
              );
            },
            error: (e, _) => Text('$e'),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }),
      ),
    );
  }
}
