import 'package:album_share/core/components/titlebar_buttons/preferences_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/app_scaffold.dart';
import '../../routes/app_router.dart';
import '../../services/auth/auth_providers.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showTitleBar: true,
      titleBarIcons: const [PreferencesButton()],
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            return FilledButton(
              onPressed: () async {
               final isLoggedOut = await ref.read(AuthProviders.service).logout();
                if (isLoggedOut && context.mounted) {
                  AppRouter.toLogin(context);
                }
              },
              child: child,
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
