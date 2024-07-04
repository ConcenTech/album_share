import 'package:flutter/material.dart';

import '../../../routes/app_router.dart';

class PreferencesButton extends StatelessWidget {
  const PreferencesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () => AppRouter.toPreferences(context),
      iconSize: 18,
      style: IconButton.styleFrom(
        minimumSize: const Size(25, 25),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
