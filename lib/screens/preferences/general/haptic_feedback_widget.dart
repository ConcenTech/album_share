import 'package:flutter/material.dart';

import '../../../core/components/platform_list_tile.dart';
import '../../../core/utils/app_localisations.dart';

class HapticFeedbackWidget extends StatelessWidget {
  const HapticFeedbackWidget({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final void Function(bool v) onChanged;

  @override
  Widget build(BuildContext context) {
    return PlatformSwitchListTile(
      title: Text(AppLocalizations.of(context)!.enableHaptics),
      value: value,
      onChanged: onChanged,
    );
  }
}
