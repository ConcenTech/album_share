import 'package:flutter/material.dart';

import '../../core/components/scaffold/app_scaffold.dart';
import '../../core/main/platform_app.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_localisations.dart';

class ThemedMaterialScaffold extends StatelessWidget {
  const ThemedMaterialScaffold({required this.child, super.key});

  final Widget child;

  static const id = 'splash';

  @override
  Widget build(BuildContext context) {
    return PlatformApp.splash(
      key: const ValueKey('Init_Platform_App'),
      title: AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      mode: ThemeMode.system,
      child: AppScaffold(
        id: id,
        showTitleBar: false,
        body: child,
        isSplash: true,
      ),
    );
  }
}
