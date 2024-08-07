import 'package:flutter/material.dart';

import '../../../core/utils/app_localisations.dart';

class ThemeWidget extends StatelessWidget {
  const ThemeWidget({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final ThemeMode value;
  final void Function(ThemeMode value) onChanged;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return ListTile(
      title: Text(locale.theme),
      trailing: SizedBox(
        width: 90,
        // height: 60
        child: DropdownButtonFormField(
          value: value,
          items: [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text(locale.automatic),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text(locale.light),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text(locale.dark),
            ),
          ],
          autofocus: false,
          onChanged: (v) => onChanged(v!),
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
