import 'package:album_share/routes/app_router.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_localisations.dart';

class PasswordWidget extends StatelessWidget {
  const PasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.changePassword),
      trailing: IconButton(
        onPressed: () => AppRouter.toChangePassword(context),
        icon: const Icon(Icons.chevron_right),
      ),
      onTap: () => AppRouter.toChangePassword(context),
    );
  }
}
