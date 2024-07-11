import 'package:album_share/screens/preferences/sign_out_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/app_scaffold.dart';
import '../../services/preferences/preferences_notifier.dart';
import '../../services/preferences/preferences_providers.dart';
import 'theme_widget.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      showTitleBar: true,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: PreferencesWidget(),
      ),
    );
  }
}

class PreferencesWidget extends ConsumerWidget {
  const PreferencesWidget({super.key});

  PreferencesService _service(WidgetRef ref) =>
      ref.read(PreferencesProviders.service.notifier);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(PreferencesProviders.service);
    final captionStyle = Theme.of(context).textTheme.labelLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preferences', style: captionStyle),
        ThemeWidget(
          value: preferences.theme,
          onChanged: (v) => _service(ref).setTheme(v),
        ),
        Text('User', style: captionStyle),
        ListTile(
          title: const Text('Change password'),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_right),
          ),
          onTap: (){},
        ),
        const SignOutWidget(),
      ],
    );
  }
}
