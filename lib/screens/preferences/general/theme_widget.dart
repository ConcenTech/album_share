import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

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
    return ListTile(
      title: const Text(kTheme),
      trailing: SizedBox(
        width: 90,
        // height: 60
        child: DropdownButtonFormField(
          value: value,
          items: const [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text(kAutomatic),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text(kLight),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text(kDark),
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
