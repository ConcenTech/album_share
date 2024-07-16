import 'package:flutter/material.dart';

import '../utils/platform_utils.dart';

/// Flutter [SwitchListTile] renders switches oversized on desktop.
///
/// This widget wraps the switch inside of a [Transform.scale].
class PlatformSwitchListTile extends StatelessWidget {
  const PlatformSwitchListTile({
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final Widget? title;
  final Widget? subtitle;
  final bool isThreeLine;
  final bool value;
  final void Function(bool v) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      isThreeLine: isThreeLine,
      onTap: () => onChanged(!value),
      trailing: Transform.scale(
        scale: forPlatform(desktop: () => 0.8, mobile: () => 1.0),
        child: Switch(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
