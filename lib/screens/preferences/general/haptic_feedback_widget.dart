import 'package:flutter/material.dart';

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
    return SwitchListTile(
      title: const Text('Enable haptic feedback'),
      value: value,
      onChanged: onChanged,
    );
  }
}
