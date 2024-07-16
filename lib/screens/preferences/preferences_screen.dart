import 'package:album_share/screens/preferences/assets/group_by_widget.dart';
import 'package:album_share/screens/preferences/assets/max_extent_widget.dart';
import 'package:album_share/screens/preferences/assets/original_image_widget.dart';
import 'package:album_share/screens/preferences/assets/preview_image_widget.dart';
import 'package:album_share/screens/preferences/general/haptic_feedback_widget.dart';
import 'package:album_share/screens/preferences/user/password_widget.dart';
import 'package:album_share/screens/preferences/user/sign_out_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/scaffold/app_scaffold.dart';
import '../../services/preferences/preferences_notifier.dart';
import '../../services/preferences/preferences_providers.dart';
import 'general/theme_widget.dart';

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
    final theme = Theme.of(context);
    final captionStyle = theme.textTheme.titleLarge?.copyWith(
      color: theme.colorScheme.primary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppScaffold.appBarHeight(context)),
        Text('Preferences', style: captionStyle),
        ThemeWidget(
          value: preferences.theme,
          onChanged: (v) => _service(ref).setValue(theme: v),
        ),
        HapticFeedbackWidget(
          value: preferences.enableHapticFeedback,
          onChanged: (v) => _service(ref).setValue(enableHapticFeedback: v),
        ),
        const Divider(),
        Text('Assets & thumbnails', style: captionStyle),
        PreviewImageWidget(
          value: preferences.loadPreview,
          onChanged: (v) => _service(ref).setValue(loadPreview: v),
        ),
        OriginalImageWidget(
          value: preferences.loadOriginal,
          onChanged: (v) => _service(ref).setValue(loadOriginal: v),
        ),
        GroupByWidget(
          value: preferences.groupBy,
          onChanged: (v) => _service(ref).setValue(groupBy: v),
        ),
        MaxExtentWidget(
          maxExtent: preferences.maxExtent,
          onChanged: (v) => _service(ref).setValue(maxExtent: v),
        ),
        const Divider(),
        Text('User', style: captionStyle),
        const PasswordWidget(),
        const SignOutWidget(),
      ],
    );
  }
}
