import 'package:flutter/material.dart';

import '../../../core/components/platform_list_tile.dart';
import '../../../core/utils/app_localisations.dart';

class LoopVideosWidget extends StatelessWidget {
  const LoopVideosWidget({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final void Function(bool v) onChanged;

  @override
  Widget build(BuildContext context) {
    return PlatformSwitchListTile(
      title: Text(AppLocalizations.of(context)!.loopVideos),
      value: value,
      onChanged: onChanged,
    );
  }
}
