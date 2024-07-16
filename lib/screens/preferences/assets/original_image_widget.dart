import 'package:flutter/material.dart';

import '../../../core/components/platform_list_tile.dart';

class OriginalImageWidget extends StatelessWidget {
  const OriginalImageWidget({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final void Function(bool v) onChanged;

  @override
  Widget build(BuildContext context) {
    return PlatformSwitchListTile(
      title: const Text('Load original image'),
      subtitle: const Text(
        'Enable to load the original full-resolution image (large!).\n'
        'Disable to reduce data usage (both network and on device cache).',
      ),
      isThreeLine: true,
      value: value,
      onChanged: onChanged,
    );
  }
}
