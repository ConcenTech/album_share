import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import '../../constants/constants.dart';
import '../../core/components/app_scaffold.dart';
import '../../core/theme/app_theme.dart';

class ThemedMaterialScaffold extends StatelessWidget {
  const ThemedMaterialScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    return VRouter(
      key: const ValueKey('Init_Material_App'),
      title: kAppTitle,
      theme: theme.lightTheme(),
      darkTheme: theme.darkTheme(),
      mode: VRouterMode.history,
      routes: [
        VWidget(
          path: r':_(.+)',
          widget: AppScaffold(
            showTitleBar: false,
            body: child,
          ),
        ),
      ],
    );
  }
}
