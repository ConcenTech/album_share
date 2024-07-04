import 'package:flutter/material.dart';

import '../../../routes/app_router.dart';

class TitlebarBackButton extends StatelessWidget {
  const TitlebarBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => AppRouter.back(context),
      icon: const Icon(Icons.chevron_left),
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
