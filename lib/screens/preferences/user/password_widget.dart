import 'package:flutter/material.dart';

import '../../../core/utils/app_localisations.dart';

class PasswordWidget extends StatelessWidget {
  const PasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.changePassword),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.chevron_right),
      ),
      onTap: () {},
    );
  }
}
