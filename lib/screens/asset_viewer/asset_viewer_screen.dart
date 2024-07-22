import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/scaffold/app_scaffold.dart';
import '../../core/utils/extension_methods.dart';
import '../../services/providers/app_bar_listener.dart';
import 'asset_viewer_screen_state.dart';
import 'asset_viewer_widget.dart';

class AssetViewerScreen extends ConsumerStatefulWidget {
  const AssetViewerScreen({
    required this.viewerState,
    super.key,
  });

  final AssetViewerScreenState viewerState;

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
    ref.read(appBarListenerProvider.notifier).hideIn(1.seconds, true);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showTitleBar: true,
      showBackButton: true,
      body: AssetViewerWidget(viewerState: widget.viewerState),
    );
  }
}
