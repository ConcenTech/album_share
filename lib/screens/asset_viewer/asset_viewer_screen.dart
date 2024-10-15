import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/scaffold/app_scaffold.dart';
import '../../core/components/sidebar/activity_sidebar.dart';
import '../../core/components/titlebar_buttons/activity_button.dart';
import '../../core/utils/extension_methods.dart';
import '../../models/asset.dart';
import '../../services/providers/app_bar_listener.dart';
import '../../services/providers/sidebar_listener.dart';
import 'asset_viewer_screen_state.dart';
import 'asset_viewer_widget.dart';

class AssetViewerScreen extends ConsumerStatefulWidget {
  const AssetViewerScreen({
    required this.viewerState,
    super.key,
  });

  static const id = 'asset_viewer_screen';

  final AssetViewerScreenState viewerState;

  @override
  ConsumerState<AssetViewerScreen> createState() => _AssetViewerScreenState();
}

class _AssetViewerScreenState extends ConsumerState<AssetViewerScreen> {
  Asset? _asset;

  @override
  void initState() {
    super.initState();
    final state = widget.viewerState;
    _asset = state.renderList.loadAsset(state.initialIndex);
    if (state.showActivity) {
      _postFrameCallback(_showSidebar);
    } else {
      _postFrameCallback(_hideAppBar);
    }
  }

  void _postFrameCallback(VoidCallback callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) => callback());
  }

  void _hideAppBar() {
    ref.read(appBarListenerProvider.notifier).hideIn(500.milliseconds, true);
  }

  void _showSidebar() {
    ref.read(sidebarListenerProvider(AssetViewerScreen.id).notifier).open();
  }

  @override
  Widget build(BuildContext context) {
    final bool showActivity = _asset != null;
    return AppScaffold(
      id: AssetViewerScreen.id,
      showTitleBar: true,
      showBackButton: true,
      header: widget.viewerState.album?.name,
      titleBarIcons: [
        if (showActivity) const ActivityButton(AssetViewerScreen.id),
      ],
      sidebar: showActivity
          ? ActivitySidebar(
              asset: _asset!,
              album: widget.viewerState.album,
            )
          : null,
      body: AssetViewerWidget(
        viewerState: widget.viewerState,
        onChanged: (asset) {
          setState(() {
            _asset = asset;
          });
        },
      ),
    );
  }
}
