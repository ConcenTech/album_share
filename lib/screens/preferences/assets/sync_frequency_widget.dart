import 'package:flutter/material.dart';

import '../../../core/utils/app_localisations.dart';

class SyncFrequencyWidget extends StatelessWidget {
  const SyncFrequencyWidget({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final int value;
  final void Function(int value) onChanged;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(locale.syncFrequency),
      subtitle: Text(locale.syncFrequencyDescription),
      trailing: SizedBox(
        width: 150,
        // height: 60
        child: DropdownButtonFormField(
          initialValue: Duration(seconds: value),
          items: [
            DropdownMenuItem(
              value: const Duration(minutes: 5),
              child: Text(locale.fiveMinutes),
            ),
            DropdownMenuItem(
              value: const Duration(minutes: 15),
              child: Text(locale.fifteenMinutes),
            ),
            DropdownMenuItem(
              value: const Duration(minutes: 30),
              child: Text(locale.thirtyMinutes),
            ),
            DropdownMenuItem(
              value: const Duration(hours: 1),
              child: Text(locale.oneHour),
            ),
            DropdownMenuItem(
              value: const Duration(hours: 2),
              child: Text(locale.twoHours),
            ),
            DropdownMenuItem(
              value: const Duration(hours: 4),
              child: Text(locale.fourHours),
            ),
            DropdownMenuItem(
              value: const Duration(hours: 8),
              child: Text(locale.eightHours),
            ),
            DropdownMenuItem(
              value: const Duration(hours: 12),
              child: Text(locale.twelveHours),
            ),
          ],
          autofocus: false,
          onChanged: (v) => onChanged(v!.inSeconds),
          focusColor: Colors.transparent,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
