import 'package:album_share/core/utils/extension_methods.dart';
import 'package:album_share/services/providers/app_bar_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrouter/vrouter.dart';

import '../../core/components/scaffold/app_scaffold.dart';
import 'asset_viewer_screen_state.dart';

class AssetViewerScreen extends ConsumerStatefulWidget {
  const AssetViewerScreen({super.key});

  @override
  ConsumerState<AssetViewerScreen> createState() => _AssetViewerScreenState();
}

class _AssetViewerScreenState extends ConsumerState<AssetViewerScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _hideAppBar());
  }

  void _hideAppBar() {
    ref.read(appBarListenerProvider.notifier).hideIn(1.seconds);
  }

  @override
  Widget build(BuildContext context) {
    final route = VRouter.of(context);
    final routeState = AssetViewerScreenState.fromQuery(route.queryParameters);

    return AppScaffold(
      showTitleBar: true,
      showBackButton: true,
      body: Positioned.fill(
        child: Consumer(builder: (context, ref, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () =>
                    ref.read(appBarListenerProvider.notifier).hide(),
                child: Text('Hide'),
              ),
              FilledButton(
                onPressed: () =>
                    ref.read(appBarListenerProvider.notifier).show(),
                child: Text('Show'),
              ),
            ],
          );
        }),
      ),
    );
  }
}
