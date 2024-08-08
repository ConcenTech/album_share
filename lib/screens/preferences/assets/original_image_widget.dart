import 'package:album_share/core/utils/app_localisations.dart';
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
    final locale = AppLocalizations.of(context)!;
    return PlatformSwitchListTile(
      title: Text(locale.loadOriginalImage),
      subtitle: Text(
        locale.loadOriginalImageDescription,
      ),
      isThreeLine: true,
      value: value,
      onChanged: onChanged,
    );
  }
}
