import 'package:flutter/material.dart';

class PreviewImageWidget extends StatelessWidget {
  const PreviewImageWidget({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final void Function(bool v) onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Load preview image'),
      subtitle: const Text(
        'Enable to load a medium-resolution image.\n'
        'Disable to either directly load the original or only use the thumbnail.',
      ),
      isThreeLine: true,
      value: value,
      onChanged: onChanged,
    );
  }
}
