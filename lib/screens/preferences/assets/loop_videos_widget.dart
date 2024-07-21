import 'package:flutter/material.dart';

import '../../../core/components/platform_list_tile.dart';

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
      title: const Text('Loop videos'),
      value: value,
      onChanged: onChanged,
    );
  }
}
