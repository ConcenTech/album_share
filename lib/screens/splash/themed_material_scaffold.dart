import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../core/components/scaffold/app_scaffold.dart';
import '../../core/theme/app_theme.dart';
import '../../routes/platform_app.dart';

class ThemedMaterialScaffold extends StatelessWidget {
  const ThemedMaterialScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PlatformApp.splash(
      key: const ValueKey('Init_Platform_App'),
      title: kAppTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      mode: ThemeMode.system,
      child: AppScaffold(
        showTitleBar: false,
        body: child,
      ),
    );
  }
}
