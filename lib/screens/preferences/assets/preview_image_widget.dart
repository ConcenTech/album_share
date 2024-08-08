import 'package:flutter/material.dart';

import '../../../core/components/platform_list_tile.dart';
import '../../../core/utils/app_localisations.dart';

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
    final locale = AppLocalizations.of(context)!;
    return PlatformSwitchListTile(
      title: Text(locale.loadPreviewImage),
      subtitle: Text(locale.loadPreviewImageDescription),
      isThreeLine: true,
      value: value,
      onChanged: onChanged,
    );
  }
}
